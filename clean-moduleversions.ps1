#Requires -RunAsAdministrator
$modInfo = get-installedmodule -Name VMware.PowerCLI -AllVersions
[Version]$curVers = (get-installedmodule -name VMware.PowerCLI).Version
ForEach ($module in $modInfo) {
    # Need to convert returned to string value Version type
    [Version]$check = $module.Version
    If ($check -gt $curVers){
        "UhOh"
        $check
        $curVers
    }
    Else {
        "This one $($check) would be deleted"
        $curvers
    }
    <#
    if ($module.Version -notlike $curVers){
        Try {
            $module | uninstall-module
            "$($module.version) Uninstalled"
        }
        Catch {
            "Unable to uninstall $($module.version)"
        }
    }
    #>
}