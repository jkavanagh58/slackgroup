[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
	[String]$snippetFolder,
	[String]$url = "https://raw.githubusercontent.com/jkavanagh58/slackgroup/master/Snippets/vscode/powershell.json"
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
$source = (invoke-WebRequest -Uri $url).Content
$source | out-file "$snippetFolder\Powershell.json"
}
End {
	Remove-Variable -Name snippetFolder, url, source
	[System.GC]::Collect()
}