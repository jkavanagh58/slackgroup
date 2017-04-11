[CmdletBinding()]
Param([Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    HelpMessage = "Must specify the computer to test against")]
    [String]$comp
)
# TODO: Use parameter sets or array for ports to check
$winrmListen = 5985
# check to see if winRM is is listening
if (& 'C:\Program Files\windowspowershell\scripts\test-networkport.ps1' -computer $comp -Port $winrmListen){
    "WinRM is listening"
}