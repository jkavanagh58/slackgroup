Describe "Script Folder" {
    It "Find Script Root" {
        (Get-Item "C:\etc\Scripts") |
        Should Be $True
    }
    It "Has enough free disk space" {
        $varRootDrive = (get-ciminstance -ClassName Win32_LogicalDiskRootDirectory | select -expand groupcomponent).DeviceID
        (get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID = '$varRootDrive'").FreeSpace |
            Should -BeGreaterThan 6524749824
    }
}
Describe "Git is installed" {
    It "Check for cmd" {
        $varGit = get-Command -Name "git.exe"
        $varGit | Should Be $True
        $varGit.Version |
            Should -BeGreaterThan ([version]'1.0.0.1')
    }
}
Describe "PowerShell" {
    $installedModules = Get-InstalledModule
    It "Check for WMF 5.1" {
        $psversiontable.psversion |
            Should -BeGreaterThan ([version]'5.0.0.0')
    }
    It "Check for PSSA" {
       Compare-Object "PSScriptAnalyzer" $installedModules |
        Should -BeTrue
    }

}