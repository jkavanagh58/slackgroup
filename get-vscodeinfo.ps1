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
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    File Name: get-vscodeinfo.ps1
    Date Created: 03.21.2017
    Author: slack group
    03.21.2016 JJK: TODO: verify name pattern and if consistent awk it to split the name and version number
    03.21.2017 JJK: Filename pattern is not consistent, will look for a regex way
    03.21.2017 JJK: TODO: use REST to get a list of new and updated extensions
#>
# Determine if vscode and/or insiders is installed
If (test-path (Join-Path -Path $env:USERPROFILE -ChildPath ".vscode-insiders\extensions")) {
    $insiders = $True
    $insCmdline = "code - insiders"
    $vscodeinsExt = invoke-expression -command "$insCmdline --list-extensions"
}
Else {
    $insiders = $False
}
If (test-path (Join-Path -Path $env:USERPROFILE -ChildPath ".vscode\extensions")) {
    $vscode = $True
    $vscodeExt = invoke-expression -command "code --list-extensions"
}
If ($Insiders -eq $False -AND $vscode -eq $False) {
    "No version of Visual Studio Code detected"
    Break
}
"Visual Studio Code Extensions ({0}):" -f $vscodeExt.count
ForEach ($ext in $vscodeExt){
    "`t$ext"
}
If ($vscodeinsExt){
    "Visual Studio Code - Insiders Extensions ({0}):" -f $vscodeinsExt.count
    ForEach ($ext in $vscodeinsExt){
        "`t$ext"
    }
}
<#
# List the installed extensions
$extPath = Join-Path -Path $env:USERPROFILE -ChildPath ".vscode-insiders\extensions"
if (test-path $extPath){
    $varExtensions = get-childitem -Path $extPath
    "You have {0} installed extensions" -f $varExtensions.count
    $varExtensions | sort-object -Property Name | select-object -Property @{n="Extension";e={$_.Name.split("-")[0]}}, @{n="Version";e={$_.Name.split("-")[1]}}
}
#>
