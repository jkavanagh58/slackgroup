#requires -Module ImportExcel
<#
.SYNOPSIS
	Short description
.DESCRIPTION
	Long description
.PARAMETER Path
	Specifies a path to one or more locations.
.PARAMETER LiteralPath
	Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
	is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
	it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
	characters as escape sequences.
.PARAMETER InputObject
	Specifies the object to be processed.  You can also pipe the objects to this command.
.EXAMPLE
	C:\PS>
	Example of how to use this cmdlet
.EXAMPLE
	C:\PS>
	Another example of how to use this cmdlet
.INPUTS
	Inputs to this cmdlet (if any)
.OUTPUTS
	Excel File
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
get-adcomputer -Filter {OperatingSystem -like "*Server*"} -Properties OperatingSystem,Description | 
select Name, DistinguishedName, OperatingSystem, Description,
 @{Name="Online";Exp={if(test-connection -ComputerName $_.Name -Count 1 -Quiet){$Online=$True}Else{$Online=$False}}} |
sort-Object -Property Name | 
Export-Excel -Path c:\etc\serverlist.xlsx -WorkSheetname (get-date -F MMddyyyy) -TableName wfm -PassThru