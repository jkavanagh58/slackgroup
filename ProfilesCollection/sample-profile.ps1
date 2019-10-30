Function Prompt {
    Try {
        $admRole = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        If ($admRole) {
            $host.ui.RawUI.WindowTitle = "somedomain - TechWintel Automation (Admin)"
            Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host "PS # " -NoNewline
            return ' '
        }
        Else {
            #$host.ui.RawUI.WindowTitle = "somedomain - TechWintel Automation"
            Write-Host "I " -NoNewline; Write-Host "$([char]9829) " -ForegroundColor Red -NoNewline; Write-Host " PS >_ " -NoNewline
            return ' '
        }
    }
    Catch {
        "_> "
    }
}
"Establishing Cmdlet Default Parameters"
$PSDefaultParameterValues = @{
    "install-module:Confirm" = $False
    "install-module:Verbose" = $True
    "install-module:Force"   = $True
    "install-module:Scope"   = "AllUsers"
    "update-module:Confirm"  = $False
    "update-module:Verbose"  = $True
    "update-module:Force"    = $True
}
$osInfo = get-ciminstance -ClassName Win32_OperatingSystem -Property *
"=============================================================="
"`t$env:computername"
"`tWindows Version: $($osInfo.Caption)"
"`tWindows Build:   $($osInfo.BuildNumber)"
Try {
    "`tGit Build:       {0}" -f $(git --version).Replace("git version ", "")
}
Catch {
    "Check to ensure you have installed git"
}
"=============================================================="
Remove-Variable osInfo
#
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord 'Alt+D' -Function KillWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+@' -Function MenuComplete
Set-PSReadLineKeyHandler -Key ([char]0x03) -Function CopyOrCancelLine
