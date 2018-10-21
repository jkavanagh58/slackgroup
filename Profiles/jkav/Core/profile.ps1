Function Prompt {
	$admRole = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	If ($psversiontable.psversion -lt 6){
		If ($admRole) {
			$host.ui.RawUI.WindowTitle = "Kavanaghtech (Admin)"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "PS # " -NoNewline
			return ' '
		}
		Else {
			$host.ui.RawUI.WindowTitle = "KavanaghTech"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host " PS >_ " -NoNewline
			return ' '
		}
	}
	ElseIf ($psversiontable.psversion -ge 6){
		If ($admrole){
			$host.ui.RawUI.WindowTitle = "KavanaghTech (Admin)"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "sudo # " -NoNewline
			return ' '
		}
		Else {
			$host.ui.RawUI.WindowTitle = "KavanaghTech"
			Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "Core >_ " -NoNewline
			return ' '
		}
	}
}
<# 
	TODO: If elevated check for WindowsPSModulePath and WindowsCompatability modules
#>