D:\tools\GitHub\slackgroup\Pester\test-script.ps1

Describe 'Simple Test' {
    it 'Validate Path Parameter' {
        $path | Should -Exist
    }
    It 'Path exists' {
        test-path $path | Should -Be $True
    }
}