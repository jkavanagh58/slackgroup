<#
.SYNOPSIS
    Safely remove an Agent monitored instance from SCOM
.DESCRIPTION
    Script uses the OperationsManager API to remove an Agent Monitored resource from SCOM. This saves possible
    corruption that can occur if just deleted from the console and also saves the SQL work required to otherwise
    safely remove the instance from SCOM.
.PARAMETER agtComputer
    Fully Qualified Domain Name of the Agent Managed resource to remove
.EXAMPLE
    C:\PS>c:\etc\scripts\remove-scomagent.ps1 -agtComputer test.somedomain.com
    Example of how to use this cmdlet
.NOTES
    File Name: remove-scomagent.ps1
    Date Created: 03.18.2017
    Author: John J Kavanagh
    03.27.2017 JJK: TODO: Make param mandatory and FQDN pattern valid
    03.29.2017 JJK: Still working on regex for validating fully qualified domain name
#>
Function remove-scomagent {
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True,
    HelpMessage = "Enter the agents Fully Qualified Domain Name")]
    [ValidatePattern("(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.){2,}(?:[a-zA-Z]{2,})$)")]
    [String]$agtComputer
)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.EnterpriseManagement.OperationsManager.Common") 
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.EnterpriseManagement.OperationsManager")

$MGConnSetting = New-Object Microsoft.EnterpriseManagement.ManagementGroupConnectionSettings("FQDN of Management Server") 
$MG = New-Object Microsoft.EnterpriseManagement.ManagementGroup($MGConnSetting) 
$Admin = $MG.Administration
$agentManagedComputerType = [Microsoft.EnterpriseManagement.Administration.AgentManagedComputer]; 
$genericListType = [System.Collections.Generic.List``1] 
$genericList = $genericListType.MakeGenericType($agentManagedComputerType) 
$agentList = new-object $genericList.FullName

#Replace DNSHostName with FQDN of agent to be deleted. 
#ComputerName is a SCOM management server to query 
$agent = Get-SCOMAgent -DNSHostName $agtcomputer -ComputerName CLVPRDVSSCOM001.cgicleve.com 
$agentList.Add($agent);
$genericReadOnlyCollectionType = [System.Collections.ObjectModel.ReadOnlyCollection``1] 
$genericReadOnlyCollection = $genericReadOnlyCollectionType.MakeGenericType($agentManagedComputerType) 
$agentReadOnlyCollection = new-object $genericReadOnlyCollection.FullName @(,$agentList);

$admin.DeleteAgentManagedComputers($agentList)
}
