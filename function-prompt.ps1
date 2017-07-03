
Function Prompt {
	$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$adminrole = [Security.Principal.WindowsBuiltInRole]::Administrator
	Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "PS " -NoNewline
    #Write-Host $(Get-CustomDirectory) -ForegroundColor Green  -NoNewline        
    If ($CurrentPrincipal.IsInRole($adminrole)) {
		Write-Host "# " -NoNewline -ForegroundColor Gray
	}
	Else {
		Write-Host ">_" -NoNewline -ForegroundColor Yellow
	}
	" "
}
# I have this in my Microsoft.PowerShellISE_profile.ps1
Function Prompt {
	# Needs work
	" "
	$host.ui.RawUI.WindowTitle = "Wegmans - TechWintel Automation"
	Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "vscode " -NoNewline
    Write-Host " >_" -NoNewline -ForegroundColor Yellow
}