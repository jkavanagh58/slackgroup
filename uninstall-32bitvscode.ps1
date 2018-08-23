If (get-process -ProcessName "Code" -ErrorAction SilentlyContinue){
	# Terminate VS Code if currently running
	(get-process -ProcessName "Code").kill()
}
$varUninstall = get-itemproperty hklm:\software\wow6432node\microsoft\windows\currentversion\uninstall\* | where DisplayName -eq "Microsoft Visual Studio Code" | select UninstallString
If ($varUninstall){
	start-process -FilePath $varUninstall.UninstallString -Verb RunAs
}
# No version available via Chocolatey