$mods = get-installedmodule
foreach ($Mod in $mods) {
    $latest = get-installedmodule $mod.name
    $specificmods = get-installedmodule $mod.name -allversions
    foreach ($sm in $specificmods) {
        if ($sm.version -ne $latest.version) {
            Write-Information -Message "Removing $($sm.version) of $($sm.Name)" -InformationAction Continue
            $sm | uninstall-module -force
        }
    }
}