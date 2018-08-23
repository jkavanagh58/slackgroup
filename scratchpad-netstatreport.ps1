<#
.SYNOPSIS
	Match netstat to whitelisted ports
.DESCRIPTION
	Match netstat to whitelisted ports. Uses a CSV for whitelist import.
.PARAMETER wkFile
	Specifies a path to the whitelist CSV file to be used.
.EXAMPLE
	I ♥ vscode  >_ c:\Users\vndtekjxk\Documents\GitHub\slackgroup\scratchpad-netstatreport.ps1
	Runs the script without specifying a whitelist file, will use default file
.EXAMPLE
	C:\PS> .\scratchpad-netstatreport.ps1 -WhiteListFile c:\etc\somefile.csv
	Runs script from local directory and specifies a white list file
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		07.25.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		scratchpad-netstatreport.ps1
	===========================================================================
	07.25.2017 JJK:	Just a paired down version to show the whitelist match does work
	07.25.2017 JJK:	TODO: Remove variables and initiate garbage collection to cleanup
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
		[Parameter(Mandatory=$false,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true,
			HelpMessage = "Full path to WhiteList source file")]
		[Alias("WhiteList","WhiteListFile")]
		[String]$wlFile = "C:\etc\PPSB.csv"
)

Begin{
	"Loading whitelist file"
	$whitelist = Import-CSV -Path $wlFile
	$Report = @()
	"Gathering netstat data"
	$netstatValues = netstat -ano | Select-String -Pattern '\s+(TCP|UDP)'
	"Processing {0} records" -f $netstatValues.count
}
Process {
	ForEach ($val in $netstatValues){
		$item = $val.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
		$proto = $item[0]
		if ($item[1].startsWith("[")){
			$lclIPInfo = [IPAddress]$item[1]
		}
		Else {
			$lclIPInfo = [IPAddress]$item[1].Split(":")[0]
		} # Finished aquiring IP info
		$lclIPFamily = $lclIPInfo.AddressFamily
		$lclIPAddress = $lclIPInfo.IPAddressToString
		if ($item[1].startsWith("[")){
			$lclPort = $item[1].Split(":")[6]
		}
		Else {
			$lclPort = $item[1].Split(":")[1]
		} # Finished getting Port info
		If ($lclPort -in $whitelist.Port){
			$testValue = $True
		}
		Else {
			$testValue = $False
		} # Finished checking for Port number from whitelist
		$obj = [pscustomobject]@{
			Protocol      = $proto
			LocalIP       = $lclIPAddress
			LocalPort     = $lclPort
			LocalIPFamily = $lclIPFamily
			Test          = $testValue
		} # end building dataset
		$Report += $obj
	}
}
End {
	"{0} Records recorded with {1} records matching whitelist" -f $Report.Count, $Report.Where{$_.Test}.count
	<#
		Show recorded values
		$Report
		To show entries that match ports from WhiteList File
		$Report | where {$_.Test}
		To export those results you can use the following syntax
		$Report | where {$_.Test} | export-csv
	#>
	"Removing variables"
	Remove-Variable -Name obj,lcl*,testvalue, whitelist, proto, netstatValues, wlFile
	[System.GC]::Collect()
}


