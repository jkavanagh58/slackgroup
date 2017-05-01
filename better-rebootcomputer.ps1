<#
.SYNOPSIS
    Better way to reboot computers
.DESCRIPTION
    Really it is just an demonstration of the flexibility of restart-computer. Being able to tell the cmdlet to
    wait for a specific element to be online before continuing can help with workflows that require a reboot and
    then further action.
.PARAMETER ServerName
    Name of the computer to be restarted.
.EXAMPLE
    C:\PS>.\better-rebootcomputer.ps1 -servername testmachine
    Example of how to use this cmdlet
.Link
    https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.management/restart-computer
.NOTES
    ===========================================================================
    Created with: 	Visual Studio Code
    Created on:   	05.01.2017
    Created by:   	John Kavanagh
    Organization: 	TekSystems
    Filename:     	better-rebootcomputer.ps1
    ===========================================================================
    date initials: Enter first comment here
#>

[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
     [Parameter(Mandatory = $true,
     ValueFromPipeline = $true,
     Position = 1,
     HelpMessage = "Enter the computer name to be rebooted")]
     [ValidateScript({test-connection -Computername $_ -Count 1 -Quiet })]
     [System.String]$servername
)
$args = @{
    ComputerName = $servername
    Wait         = $True
    For          = "WinRM"
    Force        = $True
}
restart-computer @args
# Now let's test - yes I am using CIM so For has to be WinRM, WMI is up first but CIM
# requires WinRM
$sess = New-CimSession -computer $servername
Get-CimInstance -classname win32_operatingsystem -CimSession $sess