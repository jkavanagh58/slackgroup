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
        08.14.2018 JJK: Made into a stand-alone script since install method may change
        08.14.2018 JJK: Added PowerShell extension <see note above>
        08.14.2018 JJK: Only install extension if not found in list of installed extensions
        09.07.2018 JJK: DONE: Add process to copy snippet files to user location
#>
Function Add-VSCodeExtension {
[CmdletBinding()]
Param (
    [parameter(Mandatory=$False, ValueFromPipeline=$False,
            HelpMessage = "Collection of Recommended Extensions")]
    [System.Collections.ArrayList]$extList
)
BEGIN {
    $extInstalled = code --list-extensions
    If (get-command -Name code.cmd -ErrorAction SilentlyContinue){
        # Build list of extensions
        $extList = New-Object System.Collections.ArrayList
        $extList.Add("ms-vscode.PowerShell") | Out-Null
        $extList.Add("gerane.Theme-Blackboard") | Out-Null
        $extList.Add("docsmsft.docs-markdown") | Out-Null
        $extList.Add("DougFinke.vscode-PSStackoverflow") | Out-Null
        $extList.Add("fabiospampinato.vscode-todo-plus") | Out-Null
        $extList.Add("ms-vsts.team") | Out-Null
        $extList.Add("nobuhito.printcode") | Out-Null
        $extList.Add("wayou.vscode-todo-highlight") | Out-Null
        $extList.Add("RolandGreim.sharecode") | Out-Null
    }
    Else {
        Write-Error "Unable to find the command needed to perform this operation."
        EXIT
    }
}
PROCESS {
    ForEach ($extension in $extList){
        If ($extInstalled -contains $extension){
            "$($extension) Already installed"
        }
        Else {
            & code --install-extension $extension
        }
    }
    # Code to implement PowerShell Snippet file
    If ($destFolder = $env:APPDATA\Code\User\Snippets){
        Copy-Item \\wfm.somedomain.com\Departments\InformationTechnology\TechWintel\.Scripts\Automation\powershell.json -Destination $destFolder -force
    }
}
END {
    Remove-Variable -Name extList
    [System.GC]::Collect()
}
} # end Add-VSCodeExtension Function
Function new-snippetfile {
    $srcURL= "https://gist.githubusercontent.com/jkavanagh58/9312bd0d78eddc54d51998c0a5c9831a/raw/0d28bca7af930ab592f0f5eacd655a223a144c57/powershell.json"
    $destFile = Join-Path $env:APPDATA -ChildPath "\Code\User\snippets\powershell.json"
    If (Test-Path $destFile){
        "Snippet File already exists"
        rename-item $destfile -NewName "powershell.orig"
    }
    Invoke-WebRequest -Uri $srcURL -OutFile $destFile -PassThru
}
# Only because it is being run in haste
Add-VSCodeExtension
new-snippetfile
