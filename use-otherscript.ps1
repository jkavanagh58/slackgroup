$comp = "CLVPRDVSSCOM001"
$winrmListen = 5985
# check to see if winRM is is listening
if (& 'C:\Program Files\windowspowershell\scripts\test-networkport.ps1' -computer $comp -Port $winrmListen){
    "WinRM is listening"
}