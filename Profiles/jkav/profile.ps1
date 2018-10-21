Function Prompt {
	$admRole = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	If ($psversiontable.psversion.Major -lt 6){
		If ($admRole) {
			$host.ui.RawUI.WindowTitle = "KavanaghTech (Admin)"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "PS # " -NoNewline
			return ' '
		}
		Else {
			$host.ui.RawUI.WindowTitle = "KavanaghTech"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host " PS >_ " -NoNewline
			return ' '
		}
	}
	ElseIf ($psversiontable.psversion.Major -ge 6){
		If ($admrole){
			$host.ui.RawUI.WindowTitle = "KavanaghTech (Admin)"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "sudo # " -NoNewline
			return ' '
		}
		Else {
			$host.ui.RawUI.WindowTitle = "KavanaghTech (Admin)"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "Core >_ " -NoNewline
			return ' '
		}
	}
}
function simple-countdown{
[CmdletBinding()]
Param(
	$curdate = (Get-Date),
	$curYear=(get-date).Year,
	$curxmas = "12/25/" + $curYear,
	$xmas = (Get-Date $curxmas),
	$tildays = ($xmas - $curdate).Days
)
Begin{}
Process{
if ($curdate.month -eq 12) {
	switch ($curdate.day)
	{
		{$_ -lt 25} {Write-Host $tildays -ForegroundColor Red -nonewline
					Write-Host " Days until Christmas" -ForegroundColor Blue}
		14 {Write-Host "Merry " -ForegroundColor Red -nonewline
			Write-Host "Christmas!" -ForegroundColor Green}
		default {
			$nextxmas = "12/25/" + ($curYear + 1)
			$xmas = Get-Date $nextxmas
			$tildays = ($xmas - $curdate).Days
			Write-Host $tildays -ForegroundColor Red -nonewline
			Write-Host " Days until Christmas" -ForegroundColor Blue}
	}
}
else {Write-Host $tildays -ForegroundColor Red -nonewline
	Write-Host " Days until Christmas" -ForegroundColor Yellow}
}
End {
	# Just clean up the variables created
	Remove-Variable -Name curdate, curxmas, curYear, tildays, xmas
}
}
Function Get-QOTD {
<#
.Synopsis
	Download quote of the day.
.Description
	Using Invoke-RestMethod download the quote of the day from the BrainyQuote RSS
	feed. The URL parameter has the necessary default value.
.Example
	PS C:\> get-qotd
	"We choose our joys and sorrows long before we experience them." - Khalil Gibran
.Link
	Invoke-RestMethod
#>
	[cmdletBinding()]

	Param(
	[Parameter(Position=0)]
	[ValidateNotNullorEmpty()]
	[string]$Url="http://feeds.feedburner.com/brainyquote/QUOTEBR"
	)

	Write-Verbose "$(Get-Date) Starting Get-QOTD"
	Write-Verbose "$(Get-Date) Connecting to $url"

	Try
	{
		#retrieve the url using Invoke-RestMethod
		Write-Verbose "$(Get-Date) Running Invoke-Restmethod"

		#if there is an exception, store it in my own variable.
		$data = Invoke-RestMethod -Uri $url -ErrorAction Stop -ErrorVariable myErr

		#The first quote will be the most recent
		Write-Verbose "$(Get-Date) retrieved data"
		$quote = $data[0]
	}
	Catch
	{
		$msg = "There was an error connecting to $url. "
		$msg += "$($myErr.Message)."

		Write-Warning $msg
	}
	#only process if we got a valid quote response
	if ($quote.description)
	{
		Write-Verbose "$(Get-Date) Processing $($quote.OrigLink)"
		#write a quote string to the pipeline
		"{0} - {1}" -f $quote.Description,$quote.Title
	}
	else
	{
		Write-Warning "Failed to get expected QOTD data from $url."
	}
	 Write-Verbose "$(Get-Date) Ending Get-QOTD"
} #end Get-QOTD
Set-Alias -name "qotd" -Value Get-QOTD
# Load credential management functions
. C:\etc\scripts\store-admcreds.ps1
# Load personal functions from external script
. C:\etc\scripts\system-functions.ps1
# Run cmds
$admcreds = set-adm
import-module psreadline
simple-countdown
qotd
"================================================"
#get-weather -zipCode 44011
"------------------------------------------------"
"`tRunning PowerShell $($PSVersionTable.PSVersion)"
"------------------------------------------------"


# SIG # Begin signature block
# MIIFdgYJKoZIhvcNAQcCoIIFZzCCBWMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6anxXNCmreA7rX8KbfdD7348
# DwGgggMOMIIDCjCCAfKgAwIBAgIQXYb1moDIJY5FrtZ1AHC1WjANBgkqhkiG9w0B
# AQUFADAdMRswGQYDVQQDDBJTZWN1cml0eURlcGFydG1lbnQwHhcNMTgwNTAyMTIy
# NDQ5WhcNMjMwNTAyMTIzNDQ5WjAdMRswGQYDVQQDDBJTZWN1cml0eURlcGFydG1l
# bnQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZRBiw8TofNwNueBUN
# DTzPuQfXc25qEptYFAOYV5Ii3Zw83EGVoxXquidN03KM44KQD3eWDpbaCDx0l97U
# 7bNMZSuSZndgekblUI21EeXPoYsfqM4Q9Ewab0+gE1qbc8Z1wwQRRHvel5pgLnrO
# adm16E9b6eE0RKGoK81Qjpp6zM14/tJ6ieValvUDbStoAcjporvao8/maJMUlCH2
# 9jdHqLzo8D+jTKLNXza1hjDrly+drSjXSp1wXVTvfmqLDLfTTG6nJDrkianXL4cf
# GEamCDen/VdloBVRPJM+ifGd7CBt0ubkw28twfB0Ggo4Y2AR54DRmxhqeNMWgjuG
# GUFBAgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcD
# AzAdBgNVHQ4EFgQU5l8CWDBVYathbXCOsFrTy8b1lYIwDQYJKoZIhvcNAQEFBQAD
# ggEBACfA56qtFHE6RHK5cFGljYdiB+tU25LxL3MZFTRUeUctDQ31vv7vOO//Zyek
# aE768oz/CzGI4u6USVVWRKFhU+99VaLFAs/wDn4o+1wCwk+81gaf8Dn8sndm29eL
# KyHAZzR8/tXbz84+KgD4SZ8HGKYu6wSVJ4RbRUGvxiOYyrjl7kVPnyg7hE+zgXA1
# 1u52sfKkyITxs8uujwL/hMGSb2YfMi4xA6Ik8kzsJ5rPGar1FRRZd83yTljp0UT+
# CRP4jD2c+lPwq6h+/h6XIT61UY0Ym51Dy6W2hwkkxwXhqAVQXrAlf60p3xbh7Gxj
# QORXHMyrzBGivtec6adYYf0JWbwxggHSMIIBzgIBATAxMB0xGzAZBgNVBAMMElNl
# Y3VyaXR5RGVwYXJ0bWVudAIQXYb1moDIJY5FrtZ1AHC1WjAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUNL+DBunJM+jA70ITjyFMQzeDPNUwDQYJKoZIhvcNAQEBBQAEggEAgpYWF8Ey
# rfHNJeYMz2sKrL58wR35KaJ4CFN7I9Jp2stt837sdHhr9JFNwXUX7yHuXjskepj5
# OQFdIDvpxnTCkYjB+wmbbCSKrXhKGH0vFhAhLjtjqtp6hpepZ5OveeH0YIFPclMC
# wzlLUvnpydYsxX19r1tIgpyo/vh+HZBz1ukUW1ZE3jNl7vFfzhinS6ydlyUlStyR
# EOGr3JI62Vhs1QWo34M8uSrM7V3tWFEtZPa6VT0tOV2I8l/Vo3ZYK0NIaV/uzi2A
# cLJ9TmB2zIrB3sEs83XvgPn2Vt9quah6fTJmfCpi4cshNxNBTwb3q3XGdn5Gzb0p
# EJR1YTeoPaeG/w==
# SIG # End signature block
