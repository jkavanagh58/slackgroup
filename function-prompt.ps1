
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