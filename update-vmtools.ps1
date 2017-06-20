<#
.SYNOPSIS
	Sample - How to update vmware tools without reboot
.DESCRIPTION
	Sample script demonstrating how PowerCLI can be utilized to update out of date VMWare guest tools with an 
	immediate reboot. Sadly the update-tools cmdlet does not support the whatIf parameter so be careful when ready
	to test.
.EXAMPLE
	C:\etc\scripts\.\update-vmtools.ps1
	Example of how to use this cmdlet
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		05.22.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		update-vmtools.ps1
	===========================================================================
	05.22.2017 JJK: Original sample written
	05.22.2017 JJK: TODO: provide parameters for VI Server(s) and credential
#>
[CmdletBinding()]
Param (
	# add vcenter param and credential param
		[Parameter(Mandatory=$true,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true,
		HelpMessage = "Enter Help Message Here")]
		[String]$vcenter
	
)
if (!($defaultviserver)){
	"You must be connected to a VCenter host"
	Exit
}
# Check for Tools status for any VM Named like TST
ForEach ($vm in (get-vm -Name "TST*")){
    if ($vm.ExtensionData.Guest.ToolsStatus -eq "toolsOld"){
        # Report the VM to be updated
		"Updating VMWare Tools status for {0}" -f $vm.name
		# Uncomment the following like to actually perform the update-tools operation
        #update-tools $vm -NoReboot
    }
}