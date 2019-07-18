Function Store-admcred {
    [cmdletbinding(SupportsShouldProcess = $True)]
    param(
        [String]$path = "$home\Desktop\mycred.json"
    )
    Begin {
        # Nothing to process here
        $cred = Get-Credential
        $curFile = Get-Content $path -Raw | ConvertFrom-Json
        <#
        if ($curFile.username -eq $cred.username){"Updating existing object"}
        Else {"Will be adding to the credential list"}
    #>
    }
    Process {
        $cred = Get-Credential
        $cred |
            Select-Object Username, @{n = "Password"; e = { $_.password | ConvertFrom-SecureString } } |
            ConvertTo-Json |
            Set-Content -Path $path -Encoding UTF8
    }
}
Function set-adm {
    Begin { $path = "$home\Desktop\mycred.json" }
    Process {
        $o = Get-Content -Path $path -Encoding UTF8 -Raw | ConvertFrom-Json
        $cred = New-Object -TypeName PSCredential $o.UserName, ($o.Password | ConvertTo-SecureString)
    }
    End {
        Return $cred
    }
}