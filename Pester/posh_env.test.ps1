describe 'PoSH Environment' {
    
    it 'PowerShell Version' {
        $psversiontable.PSVersion.Major | should be 5
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
    }
	
}