#requires -RunAsAdministrator
<#
.SYNOPSIS
	Install modules for a new computer.
.DESCRIPTION
	Once PowerShell has been upgraded to at least version 5 this script will install the well-known
	modules from PSGallery and software packages from Chocolatey.
.EXAMPLE
	C:\PS>c:\etc\script\new-workstation.ps1
	Simply runs this looped install-module process
.LINK
	https://github.com/OneGet/oneget
.LINK
	https://github.com/PowerShell/PowerShell-Docs/tree/staging/gallery
.LINK Visual Studio Code and PowerShell Extension
	https://github.com/PowerShell/vscode-powershell
.NOTES
	===========================================================================
	Created with: 	Visual Studio Code
	Created on:   	04.13.2017
	Created by:   	John Kavanagh
	Organization: 	TekSystems
	Filename:     	new-workstation.ps1
	===========================================================================
	05.03.2017 JJK:	Added chocolateyget provider as it helps with certain packages so streamlining
					all chocolatey packages to use this provider.
	05.22.2017 JJK:	Added PowerCLI to list of modules to be installed
	05.23.2017 JJK:	PSVersion check. Since some environments do not allow WMF updates just notify user of WMF5
	05.23.2017 JJK:	Added dotNetVersion variable for version check process
	05.31.2017 JJK: Added VSCode and PowerShell extension install routine from official repo
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
	$psVersion = $psversiontable.psversion,
	$dotNetVersion = 	(Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
        				Get-ItemProperty -name Version -EA SilentlyContinue |
        				Measure-Object -Property Version -Maximum).Maximum
)
Begin {
	$modules = @(
		"ImportExcel",
		"psreadline",
		"nameit",
		"ScriptBrowser",
		"posh-SSH",
		"TreeSize",
		"VMware.PowerCLI",
		"SplatHelper"
	)
	$packages = @(
		"sysinternals",
		"SDelete",
		"visualstudiocode",
		"paint.net"
	)
	# Simple reporting
	"#------------------------------------------------------------------------------------------------------#"
	"`tYou are currently running PowerShell $($PSVersionTable.PSVersion)."
	"#------------------------------------------------------------------------------------------------------#"
	""
}
Process {
	switch ([environment]::OSVersion.Version) {
		-eq 10 { If ($psversion.Major -eq 5 -AND $psversion.Minor -eq 1){"Good to go"}Else{"The most current version of PowerShell is 5.1"} }
		Default {}
	}
	ForEach ($module in $modules){  # Loop through PowerShell modules
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
	# Install Visual Studio Code and the PowerShell Extension
	Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1
	# Install Chocolatey
	Install-PackageProvider chocolatey -Scope AllUsers -Confirm:$False -Force
	# Adding this provider to handle chocolatey better
	Find-PackageProvider ChocolateyGet -Verbose
	Install-PackageProvider ChocolateyGet -Verbose -Force -Confirm:$False
	Import-PackageProvider ChocolateyGet
	ForEach ($package in $packages){   # Loop through Chocolatey packages
		try{
			"Installing {0} package" -f $package
			install-package -Name $package -confirm:$False -Force -ProviderName ChocolateyGet
		}
		catch {
			"Unable to install {0} package via ChocolateyGet" -f $package
		}
	}
	# use get-module not get-installedmodule if PowerCLI was installed traditionally
	If(!(get-module -Name *vmware* -ListAvailable)){
		"PowerCLI needs to be installed."
		install-module vmware.powercli -force -AllowClobber -Scope AllUsers
	}
	If(!(get-module -Name ActiveDirectory -ListAvailable)){"RSAT needs to be installed."}
	# Install AD Powershell Module
	. C:\etc\scripts\install-adpowershell.ps1
	# Customize Visual Studio
	. c:\etc\scripts\install-vscodeextensions.ps1
	# Enable WSL
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
}
End {

}