#Requires -Module ImportExcel, PSScriptAnalyzer
<#
.SYNOPSIS
	Collect PowerShell ScriptAnalyzer reports to an Excel Workbook
.DESCRIPTION
	Leverages the PSScriptAnalyzer and ImportExcel modules to generate and Excel workbook with analysis.
.PARAMETER xlFile
	Specifies a full path for the resulting report file. Must include the extension with value of XLSX.
.PARAMETER repoFolder
	Specifies path to folder containing the scripts to be reported on.
.PARAMETER errOnly
	Specifies the report only include entries with the Severity of Error.
.EXAMPLE
	PS>_ ./get-pssareport.ps1
	Example of how to use this script to create a full PSSA report
.EXAMPLE
	PS>_ ./get-pssareport.ps1 -errOnly
	Another example of how to use this script to create a PSSA report of Errors only.
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		11.05.2019
	Created by:		John J. Kavanagh
	Organization:	KavanaghTech
	Filename:		get-pssareport.ps1
	===========================================================================
	11.05.2019 JJK:	DONE: Formalize to Include frompipeline as well as pattern checking for xlsx
#>
[CmdletBinding()]
Param (
	[parameter(Mandatory = $False, ValueFromPipeline = $True,
		HelpMessage = "Excel file information")]
	[ValidateScript({
			If ($_.Extension.ToUpper().EndsWith("XLSX")) {
				"Excel file"
			}
			Else {
				throw "The file extension must be XLSX. "
			}
		})]
	[System.IO.FileInfo]$xlFile = "c:\temp\slackreport.xlsx",
	[System.IO.DirectoryInfo]$repoFolder = "C:\users\johnk\Documents\github\slackgroup",
	[parameter(Mandatory = $False, ValueFromPipeline = $True,
		HelpMessage = "Specify to only generate report of errors")]
	[Switch]$errOnly
)
Begin {
	# Clean up report file
	If (Test-Path $xlFile) {
		"Deleting existing ScriptAnalyzer Report"
		Remove-Item $xlFile -Force
	}
}
Process {
	# Create array of settings for the Excel file generation
	$p = @{
		AutoSize          = $true
		AutoFilter        = $true
		Show              = $true
		IncludePivotTable = $true
		IncludePivotChart = $true
		Activate          = $true
		PivotRows         = 'Severity', 'RuleName'
		PivotData         = @{RuleName = 'Count' }
		ChartType         = 'BarClustered'
	}
	# Run PSSA reporting only errors
	If ($errOnly) {
		Invoke-ScriptAnalyzer -Severity Error -Path $repoFolder | Export-Excel $xlFile @p
	}
	Else {
		Invoke-ScriptAnalyzer -Path $repoFolder | Export-Excel $xlFile @p
	}
}
End {
	Remove-Variable -Name xlFile, repoFolder, p
	[System.GC]::Collect()
}

