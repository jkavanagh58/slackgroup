<#
.SYNOPSIS
    Performs a search and replace for config files.
.DESCRIPTION
    Performs a search and replace for config files found in a provided path. The search and replace then
    replaces and instances matching the curval parameter with the value provided in the newval parameter.
.PARAMETER configFldr
    Specifies a path to to the location for config files.
.PARAMETER curVal
    Specifies the text to be replaced.
.PARAMETER newval
    Specifies the new value to replace the current value with.
.EXAMPLE
    C:\PS>c:\etc\scripts\replace-config.ps1 -configFldr "c:\etc\test" -curVal "JJK=$false" -newVal "JJK=$true"
    Replace any instance of JJK=$fale to JJK=$true for any file found in c:\etc\test and it's sub-directories
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.NOTES
    ===========================================================================
    Created with: 	Visual Studio Code
    Created on:   	04.10.2017
    Created by:   	John Kavanagh
    Organization: 	TekSystems
    Filename:     	replace-config.ps1
    ===========================================================================
    04.10.2017 JJK: Expounding upon one-line Dan posted in slack group
    gci C:\Projects *.config -recurse | 
    ForEach {(Get-Content $ | 
        ForEach {$ -replace "old", "new"}) | 
        Set-Content $_}
    04.10.2017 JJk: TODO: Provide output for any changes made.
    04.10.2017 JJK: TDOD: -Enhancement- Provide search and only attempt replace against files 
                            where pattern exists.
#>
[CmdletBinding(SupportsShouldProcess=$True)]
Param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage = "Name and Path of Folder to perform search and replace")]
    [String]$configFldr,
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage = "Text to be replaced")]
    [String]$curVal,
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage = "Replace text with this value")]
    [String]$newVal
)
If (Test-path $configFldr){
    $configFiles = get-childitem *.Config -Path $configFldr -Recurse
    Foreach ($cFile in $configFiles){
        (Get-Content $cfile.PSPath) |
        Foreach-Object { $_ -replace $curval, $newVal } |
        Set-Content $cfile.PSPath 
    }
}
Else {"Unable to find {0}" -f $configFldr}
