<#
.SYNOPSIS
	Reports where an account is being locked out from.
.DESCRIPTION
	Searches domain controllers for lock out events for a specific user account and eventID 4740.
	Helps to determine where an account is getting locked out from. For example a mobile
	device that has not been updated with a new password.
.PARAMETER Identity
	Specifies the account to search for. samAccountName is the best value to search
	for.
.PARAMETER Credential
	Specifies the an account which has rights to perform a winevent query against a DC.
.EXAMPLE
	C:\PS>c:\etc\scripts\get-lockedoutlocation.ps1 -Identity logonname -Credential $admincreds
	Example of how to use this cmdlet
.NOTES
	===========================================================================
	Created with: 	Visual Studio Code
	Created on:   	04.14.2017
	Created by:   	John Kavanagh
	Organization: 	KavanaghTech
	Filename:     	get-lockedoutlocation.ps1
	===========================================================================
	04.14.2017 JJK: Converted from function to script process
	05.24.2017 JJK:	TODO: Add break if account is not lockedout
	05.24.2017 JJK:	ADDED Add credential param for winevent call
#>
[CmdletBinding()]
Param(
	[Parameter(Mandatory = $true,
		ValueFromPipeline = $true,
		ValueFromPipelineByPropertyName = $true,
		HelpMessage = "Enter the samAccountName to report on")]
	[String]$Identity,
	[Parameter(Mandatory = $false,
		ValueFromPipeline = $true,
		HelpMessage = 'Ensure you are using the correct credentials for this operation')]
	[System.Management.Automation.PSCredential]$Credential
)
Begin {
	$DCCounter = 0
	$LockedOutStats = @()
	# Just in case current environment has Module AutoLoad disabled
	Try {
		Import-Module ActiveDirectory -ErrorAction Stop
	}
	Catch {
		Write-Warning $_
		Break
	}
}#end begin
Process {
	#Get all domain controllers in domain
	$DomainControllers = Get-ADDomainController -Filter *
	$PDCEmulator = ($DomainControllers | Where-Object {$_.OperationMasterRoles -contains "PDCEmulator"})
	Write-Verbose "Finding the domain controllers in the domain"
	Foreach($DC in $DomainControllers) {
		$DCCounter++
		Write-Progress -Activity "Contacting DCs for lockout info" -Status "Querying $($DC.Hostname)" -PercentComplete (($DCCounter/$DomainControllers.Count) * 100)
		Try {
			$UserInfo = Get-ADUser -Identity $Identity  -Server $DC.Hostname -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut -ErrorAction Stop
		}
		Catch {
			Write-Warning $_
			Continue
		}
		If ($UserInfo.LastBadPasswordAttempt) {
			$LockedOutStats += New-Object -TypeName PSObject -Property @{
				Name                   = $UserInfo.SamAccountName
				SID                    = $UserInfo.SID.Value
				LockedOut              = $UserInfo.LockedOut
				BadPwdCount            = $UserInfo.BadPwdCount
				BadPasswordTime        = $UserInfo.BadPasswordTime
				DomainController       = $DC.Hostname
				AccountLockoutTime     = $UserInfo.AccountLockoutTime
				LastBadPasswordAttempt = ($UserInfo.LastBadPasswordAttempt).ToLocalTime()
			}#end PSCustomObject
		}#end if
	}#end foreach DCs
	$LockedOutStats | Format-Table -Property Name,LockedOut,DomainController,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt -AutoSize
	#Get User Info
	Try {
		Write-Verbose "Querying event log on $($PDCEmulator.HostName)"
		$LockedOutEvents = Get-WinEvent -ComputerName $PDCEmulator.HostName -FilterHashtable @{LogName = 'Security'; Id = 4740} -ErrorAction Stop -Credential $Credential | Sort-Object -Property TimeCreated -Descending
	}
	Catch {
		Write-Warning $_
		Continue
	}#end catch

	Foreach($Event in $LockedOutEvents) {
		If($Event | Where-Object {$_.Properties[2].value -match $UserInfo.SID.Value}) {
			$Event | Select-Object -Property @(
				@{Label = 'User';               Expression = {$_.Properties[0].Value}}
				@{Label = 'DomainController';   Expression = {$_.MachineName}}
				@{Label = 'EventId';            Expression = {$_.Id}}
				@{Label = 'LockedOutTimeStamp'; Expression = {$_.TimeCreated}}
				@{Label = 'Message';            Expression = {$_.Message -split "`r" | Select-Object -First 1}}
				@{Label = 'LockedOutLocation';  Expression = {$_.Properties[1].Value}}
			)
		}#end ifevent
	}#end foreach lockedout event
}#end process

