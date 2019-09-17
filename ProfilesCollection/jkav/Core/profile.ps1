Function Prompt {
	$admRole = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	If ($admrole){
		$host.ui.RawUI.WindowTitle = "$env:username (Admin)"
		Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "sudo # " -NoNewline
		return ' '
	}
	Else {
		$host.ui.RawUI.WindowTitle = "$env:username (Admin)"
		Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "Core >_ " -NoNewline
		return ' '
	}
}
