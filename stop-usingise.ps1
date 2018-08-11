[CmdletBinding()]
param(

)
BEGIN {
    Function Install-VSCode {
        #Requires -RunAsAdministrator
            # .LINK https://github.com/PowerShell/vscode-powershell
            #   Source for install and additional information
            # This is a very clean method but Invoke-Expression is bad
            # iex (iwr https://git.io/vbxjj)
            # Broke the one-liner down to a more formal method
            If (!(Get-InstalledScript -Name "Install-VSCode" -ErrorAction SilentlyContinue)){
                Install-Script Install-VSCode -Scope CurrentUser -Confirm:$false -Force
            }
            Invoke-Command -NoNewScope -ScriptBlock {
                $vscodesplat = @{
                    BuildEdition         = 'stable'
                    AdditionalExtensions = 'ms-vscode.PowerShell'
                    Architecture         = '64-bit'
                }
                $runDir = Join-Path $env:userprofile -ChildPath "\documents\WindowsPowerShell\Scripts" -Resolve
                & $runDir\Install-VSCode.ps1 @vscodeSplat
            } -Verbose
            # TODO: Remove the installed script?
            If (!(get-command git -ErrorAction SilentlyContinue)){
                Write-Host "It is suggested that you install " -ForegroundColor Yellow -NoNewline
                Write-Host "git " -Foreground Red -NoNewline
                Write-Host " before using VSCode" -ForegroundColor Yellow
            }
            Remove-Variable rundir, vscodesplat
        }
}
PROCESS {
    # and away we go
    install-VSCode
}
END {
    
}
    