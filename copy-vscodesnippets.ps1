[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
	[String]$snippetFolder,
	[String]$url = "https://github.com/jkavanagh58/slackgroup/blob/master/Snippets/vscode/powershell.json"
)
Begin{
$snippetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Code\User\Snippets"
# Archive existing Snippet folder for rollback
If (Test-Path -Path "$snippetFolder\Powershell.json" -PathType Leaf){
	"Archiving current Snippet File"
	Copy-Item -Path "$snippetFolder\PowerShell.json" -Destination "$snippetFolder\Powershell.archive" -Force
}
}
Process {
# Copy file from github repo
$webclient = New-Object System.Net.WebClient
$file = "c:\etc\badjjk.json"
# $webclient.DownloadString($url,$file)
$webclient.DownloadData($url)
}
End {
	Remove-Variable -Name snippetFolder, url, file
	[System.GC]::Collect()
}