<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.PARAMETER machineName
    Specifies the computer to evaluate. Parameter is validated using test-connection.
.EXAMPLE
    C:\PS> if ((.\test-isvirtual.ps1 -machineName wks-jkavanag-01) ){"Virtualized on {0}" -f $virtType}Else{"Physical"}
    Example of how to use this cmdlet
.OUTPUTS
    Boolean
.NOTES
    ===========================================================================
    Created with:	Visual Studio Code
    Created on:		05.09.2017
    Created by:		John Kavanagh
    Organization:	TekSystems
    Filename:		test-isvirtual.ps1
    ===========================================================================
    05.09.2017 JJK: TODO: Add Model return for Hyper-V machines
    05.09.2017 JJK: Changed to Manufacturer for eval; added Or statement for Microsoft or VMWare
    05.09.2017 JJK: TODO: Test using HyperVisorPresent value from CIM query - does not work
    05.09.2017 JJK: TODO: Return virtualization type
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
    	[Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        Position = 1,
        HelpMessage = "Name of computer to test cannot be local machine")]
        [ValidateScript({ test-connection -computername $_ -Count 1 -Quiet})]
        [System.String]$machineName
)
if ($machineName -notmatch $env:computername){
    $varCompInfo = get-ciminstance -ClassName Win32_ComputerSystem -ComputerName $machineName
}
Else {
    # Cannot use ComputerName variable against local machine
    $varCompInfo = get-ciminstance -ClassName Win32_ComputerSystem
}
switch ($varCompInfo.Manufacturer) {
    {$_ -like "VMWare*"} { $global:virtType = "VMWare";Return $True }
    {$_ -like "VMWare*"} { $global:virtType = "HyperV";Return $True }
    Default {Return $False}
}

