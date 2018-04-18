D:\tools\GitHub\slackgroup\Pester\test-script.ps1

Describe 'Simple Test' {
    Context 'Validate Folder Collection Process' {
        it 'Validate Path Parameter' {
            $path | Should -Exist
        }
        It 'Path exists' {
            test-path $path | Should -Be $True
        }
        It 'List of folders was created' {
            $tFiles.count | Should -BeGreaterThan 0
        }
    }
}