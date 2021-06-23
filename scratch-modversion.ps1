$modules = Get-InstalledModule
ForEach ($mod in $modules) {
    Try {
        $test = [System.Version]::Parse($mod.Version)
        $test
    }
    Catch {
        "Ignoring {0} version {1}" -f $mod.name, $mod.version
    }
}