$files = invoke-command -computername crt-wba-01 {
    gci ibm.data.informix.dll -path c:\ -recurse -force -ea 0 |
        %{gci $_.fullname | select -expand VersionInfo}
}
