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
    C:\PS> if ((.\test-isvirtual.ps1 -machineName somemachinename) ){"Virtual"}Else{"Physical"}
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
If ($varCompInfo.Manufacturer -like "VMWare*" -Or $varCompInfo.Manufacturer -like "Microsoft*"){Return $True}
Else {Return $False}
