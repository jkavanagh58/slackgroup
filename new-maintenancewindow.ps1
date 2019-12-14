<#
.SYNOPSIS
	Short description
.DESCRIPTION
	Long description
.PARAMETER Server
	FQDN of server to be placed into MaintenanceMode
.PARAMETER MMTime
	Length of minutes for the Maintenance Window
.EXAMPLE
	C:\PS> .\new-maintenancewindow.ps1 -ServerName machine.yourdomain.com -WindowTime 15
	Example of how to use this cmdlet
.EXAMPLE
	C:\PS>
	Another example of how to use this cmdlet
.INPUTS
	Inputs to this cmdlet (if any)
.OUTPUTS
	Output from this cmdlet (if any)
.NOTES
	===========================================================================
	Created with:   Visual Studio Code
	Created on:     11.01.2017
	Created by:     Kavanagh, John J.
	Organization:   TEKSystems
	Filename:       new-maintenancewindow.ps1
	===========================================================================
	01.03.2018 JJK: TODO:Find related monitoring objects for entered server
	01.15.2018 JJK: Formalized script parameters
	01.16.2018 JJK: Will circle back for ValidatePattern Regex FQDN
	01.16.2018 JJK: FQDN validation back in. Known issue with VSCode EditorSyntax #26
	01.17.2018 JJK: TODO:Test Get-SCOMMOnitoringObject for single pass or multiarray loops as well
	01.18.2018 JJK: Added MMReason parameter to allow more accurate reporting. Defined ValidateSet as cmdlet only
					takes set acceptable values
#>
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage = "FQDN of machine to place into maintenance mode")]
	[ValidatePattern('(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)')] # Comment to correct' syntax highlighting
	[Alias("ServerName","FQDN")]
	[String]$server,
	[Parameter(ValueFromPipelineByPropertyName=$true,
		Mandatory=$true)]
	[Alias("Minutes","WindowTime")]
	[int32]$MMTime,
	[Parameter(Mandatory = $false,
		ValueFromPipeline = $true,
		HelpMessage = "Specify reason for the Maintenance Window")]
	[ValidateSet(
		"PlannedOther",
		"UnplannedOther",
		"PlannedHardwareMaintenance",
		"UnplannedHardwareMaintenance",
		"PlannedHardwareInstallation",
		"UnplannedHardwareInstallation",
		"PlannedOperatingSystemReconfiguration",
		"UnplannedOperatingSystemReconfiguration",
		"PlannedApplicationMaintenance",
		"ApplicationInstallation",
		"ApplicationUnresponsive",
		"ApplicationUnstable",
		"SecurityIssue",
		"LossOfNetworkConnectivity"
	)]
	[System.String]$MMReason="PlannedOther"
)
Begin {
	$omServer = "someopsmanmgmt.yourdomain.com"
	$bypass = new-pssession -computername $omServer -credential $admcreds
	# Load the Operations Manager Shell
	Invoke-Command -Session $bypass -ScriptBlock {Start-OperationsManagerClientShell -ManagementServerName: "yourOpsManMgmtServer.yourdomain.com" -PersistConnection: $true -Interactive: $true} | out-Null
	# Determine if server can be found, if not exit script
	Try {
		"Searching OpsMan for Server"
		Invoke-Command -Session $bypass -ScriptBlock {get-scomagent -Name $using:server} | out-null
	}
	Catch {
		"Unable to find agent for {0}" -f $server
		Exit
	}
}
Process {
	# Set MM end time
	$MMEnd = (get-Date).AddMinutes($MMTime)
	Invoke-Command -session $bypass -ScriptBlock {
		$agentObjects = Get-SCOMClassInstance -Name "*$($using:server)*"
		Start-SCOMMaintenanceMode -instance $agentObjects -EndTime $using:MMEnd -Comment "JKav Test" -Reason PlannedOther -WhatIf
	}
}
End {
	Remove-Variable -Name server,omServer, MMTime, MMEnd
	$bypass | remove-pssession
	[System.GC]::Collect()
}