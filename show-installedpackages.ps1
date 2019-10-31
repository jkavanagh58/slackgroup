Function Show-InstalledPackages {
    <#
        .NOTES
            07.23.2019 JJK: TODO: provide option to run the install-package process
                            to update if current version is less than online
            07.23.2019 JJK: TODO: Use type casting for Version like
                            [Version]$pkg.Version
            07.23.2019 JJK: DONE: Provide option to only show report of outdated packages
            07.24.2019 JJK: TODO: Test using wildcard for get-package
            07.24.2019 JJK: TODO: Hard code the find-package
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $False, ValueFromPipeline = $True,
            HelpMessage = "Package Provider")]
        [System.String]$packageProvider = "Chocolate*",
        [parameter(Mandatory = $False, ValueFromPipeline = $True,
            HelpMessage = "Report just outdated")]
        [Switch]$OnlyOutdated
    )
    Begin {
        $packageInstalled = Get-Package | Where-Object { $_.ProviderName -like $packageProvider }
        $packageVersionReport = @()
    }
    Process {
        "Checking {0} Packages from {1}" -f $packageInstalled.Count, $packageProvider
        ForEach ($pkg in $packageInstalled | Sort-Object -Property Name) {
            $onlinepkg = Find-Package -Name $pkg.Name -ProviderName "Chocolatey"
            If ($onlinepkg) {
                If ($onlinepkg.Version -gt $pkg.Version) {
                    $packageNeedUpdate = $True
                }
                Else {
                    $packageNeedUpdate = $False
                }
                $pacakageObj = [PSCustomObject]@{
                    Package          = $pkg.Name
                    Installed        = $pkg.Version
                    AvailableVersion = $onlinepkg.Version
                    UpdateAvailable  = $packageNeedUpdate
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
                Where-Object { $_.AvailableVersion -gt $_.Installed } |
                Format-Table -AutoSize
        }
        Else {
            $packageVersionReport | Format-Table -AutoSize
        }
    }
    End {
        Remove-Variable -Name package*
        [System.GC]::Collect()
    }
}