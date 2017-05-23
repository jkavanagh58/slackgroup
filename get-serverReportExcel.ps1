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
	date initials: Enter first comment here
#>

$adServers = get-adcomputer -Filter {OperatingSystem -like "*Server*"} -Properties OperatingSystem,Description | 
select Name, DistinguishedName, OperatingSystem, Description,
	@{Name="Online";Exp={if(test-connection -ComputerName $_.Name -Count 1 -Quiet){$Online=$True}Else{$Online=$False}}} |
sort-Object -Property Name 
"Writing {0} Server objects to Excel Worksheet" -f $adServers.count
$adServers = Export-Excel -Path c:\etc\serverlist.xlsx -WorkSheetname (get-date -F MMddyyyy) -TableName wfm -PassThru