# Scratch file for submitting code, tips, snippets, etc...

Unlock-AdAccount -Identity jktest -Verbose
if ((get-aduser jktest -Properties LockedOut).LockedOut){Unlock-ADAccount -Identity jktest -Verbose}  

# testing regex
$String="12.1.1.1"
$IPv4Regex = '((?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d))'
[regex]::Matches($String, $IPv4Regex) 

# How to lock an account
$Password = ConvertTo-SecureString 'NotMyPassword' -AsPlainText -Force
Get-AdUser jktest |
ForEach {
Do {
    Invoke-Command -ComputerName dc01 {Get-Process } -Credential (New-Object System.Management.Automation.PSCredential ($($_.UserPrincipalName), $Password)) -ErrorAction SilentlyContinue
}
Until ((Get-ADUser -Identity $_.SamAccountName -Properties LockedOut).LockedOut)
}
# Code used to lock the test account
$badacct = Get-Credential   # in the credential window I used orion-hq\jktest and a invalid password
Do {
	# run this command using an invalid password
    invoke-command {get-process} -computername clvprddom007 -Credential $badacct
}
# the command runs enough times to lock it out and then stops
Until ((get-aduser -identity jktest -Properties LockedOut).LockedOut) 

# Qualified Function for unlocking an AD account
function unlock-anaccount {
<#
	.SYNOPSIS
		Used to unlock an AD account
	.DESCRIPTION
		Using the provided logon name this function will attempt to unlock the AD account.
	.PARAMETER logonName
		This value should match the User Account samAccountName aka User Logon Name from AD Users and Computers.
	.EXAMPLE
				PS C:\> unlock-anaccount -logonName 'Value1'	
	.NOTES
		03.06.2017 JJK: Function written and added to profile.ps1
        03.06.2017 JJK: TODO: Modify paramater validation to perform search-adaccount to consolidate validating
                        account and validating it is currently locked out
						TODO: Validate user account attempting to unlock the account has permissions
#>
[CmdletBinding()]
param
(
	[Parameter(Mandatory = $true,
			   ValueFromPipeline = $true,
			   Position = 1,
			   HelpMessage = 'Enter the samAccountName for the account to be unlocked.')]
	[ValidateScript({ get-aduser $_ })]
	[System.String]$logonName
)
Begin {
	"Account validated, attempting to unlock the account"
}
Process {
	If ((Get-ADUser -Identity $logonName -Properties LockedOut).LockedOut) {
		# Get the User Account from AD
		$acctDetails = Get-ADUser -Identity $logonName
		"Unlocking Account for {0}" -f $acctDetails.Name
		try {
			$acctDetails | Unlock-ADAccount -Verbose -ErrorAction SilentlyContinue
		}
		Catch {
			Wite-Warning -Message "Unable to unlock account"
			$Error[0].ErrorDetails.Message
		}
	}
	Else {
		"The account for {0} is not currently LockedOut" -f $acctDetails.Name
	}
}
End {
	"Finished processing Unlock task for {0}" -f $logonName
}
} # Unlock-anAccount function end




# ----Testing PowerShell Snippets -----
$obj = [pscustomobject]@{
	FieldName = FieldValue;
}

# Test easy snippet maker
Try {
	# SOME CODE
}
Catch{
	Write-Warning -Message "Some informative message to user"
}
Begin {
	Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($mycommand.myinvocation)"
}


# /* Below here is where I am testing work with snippets
# TODO: Library any snippets added

[Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage = $1:helpmessage)]
        [String]$2:parametername

		# Let's try it
		# help message and parametername are tab stops
Param(
	[Parameter(Mandatory=$true,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage = "Test message")]
		[String]$varParam
)

# Custom object Snippet
# Prefix "pscustom"
$obj = [pscustomobject]@{
	FieldName = FieldValue;
}

# Param with validation script
# Prefix "manparamvalidate"
Param(
	[Parameter(Mandatory = $true,
		ValueFromPipeline = $true,
		Position = 1,
		HelpMessage = "Type the help message here in quotes")]
		[ValidateScript({ test-path $_ })]
		[System.String]$varSome
	
)
