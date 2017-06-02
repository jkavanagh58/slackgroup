<#
.SYNOPSIS
	Short description
.DESCRIPTION
	Long description
.PARAMETER victim
	Computer name for machine to be restarted
.PARAMETER LiteralPath
	Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
	is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
	it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
	characters as escape sequences.
.PARAMETER timer
	Timer used to track how long the restart takes
.EXAMPLE
	C:\PS>
	Example of how to use this cmdlet
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		06.02.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		test-betterreboot.ps1
	===========================================================================
	06.02.2017 JJK:	TODO: Add graceful logoff process if necessary, since this is
					targetted for maintenance window this might be not necessary.
	06.02.2017 JJK:	TODO: Craft send-mail message for reboot notification.
	06.02.2017 JJK: Monitor reboot, notify if successful restart did not 
					occur within 90 seconds.
#>

[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
	[String]$victim,
	$timer = [System.Diagnostics.Stopwatch]::StartNew(),
	[boolean]$followUp = $False
)
"Restarting {0}" -f $victim
$usrInfo = quser /server:$victim 2>&1 | select-object -Skip 1
If ($usrInfo){
	# Uses force but process for graceful logoffs and then restart could be added
	"Users on the server"
	ForEach ($usr in $usrInfo){
		$temp = ($usr.Trim() -Replace '\s+',' ' -Split '\s')[0]
		"`t$temp"
	}
	Try {
		restart-computer -ComputerName $victim -Credential $admcreds -Wait -For WMI -TimeOut 90 -Force -Confirm:$False
	}
	Catch {
		$followUp = $True
	}
}
Else {
	"No users to be concerned about"
	Try {
		restart-computer -ComputerName $victim -Credential $admcreds -Wait -For WMI -TimeOut 90
	}
	Catch {
		$followUp = $True
	}
}
$timer.Stop()
# to console here but same data could be used for an email notification
If ($followUp){
	"{0} did not restart in a timely manner, please investigate" -f $victim, $timer.elapsed.TotalSeconds
}
Else {
	"{0} Rebooted successfully, reboot took {1} seconds" -f $victim, $timer.elapsed.TotalSeconds
}
