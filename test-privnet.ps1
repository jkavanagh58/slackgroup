Enable-PSRemoting –SkipNetworkProfileCheck -Force
$myhosts = @("192.168.1.7","192.168.1.8")
$myhosts
ForEach ($host in $myhosts) {
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $host -Confirm:$false -Force
}