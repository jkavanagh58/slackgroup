<#
.SYNOPSIS
	Report on git repo activity
.DESCRIPTION
	Retrieves the git history of a repo using a custom format. Returned data is written to a PSCustomObject.
.PARAMETER repoPath
	Specifies a path of the cloned repo
.PARAMETER gitSep
	Specifies the seperator character for formating git prety output and then use when creating array objects
.EXAMPLE
	C:\PS> .\get-githistory.ps1
	Example of how to use this script
.INPUTS
	Inputs to this cmdlet (if any)
.OUTPUTS
	System.Management.Automation.PSCustomObject
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		05.11.2018
	Created by:		Kavanagh, John J.
	Organization:	TEKSystems
	Filename:		get-githistory.ps1
	===========================================================================
	05.12.2018 JJK: Changed git log output field seperator as commas had been enteterd in commit message
	05.12.2018 JJK: Added custom help so script can be documented as initial script debugged successfully
	05.12.2018 JJK: TODO: Develop better process for setting location to a valid repo path
	05.12.2018 JJK: Testing a process to find local repos for better felxibility, use for parameter validation?
	05.12.2018 JJK: TODO: Use Repos for parameter validation or other presentation at runtime
	05.12.2018 JJK: Removed fully typed field seperator from git pretty and the PSCustom object. Making flexible
					as data entry in commit message could be problematic, for example I use colons and comments so
					I set the gitsep to a semicolon.
#>
Param (
	[String]$repoPath = "Documents\github\ServiceDelivery",
	[String]$logStmnt = " log --since=1.week",
	[String]$gitRun = "git.exe",
	[System.Array]$gitRepos,
	[String]$gitSep = ";"
)
BEGIN {
	Try {
		$gitRepos = Get-Childitem .git -Path c:\ -Recurse -Directory -Hidden -ErrorAction SilentlyContinue
	}
	Catch {
		Write-Error "No git Repositories Found"
		Start-Sleep -Seconds 3
		Exit
	}
	$Report = @()
	$repoHome = Join-Path -Path $env:USERPROFILE -ChildPath $repoPath
	Set-Location $repoHome
}
PROCESS {
	Try {
		#$gitRun $logStmnt
		# git log --pretty=format:'%Cred%ad%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --since=1.week
		$gitPretty = "%ad$gitSep%s$gitSep%cr$gitSep%an"
		git log --pretty=format:$gitPretty --abbrev-commit --since=1.week | 
			#tee-object -Variable logData
			ForEach {
				$logItem = [PSCustomObject]@{
					Date         = $_.Split($gitSep)[0]
					Work         = $_.Split($gitSep)[1]
					TimeDuration = $_.Split($gitSep)[2]
					Author       = $_.Split($gitSep)[3]
				}
				$Report += $logItem
			}
	}
	Catch {
		"Unable to retrieve git log data"
		$Error[0].Exception.Message
	}
	$Report 
}