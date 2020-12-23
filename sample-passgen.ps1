add-type -AssemblyName System.Web
$pwdGen = [System.web.security.membership]::GeneratePassword(12,4) 
[System.Security.SecureString]$pwdVal = ConvertTo-SecureString -AsPlainText $pwdGen -Force