#Requires -Module ImportExcel
<#
.SYNOPSIS
	VMware Virtual Machines Tools Report
.DESCRIPTION
	VMware Virtual Machines Tools Report
.PARAMETER vserver
	Variable used to determine what VCenter(s) to report on.
.PARAMETER Show
	If specified the resulting Excel spreadsheet will be opened.
.PARAMETER vctrCreds
	Used to pass alternate credentials for the VCenter connection.
.EXAMPLE
	C:\etc\scripts>new-vmtoolsreport.ps1
	Example of how to use this script
.EXAMPLE
	I ♥ vscode >c:\etc\scripts\mew-vmtoolsreport.ps1 -Show
	Will connect to the default VCenter server with current credentials and open the resulting Excel file.
.EXAMPLE
	I ♥ vscode >c:\etc\scripts\mew-vmtoolsreport.ps1 -vctrCreds (Get-Credential)
	Will prompt the user to  enter the credential information to use for the VCenter access.

.OUTPUTS
	Excel Spreadsheet
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		06.21.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		new-vmToolsReport.ps1
	===========================================================================
	06.21.2017 JJK: Add Switch Param for showing spreadsheet
	06.21.2017 JJK:	TODO: work on report file process
	06.22.2017 JJK: Credenital parameter to connect alternate credentials
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param(
	[Parameter(Mandatory=$false,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage = "VCenter to report on")]
	[String]$vserver = "vcenter.yourdomain.com",
	[Parameter(Mandatory=$False)]
		[Alias("ShowReport")]
	[Switch]$Show,
	[Parameter(Mandatory = $false,
		ValueFromPipeline = $true,
		HelpMessage = 'Ensure you are using the correct credentials for this operation')]
	[System.Management.Automation.PSCredential]$vctrCreds	
)
Begin{
if (!($defaultVIServers)){
	"Connecting to VCenter"
	if ($vctrCreds) {
		"`tConnecting with supplied credentials"
		Connect-viserver -Server $vserver -Credential $vctrCreds
	}
	Else {
		Connect-viserver -Server $vserver
	}
}
# Collect Data Report
$VMs = Get-View -ViewType VirtualMachine -Property name, guest, config.version, runtime.PowerState
$Report = @() #Array for assembling report data
}
Process {
ForEach ($vm in $VMs){
	$vmobj = [pscustomobject]@{
		VMName = $vm.Name
		ToolsStatus = $vm.Guest.ToolsStatus
	}
	$Report += $vmobj
}
$Report | Group-Object -Property ToolsStatus | Select-Object -Property Name, Count | Sort-Object -Property Count | Format-Table -AutoSize
# Create Excel File
$Report | Group-Object -Property ToolsStatus | Select-Object -Property Name, Count | Sort-Object -Property Count |
	Export-Excel -Path c:\etc\VMReport.xlsx  -Worksheetname "VM Tools Report" -AutoSize -Title "VM Tools Report"
$Report.Where{$_.ToolsStatus -eq "ToolsOld"} | Sort-Object -Property VMName | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "Tools Need Updated" -AutoSize
$Report.Where{$_.ToolsStatus -eq "ToolsOk"} | Sort-Object -Property VMName | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "Tools Up-To-Date" -AutoSize
$Report.Where{$_.ToolsStatus -eq "ToolsNotInstalled" -OR $_.ToolsStatus -eq "ToolsNotRunning"} | Sort-Object -Property VMName | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "No Tools or Not Running" -AutoSize
}
End {
If ($Show){
	# Opening Spreadsheet
	Invoke-Item c:\etc\VMReport.xlsx
}
Remove-Variable -Name Report,vserver
[System.GC]::Collect()
}


