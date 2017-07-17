Function test-ipaddr {
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
		[Parameter(Mandatory = $true,
			ValueFromPipeline = $true,
			Position = 1,
			HelpMessage = "Enter a valid IP address")]
			[ValidatePattern('^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')]
		[System.String]$ipaddress

)
# Could also use the following
# [ValidateScript({ $_ -match '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$' })]
$ipaddress
}