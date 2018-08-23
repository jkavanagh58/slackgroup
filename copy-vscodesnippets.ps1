<#
.SYNOPSIS
	Short description
.DESCRIPTION
	Long description
.PARAMETER Path
	Specifies a path to one or more locations.
.PARAMETER LiteralPath
	Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
	is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
	it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
	characters as escape sequences.
.PARAMETER InputObject
	Specifies the object to be processed.  You can also pipe the objects to this command.
.EXAMPLE
	C:\PS>
	Example of how to use this cmdlet
.EXAMPLE
	C:\PS>
	Another example of how to use this cmdlet
.INPUTS
	Inputs to this cmdlet (if any)
.OUTPUTS
	Output from this cmdlet (if any)
.NOTES
	File Name: copy-vscodesnippets.ps1
	Date Created: 2017-12-12 19:30:19
	Author: Kavanagh, John J.
	General notes
	12.12.2017 JJK:	Need method for handling Insiders version
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
	[String]$snippetFolder,
	[String]$url = "https://raw.githubusercontent.com/jkavanagh58/slackgroup/master/Snippets/vscode/powershell.json"
)
Begin{
$snippetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Code - Insiders\User\Snippets"
# Archive existing Snippet folder for rollback
If (Test-Path -Path "$snippetFolder\Powershell.json" -PathType Leaf){
	"Archiving current Snippet File"
	Copy-Item -Path "$snippetFolder\PowerShell.json" -Destination "$snippetFolder\Powershell.archive" -Force
}
}
Process {
# Copy file from github repo
	Try {
		invoke-WebRequest -Uri $url -OutFile "d:\tools\powershell.json" #"$snippetFolder\PowerShell.json"
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