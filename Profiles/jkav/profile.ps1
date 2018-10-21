Function Prompt {
	$admRole = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    If ($admRole) {
		$host.ui.RawUI.WindowTitle = "Admin Console"
		Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "PS # " -NoNewline
		return ' '
	}
	Else {
		$host.ui.RawUI.WindowTitle = "Windows PowerShell"
		Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host " PS >_ " -NoNewline
		return ' '
	}
}
Function backup-hostsfile {
[CmdletBinding()]
Param(
	[parameter(Mandatory=$False, ValueFromPipeline=$True,
		HelpMessage = "Source File")]
	[System.String]$hostsSource = "$env:windir\system32\drivers\etc\hosts",
	[parameter(Mandatory=$False, ValueFromPipeline=$True,
		HelpMessage = "Cloud location for hosts file")]
	[System.String]$hostsBackup = "C:\Users\johnk\OneDrive\Documents\Tech\Tools\HomeNet"
)
BEGIN {
	# Need to break out for each variable...
	If ((Test-Path $hostsSource -erroraction silentlycontinue) -AND (Test-Path $hostsBackup -ErrorAction SilentlyContinue) ){
		"Ready to backup hosts file"
	}
	Else {
		Write-Error "Please check your source and Cloud mapping"
		Exit
		}
}
PROCESS {
	Try {
		Copy-Item $hostsSource -Destination $hostsBackup -Force
	}
	Catch {
			"Unable to backup your hosts file"
			$Error[0].Exception.Message
	}
}
END {
	Remove-Variable -Name hostsSource, hostsBackup
	[System.GC]::Collect()	 
}
}
function simple-countdown {
[CmdletBinding()]
Param(
	$curdate = (Get-Date),
	$curYear=(get-date).Year,
	$curxmas = "12/25/" + $curYear,
	$xmas = (Get-Date $curxmas),
	$tildays = ($xmas - $curdate).Days
)
BEGIN{}
PROCESS{
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
END {
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
	if ($quote.description) {
		Write-Verbose "$(Get-Date) Processing $($quote.OrigLink)"
		#write a quote string to the pipeline
		"{0} - {1}" -f $quote.Description,$quote.Title
	}
	else {
		Write-Warning "Failed to get expected QOTD data from $url."
	}
	 Write-Verbose "$(Get-Date) Ending Get-QOTD"
} #end Get-QOTD
#Region Where it begins
Set-Alias -name "qotd" -Value Get-QOTD
# Load personal functions from external script
. C:\etc\scripts\system-functions.ps1
import-module psreadline
simple-countdown
$varSeparator = "=" * 62
$varSeparator
get-qotd
$varSeparator
#get-weather -zipCode 44011
"------------------------------------------------"
"`tRunning PowerShell $($PSVersionTable.PSVersion)"
"------------------------------------------------"
""
#EndRegion