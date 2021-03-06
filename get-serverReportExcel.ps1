#Requires -Module ImportExcel
<#
.SYNOPSIS
	Server Report to Excel
.DESCRIPTION
	ActiveDirectory Query for all Computer objects with OperatingSystem name like Server. Query selects
	Name, DistinguishedName, OperatingSystem, Description and then calculates the online status with the 
	test-connection cmdlet. ImportExcel Module is then used to store the query results in an Excel file.
.EXAMPLE
	C:\etc\scripts>.\get-serverreportexcel.ps1
	Example of how to use this cmdlet
.OUTPUTS
	Excel File
.LINK ImportExcel Module
	https://github.com/dfinke/ImportExcel
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		05.23.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		get-serverReportExcel.ps1
	===========================================================================
	05.22.2017 JJK:	Removed verbose from Export-Excel
	05.22.2017 JJK:	TODO: Use PSCustomObject to replace Select-Object
	05.22.2017 JJK: Added timer to report script duration
	05.22.2017 JJK: Set rptname param to name table same as sheetname
	05.22.2017 JJK: Removed OnLine loop as this will trigger security
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param (
	$timer=[System.Diagnostics.Stopwatch]::StartNew(),
	[String]$rptname,
	$Report = @()
)
$timer.start()
$rptname = get-date -f MMddyyyHHmm
"Gathering servers"
$adServers = get-adcomputer -Filter {OperatingSystem -like "*Server*"} -Properties OperatingSystem,Description 
Write-progress -Activity "Creating records"
ForEach ($srv in $adservers | Sort-Object -Property Name){
	$i++
	Write-Progress -Activity "Evaluating $($srv.Name)" -Status "Percent Processed:" -PercentComplete (($i/$adservers.count) * 100) -CurrentOperation $i
	<#
	If (test-connection -ComputerName $srv.Name -Count 1 -ErrorAction SilentlyContinue){
		$Online = $True
	}
	Else {
		$Online = $False
	}
	#>
    $obj = [pscustomobject]@{
        Name              = $srv.name
        DistinguishedName = $srv.DistinguishedName
        OperatingSystem   = $srv.OperatingSystem
        Description       = $srv.Description
    }
	$Report += $obj
}
"Writing {0} Server objects to Excel Worksheet" -f $adServers.count
#$serverlist | sort-object -Property Name |  Export-Excel -Path c:\etc\serverlist.xlsx -WorkSheetname $rptname -TableName $rptname
$Report |  Export-Excel -Path c:\etc\serverlist.xlsx -WorkSheetname $rptname -TableName "Servers-$rptname" -AutoSize
$timer.Stop()
"The script took {0} minutes to complete" -f ($timer.elapsed.TotalSeconds / 60)