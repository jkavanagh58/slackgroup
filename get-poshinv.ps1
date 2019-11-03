#Requires -Modules ImportExcel
<#
.SYNOPSIS
	Document current PowerShell environment.
.DESCRIPTION
	Script creates an Excel file recording installed modules and VSCode extensions.
.PARAMETER fileXLSX
	Specifies a path to Excel report file.
.PARAMETER rptShow
	Switch to display report once completed.
.EXAMPLE
	PS>_ .\get-poshinv.ps1
	Call script to create report.
.EXAMPLE
	PS>_ .\get-poshinv.ps1 =rptShow
	Call script to create report and open report.
.OUTPUTS
	Excel
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		09.11.2019
	Created by:		John J. Kavanagh
	Organization:	organization
	Filename:		get-poshinv.ps1
	===========================================================================
	09.11.2019 JJK:	Formalized script
	09.11.2019 JJK: TODO: Implement method for discerning modules and PowerShell Version
#>

[CmdletBinding()]
Param (
	[parameter(Mandatory = $False, ValueFromPipeline = $True,
		HelpMessage = "Excel Workbook Full Path")]
	[System.IO.FileInfo]$fileXLSX = "c:\temp\$($env:computername)_powershell-goodies.xlsx",
	[parameter(Mandatory = $False, ValueFromPipeline = $True,
		HelpMessage = "Show report")]
	[Switch]$rptShow,
	[parameter(Mandatory=$False, ValueFromPipeline=$True,
		HelpMessage = "HelpMessage")]
	[Switch]$isCore = $False
)
Begin {
	If ($psversiontable.PSEdition -eq "Core") {
		$isCore = $True
	}
	If (Test-Path $fileXLSX) {
		"Removing existing file"
		Remove-Item $fileXLSX -Force
	}
}
Process {
	$installedModules = get-installedmodule | Sort-Object -Property Name | Select-Object -Property Name, Version
	$exportExcelSplat = @{
		AutoSize      = $true
		WorksheetName = "PSGallery Modules"
		TableStyle    = 'Light3'
		ClearSheet    = $true
		FreezeTopRow  = $true
		Path          = $fileXLSX
		TableName     = "psModules"
	}
	$installedModules | Export-Excel @exportExcelSplat
	# Process VSCode Extensions
	$dataExtensions = @()
	$installedCodeExtensions = code --list-extensions --show-versions
	ForEach ($installedCodeExtension In $installedCodeExtensions){
		$varExtension = $installedCodeExtension.Split("@")
		$installedExtension = [PSCustomObject]@{
			Name = $varExtension[0]
			Version = $varExtension[1]
		}
		$dataExtensions += $installedExtension
	}
	$exportExcelSplat = @{
		AutoSize      = $true
		WorksheetName = "VSCode Extensions"
		TableStyle    = 'Light2'
		ClearSheet    = $true
		FreezeTopRow  = $true
		Path          = $fileXLSX
		TableName     = "vscodeExt"
	}
	$dataExtensions | Export-Excel @exportExcelSplat
	If ($rptShow) {
		Invoke-Item $fileXLSX
	}
}
End {
	Remove-Variable -Name install*, exportExcelSplat, fileXLSX, data*
	[System.GC]::Collect()
}