Describe "Check Admin Account"{
    Context "Check this" {
        
        $items = get-aduser techadminjxk -Properties Enabled 
        It "Account Exists" {
            $items.samAccountName | Should Be "techadminjxk"
        }               
        It "Is the account enabled" {
            $items.Enabled | Should Be $True
        }      
    }
}