clear-host
Function Prompt {
	# Needs work
	" "
	$host.ui.RawUI.WindowTitle = "Wegmans - TechWintel Automation"
	Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "vscode " -NoNewline
    Write-Host " >_" -NoNewline -ForegroundColor Yellow
}
# add these two lines to your vscode profile
Import-Module EditorServicesCommandSuite
Import-EditorCommand -Module EditorServicesCommandSuite
