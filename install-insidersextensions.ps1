#Requires -RunAsAdministrator
<#
.SYNOPSIS
	Script to "normalize" Visual Studio code-insiders for PowerShell users
.DESCRIPTION
	Script will create an environment/workspace for PowerShell. The script makes sure the PowerShell
	API is enabled. Extensions based on a preferred set of extensions will install those extensions.
	This script will not run inside of Visual Studio code-insiders so it will exit with that notice. The script will
	also end any current instances of Visual Studio code-insiders before performing the environment/workspace changes.
.EXAMPLE
	C:\etc\scripts>.\install-vscodeextensions.ps1
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		05.19.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		install-vscodeextensions.ps1
	===========================================================================
	05.19.2017 JJK: Removed wakatime as the install name does not match publisher provided name
	05.19.2017 JJK: TODO: Add higher level process to check to see if vscode-insiders is installed
	05.19.2017 JJK: TODO: need to handle already installed differently than unable to install
	05.19.2017 JJK: TODO: Use and external source for preferred extensions to allow that list to be built
					dynamically
	05.21.2017 JJK: Added a font install routine for the firacode-insiders font
	05.21.2017 JJK: TODO: download fonts from github
	05.21.2017 JJK: Test for presence of vscode
	05.21.2017 JJK: Testing - to delete extensions remove-item but be necessary
	06.12.2017 JJK: TODO: Use call operator versus invoke-expression
	09.12.2017 JJK: FIXME Use git clone to pull fonts from repo
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param(
	[array]$extArray,
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
			HelpMessage = "List of modules to install")]
	[array]$modsArray,
	[String]$curExt,
	$isRunning = (get-process).Name -contains "code"
)
Begin{
# Simple reporting
    "#------------------------------------------------------------------------------------------------------#"
    "`tYou are currently running PowerShell $($PSVersionTable.PSVersion)."
    "#------------------------------------------------------------------------------------------------------#"
    ""
# Check to verify Visual Studio code-insiders is installed
 if (!(get-package -Name "Microsoft Visual Studio Code*" -ErrorAction SilentlyContinue)){
	 "Visual Studio code-insiders is not installed"
	 Exit
}
Else {
	# Also just to check in case vscode-insiders has been installed and no reboot
	if (!(invoke-expression -command "code-insiders -v" )){
		"Visual Studio code-insiders appears to be installed but requires a reboot"
	}
}
# Stop Script if trying to run in vscode
if ($host.Name -like "Visual Studio Code*"){
	"This script will not run in the Visual Studio code-insiders Integrated Terminal"
	Break
}
# Configure vscode-insiders with suggested extensions
# array of suggested extensions
$extArray = @(
	"ms-vscode.PowerShell",
	"denisgerguri.hunspell-spellchecker",
	"Compulim.vscode-ipaddress",
	"AndrewMoll.WeatherExtension",
	"gerane.Theme-Blackboard",
	"Compulim.vscode-ipaddress",
	"RolandGreim.sharecode",
	"sidthesloth.html5-boilerplate",
	"DougFinke.vscode-PSStackoverflow"
)
$modsArray = @(
	"EditorServicesCommandSuite",
	"EditorServicesProcess"
)
}
Process {

If ($isRunning){
	"Visual Studio code-insiders is running and will be closed"
	Try{
		(get-process -Name "Code").kill()
	}
	Catch {
		"Unable to close Visual Studio Code"
		"In order for your workspace to show the new extension restart Visual Studio Code"
	}
}
ForEach ($codemod in $modsArray){
	if (!(get-installedmodule -Name $codemod -ErrorAction SilentlyContinue)){
		Install-Module -Name $codemod -Confirm:$false -verbose -force
	}
}
$curExt = & code-insiders --list-extensions
ForEach ($ext in $extArray){
	if ($curExt -contains $ext){
		"{0} extension is already installed"
	}
	Else{
		# This needs work as it is not catching all result strings
		$instVal = & code-insiders --install-extension $ext
		#Need to test return verbiage
		Switch -wildcard ($instVal){
			"*successfully installed!"	{"{0} Installed" -f $ext}
			"*returned 400"				{"{0} returned a 400 error" -f $ext}
			"*already installed."		{"{0} is already installed" -f $ext}
			default 					{"Return message {0}" -f $instval}
		}
	}
}
# Just because it should be
& code-insiders --enable-proposed-api powershell
<#
Install suggested fonts
$FONTS = 0x14
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)
$files = Get-ChildItem fira*.* -path c:\etc\scripts
ForEach ($file in $files){
	# copy font file to Fonts Folder
	$objFolder.copyHere($File.fullname,0x10)
}
#>
} # End Process
End{
	"Restarting Visual Studio Code"
	& code
}


