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
	Try {
		invoke-WebRequest -Uri $url -OutFile "$snippetFolder\PowerShell.json"
	}
	Catch {
		"Unable to download VSCode PowerShell Snippet file"
		$Error[0].Exception.Message
	}
}
End {
	Remove-Variable -Name snippetFolder, url
	[System.GC]::Collect()
}