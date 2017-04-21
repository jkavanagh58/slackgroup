<#
.SYNOPSIS
    Install modules for a new computer.
.DESCRIPTION
    Once PowerShell has been upgrade to at least version 5 this script will install the well-known
    modules from PSGallery.
.EXAMPLE
    C:\PS>c:\etc\script\new-workstation.ps1
    Simply runs this looped install-module process
.LINK
    https://github.com/OneGet/oneget
.LINK
    https://github.com/PowerShell/PowerShell-Docs/tree/staging/gallery
.NOTES
    ===========================================================================
    Created with: 	Visual Studio Code
    Created on:   	04.13.2017
    Created by:   	John Kavanagh
    Organization: 	TekSystems
    Filename:     	new-workstation.ps1
    ===========================================================================
    commentdate initials: Enter first comment here
#>
# Simple reporting
"#------------------------------------------------------------------------------------------------------#"
"`tYou are currently running PowerShell $($PSVersionTable.PSVersion)."
"#------------------------------------------------------------------------------------------------------#"
""
$modules = "ImportExcel","psreadline","nameit","ScriptBrowser","posh-SSH","TreeSize"
ForEach ($module in $modules){
    # Only using SkipPublisherCheck because I know these modules
    if (!(get-module -Name $module)){
        try{
            install-module -Name $module -Scope AllUsers -Force -Confirm:$False -SkipPublisherCheck
            "Module {0} installed" -f $module
        }
        Catch{
            Write-error -Message "Unable to install $module" 
        }
        
    }
    Else {
        "Module {0} already exists on this machine" -f $module
    }
}
# Install Chocolatey
Install-PackageProvider chocolatey -Scope AllUsers -Confirm:$False -Force
# Sysinternals
find-package sysinternals | install-package -confirm:$False -Force
# VSCode and PowerShell extension
find-package sysinternals | install-package -confirm:$False -Force
find-package vscode-powershell | Install-package -confirm:$false -Force

# use get-module not get-installedmodule if PowerCLI was installed traditionally
If(!(get-module -Name *vmware* -ListAvailable)){
    "PowerCLI needs to be installed."
    install-module vmware.powercli -force -AllowClobber -Scope AllUsers
}
If(!(get-module -Name ActiveDirectory -ListAvailable)){"RSAT needs to be installed."}
# Install AD Powershell Module
. C:\etc\scripts\install-adpowershell.ps1