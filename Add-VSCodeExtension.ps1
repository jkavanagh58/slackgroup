<#
.SYNOPSIS
    Installs base VSCode Extensions
.DESCRIPTION
    Uses list of recommended extensions to start using VSCode with PowerShell.
.NOTES
    ===========================================================================
    Created with:	Visual Studio Code
    Created on:		08.12.2018
    Created by:		Kavanagh, John J.
    Organization:	TEKSystems
    Filename:		Add-VSCodeExtension
    ===========================================================================
    08.12.2018 JJK: Assembling list of VSCode extensions to help get a user started
                    with VSCode and PowerShell
    08.12.2018 JJK: TODO: Research the availability of code.cmd as it has not been existent
                    even after successful installation.
#>

Function Add-VSCodeExtension {
[CmdletBinding()]
Param (
    [parameter(Mandatory=$False, ValueFromPipeline=$False,
            HelpMessage = "Collection of Recommended Extensions")]
    [System.Collections.ArrayList]$extList
)
BEGIN {
    If (get-command -Name code.cmd -ErrorAction SilentlyContinue){
        # Build list of extensions
        $extList = New-Object System.Collections.ArrayList
        $extList.Add("gerane.Theme-Blackboard") | Out-Null
        $extList.Add("docsmsft.docs-markdown") | Out-Null
        $extList.Add("DougFinke.vscode-PSStackoverflow") | Out-Null
        $extList.Add("fabiospampinato.vscode-todo-plus") | Out-Null
        $extList.Add("ms-vsts.team") | Out-Null
        $extList.Add("nobuhito.printcode") | Out-Null
        $extList.Add("wayou.vscode-todo-highlight") | Out-Null
    }
    Else {
        "Unable to find the command needed to perform this operation."
    }
}
PROCESS {
    ForEach ($extension in $extList){
        & code --install-extension $extension
    }
}
END {
    Remove-Variable -Name extList
    [System.GC]::Collect()
}
} # end Add-VSCodeExtension Function
