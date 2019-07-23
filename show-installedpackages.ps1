Function Show-InstalledPackages {
    <#
        .NOTES
            07.23.2019 JJK: TODO: provide option to run the install-package process
                            to update if current version is less than online
            07.23.2019 JJK: TODO: Use type casting for Version like
                            [Version]$pkg.Version
            07.23.2019 JJK: DONE: Provide option to only show report of outdated packages
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $False, ValueFromPipeline = $True,
            HelpMessage = "Package Provider")]
        [System.String]$packageProvider = "Chocolatey",
        [parameter(Mandatory = $False, ValueFromPipeline = $True,
                HelpMessage = "Report just outdated")]
        [Switch]$OnlyOutdated
    )
    BEGIN {
        $packageInstalled = Get-Package | Where-Object {$_.ProviderName -eq $packageProvider}
        $packageVersionReport = @()
    }
    PROCESS {
        "Checking {0} Packages from {1}" -f $packageInstalled.Count, $packageProvider
        ForEach ($pkg in $packageInstalled | Sort-Object -Property Name){
            $pkg.Name
            $onlinepkg = Find-Package -Name $pkg.Name -ProviderName $packageProvider
            If ($onlinepkg) {
                $pacakageObj = [PSCustomObject]@{
                    Package = $pkg.Name
                    Installed = $pkg.Version
                    AvailableVersion = $onlinepkg.Version
                }
                $packageVersionReport += $pacakageObj
            }
            Else {
                Write-Warning -Message 'No {0} Found online' -f $pkg.Name
            }
        }
        "Reporting on {0} Packages" -f $PackageVersionReport.Count
        If ($OnlyOutdated) {
            $packageVersionReport |
            Where-Object {$_.AvailableVersion -gt $_.Installed} | 
            Format-Table -AutoSize
        }
        Else {
            $packageVersionReport | Format-Table -AutoSize
        }
    }
    END {
        Remove-Variable -Name package*
        [System.GC]::Collect()
    }
}