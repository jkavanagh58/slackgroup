[CmdletBinding()]
Param (
    [parameter(Mandatory=$False, ValueFromPipeline=$True)
            HelpMessage = "Perform Update")]
    [Swith]$UpdateModule
)
BEGIN {
    $curModules = get-installedmodule | Sort-Object -Property Name
}
PROCESS {
    ForEach ($varModule in $curModules) {
        Write-Progress -Activity "Inspecting Module $($varModule.Name)" -Status "Version Check" 
        [Version]$versionInstalled = $varModule.Version
        [Version]$versionOnline = (Find-Module -Name $varModule.Name).Version
        If ($versionOnline -gt $versionInstalled) {
            "`t{0} is due for an update" -f $varModule.Name
        }
    }
}
END {
    Remove-Variable -Name versionInstalled, versionOnline, curModules
    [System.GC]::Collect()
}