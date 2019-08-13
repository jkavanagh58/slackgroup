describe 'PoSH Environment' {
    
    it 'PowerShell Version' {
        $psversiontable.PSVersion.Major | should be 5
    }
    it 'Local scripts ' {
        Test-Path -Path c:\etc\scripts | Should -Be $True
    }
    it 'Old school profile' {
        Test-Path $profile.CurrentUserAllHosts | Should -Be $True
    }

    Context "Optional Elements" {
        # would require test to be Runas Admin
        it 'OPenSSH Client enabled' {
            (Get-WindowsCapability -Online -Name OpenSSH.Client*).State | should be 'Installed'
        }
        it 'Visual Studio Code' {
            $cmds = get-command code* -CommandType 'Application'
            $cmds.count | Should -BeGreaterOrEqual 1
        }
        it 'Git Installed' {
            $gitcmd = get-command -Name git.exe -CommandType Application
            $gitcmd.count | Should -BeGreaterOrEqual 1
        }
        it 'Editor Services Modules' {
            $pses = get-installedmodule -Name EditorServices* 
            $pses.count | Should -BeGreaterThan 1
        }
    }
	
}