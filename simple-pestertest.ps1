Describe "Validate Path"{
    It "validates path"{
        test-path -Path C:\etz | should be $True
    }
}