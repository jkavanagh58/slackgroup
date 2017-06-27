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
	06.26.2017 JJK: TODO: Install Tools where status is not installed
	06.26.2017 JJK: Added SRM Reference
	06.26.2017 JJK: Adding ESX hostname to report data might add too much time
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param(
	[Parameter(Mandatory=$false,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage = "VCenter to report on")]
	[Array]$vserver = "vcenter.yourdomain.com",
	[Parameter(Mandatory=$False)]
		[Alias("ShowReport")]
	[Switch]$Show,
	[Parameter(Mandatory=$False)]
		[Alias("UpdateTools")]
	[Switch]$Update,
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
ForEach ($inst in $defaultVIServers){
	"Connected to {0}" -f $inst
}
Function start-toolsupdate {
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[System.String]$vmname
)
try {
	"Updating the VMWare Tools for {0}" -f $vmname
	Update-Tools -VM $vmname -NoReboot
}
catch [System.Exception] {
	"Unable to update tools for {0}" -f $vmname
	$_.Exception.Message
}
}
# Collect Data Report
$VMs = Get-View -ViewType VirtualMachine -Property name, guest, config.version, config.managedby.ExtensionKey, runtime.PowerState
$Report = @() #Array for assembling report data
}
Process {
ForEach ($vm in $VMs.where{$_.Runtime.PowerState -eq "PoweredOn"}){
	$valESX = (get-vm -Name $vm.Name -ErrorAction SilentlyContinue).VMHost.Name
	If ($valESX){$esxName = $valESX}
	Else {$esxName = "No Data Returned"}
	if ($vm.config.managedby.extensionkey -eq "com.vmware.vcDr"){
		$vmobj = [pscustomobject]@{
			VMName = $vm.Name
			Host = $esxName
			SRM = $True
			ToolsStatus = $vm.Guest.ToolsStatus
		}
	}
	Else {
		$vmobj = [pscustomobject]@{
			VMName = $vm.Name
			Host = $esxName
			SRM = $False
			ToolsStatus = $vm.Guest.ToolsStatus
		}
	}
	# Process vmtools update of -UpdateNow parameter has been entered
	$Report += $vmobj
}
$Report | Group-Object -Property ToolsStatus | Select-Object -Property Name, Count | Sort-Object -Property Count | Format-Table -AutoSize
# Create Excel File
$Report | Group-Object -Property ToolsStatus | Select-Object -Property Name, Count | Sort-Object -Property Count |
	Export-Excel -Path c:\etc\VMReport.xlsx  -Worksheetname "1 - VM Tools Report" -TitleFillPattern None -TitleBackgroundColor Gray -Title "VM Tools Report" -AutoSize
$Report = $Report | Sort-Object -Property VMName 
$Report.Where{$_.ToolsStatus -eq "ToolsOld"} | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "Tools Need Updated" -AutoSize -TableName "NeedUpdate" -TableStyle Light1
$Report.Where{$_.ToolsStatus -eq "ToolsOk"} | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "Tools Up-To-Date" -AutoSize -TableName "Current" -TableStyle Light2
$Report.Where{$_.ToolsStatus -eq "ToolsNotInstalled" -OR $_.ToolsStatus -eq "ToolsNotRunning"} | export-excel -Path c:\etc\VMReport.xlsx -WorkSheetname "No Tools or Not Running" -TableName "NotInstalledRunning" -TableStyle Light3 -AutoSize
}
End {
If ($Show){
	# Opening Spreadsheet
	Invoke-Item c:\etc\VMReport.xlsx
}
Remove-Variable -Name Report,vserver
[System.GC]::Collect()
}


