# // The commands to interact with Visual Studio code
<# 
	/*
		Visual Studio Code (Stable):  code
		Visual Studio Code (Insiders): code-insiders

		Note: if you mistype anything after the code command name you will be 
		rewarded with a new VSCode blank session
	/*
#>
# Find the command(s) available because yes you can install both versions on a machine
Get-command -Name code*

# Help for the vscode command
code --help

<# //
	.LINK https://code.visualstudio.com/Docs/editor/extension-gallery
		Documentation for Extension Management in Visual Studio Code
	.LINK https://github.com/Microsoft/vscode/issues/155
		Setting in settings.json necessary if working behind a proxy server
// #>
#Command to list the installed extensions
code --list-extensions

# Command to install an extension
code --install-extension gerane.Theme-Blackboard
# Any currently open VSCode session will show the extension is installed but with the "Reload"
# moniker present
(get-process).where{$_.ProcessName -eq "code" -Or $_.ProcessName -eq "Code - Insiders"}.Foreach{$_.kill()};code-insiders
(get-process).where{$_.ProcessName -eq "code" -Or $_.ProcessName -eq "Code - Insiders"}.Foreach{$_.kill()};code

