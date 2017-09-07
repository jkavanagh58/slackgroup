[CmdletBinding()]
Param(
	[Parameter(Mandatory = $true,
		ValueFromPipeline = $true,
		HelpMessage = "Enter Help Message Here")]
		[ValidatePattern('(Mo(n(day)?)?|Tu(e(sday)?)?|We(d(nesday)?)?|Th(u(rsday)?)?|Fr(i(day)?)?|Sa(t(urday)?)?|Su(n(day)?)?)')]
	[System.String]$DOWPattern,
	[Parameter(Mandatory = $true,
		ValueFromPipeline = $true,
		HelpMessage = "Enter Help Message Here")]
		[ValidateSet("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")]
	[System.String]$DOWSet
)
$DOWPattern
$DOWSet