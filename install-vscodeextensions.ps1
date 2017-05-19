<#
.SYNOPSIS
	Short description
.DESCRIPTION
	Long description
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
	05.19.2017 JJK: TODO: Add higher level process to check to see if vscode is installed
	05.19.2017 JJK: TODO: need to handle already installed differently than unable to install 
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param(
	[array]$extArray,
	[String]$curExt,
	$isRunning = (get-process).Name -contains "code"
)
Begin{
if ($host.Name -like "Visual Studio Code*"){
	"This script will not run in the Visual Studio Code Integrated Terminal"
	Break
}
# Configure vscode with suggested extensions
# array of suggested extensions
$extArray = @(
	"denisgerguri.hunspell-spellchecker",
	"vscode-wakatime",
	"Compulim.vscode-ipaddress",
	"DougFinke.vscode-PSStackoverflow"
)
$curExt = invoke-expression -command "code --list-extensions"
}
Process {
# Just because it should be 
Invoke-expression -command "code --enable-proposed-api powershell"
If ($isRunning){
	"Visual Studio Code is running and will be closed"
	Try{
		(get-process -Name "Code").kill()
	}
	Catch {
		"Unable to close Visual Studio Code"
		"In order for your workspace to show the new extension restart Visual Studio Code"
	}
}
ForEach ($ext in $extArray){
	if ($curExt -contains $ext){
		"{0} extension is already installed"
	}
	Else{
		$instVal = invoke-expression -Command "code --install-extension $ext"
		Switch -wildcard ($instVal){
			"*successfully installed!"	{"{0} Installed" -f $ext}
			"*returned 400"				{"{0} returned a 400 error" -f $ext}
			"*already installed."		{"{0} is already installed" -f $ext}
			default 					{"Return message {0}" -f $instval}	
		}
	}
}
} # End Process
End{
	"Restarting Visual Studio Code"
	invoke-expression -Command "code"
}


