#Requires -Modules ImportExcel
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
		Organization:	KavanaghTech
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
		05.14.2018 JJK:	DONE: Add reporting using the ImportExcelModule - working on multiple sheets.
		05.14.2018 JJK:	TODO: Approach reporting with new info git log is repo specific not computer specific
		05.14.2018 JJK:	DONE: Look for git date value - use get-Date to make commit Date easier to read
		05.14.2018 JJK:	Tested new Report format; converted commandling to splat
		05.17.2018 JJK:	Sterilized Report path to current users documents folder.
		05.17.2018 JJK: TODO: Use CIM to create a list of physical disks (I believe local clones can only be in physical)
#>
[CmdletBinding()]
Param (
	[parameter(Mandatory=$False, ValueFromPipeline=$True,
		HelpMessage = "Path to github repo for reporting on")]
	[String]$repoPath = "Documents\github\ServiceDelivery",
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
		HelpMessage = "git log statement")]
	[String]$logStmnt = " log --since=1.week",
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
		HelpMessage = "Necessary Executable")]
	[String]$gitRun = "git.exe",
	[Parameter(Mandatory=$False)]
	[System.Array]$gitRepos,
	[parameter(Mandatory=$False, ValueFromPipeline=$True,
		HelpMessage = "String seperator, usage based on commit syntax")]
	[String]$gitSep = ";" ,
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
		HelpMessage = "Name of tab created in report file")]
	[String]$wksTabName = (get-date -Format "MM.dd.yyyy"),
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
		HelpMessage = "Directory to write report file")]
		[ValidateScript({Test-Path $_ })]
	[String]$wksName = "$env:USERPROFILE\Documents"
)
BEGIN {
	Try {
		Write-Verbose "[BEGIN]Getting locally available Respositories"
		# List of local drives
		$ldrives = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3").ForEach{Join-Path $_.DeviceID -ChildPath "\"}
		$gitRepos = Get-Childitem .git -Path $ldrives -Recurse -Directory -Hidden -ErrorAction SilentlyContinue 
		$gitRepos | select-Object -Property Parent, LastAccessTime, FullName
	}
	Catch {
		Write-Error "No git Repositories Found"
		Start-Sleep -Seconds 3
		Exit
	}
	$Report = New-Object System.Collections.ArrayList
	Write-Verbose "[BEGIN]Creating File Path for accessing the Repo"
	$repoHome = Join-Path -Path $env:USERPROFILE -ChildPath $repoPath
	If (Test-Path $repoHome) {
		Write-Verbose "[BEGIN] Setting current directory to $repoHome"
		Set-Location $repoHome
	}
	Else {
		Write-Error "[BEGIN]Path to repository does not exist"
		Start-Sleep -Seconds 3
	}
	Try {
		Write-Verbose "[BEGIN]Checking for git.exe in the PATH"
		get-command -Name $gitRun -ErrorAction Stop | out-Null
	}
	Catch {
		Write-Error "Unable to Access git command line; install or ensure you start this script from the root folder"
		Start-Sleep -Seconds 3
		Exit
	}
}
PROCESS {
	Try {
		#$gitRun $logStmnt
		# git log --pretty=format:'%Cred%ad%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --since=1.week
		$gitPretty = "%ai$gitSep%s$gitSep%cr$gitSep%an"
		Write-Verbose "[PROCESS]Retrieving git data."
		git log --pretty=format:$gitPretty --abbrev-commit --since=8.days |
			ForEach {
				$logItem = [PSCustomObject]@{
					Date         = Get-Date($_.Split($gitSep)[0]) -Format "MM.dd.yyyy"
					Work         = $_.Split($gitSep)[1]
					TimeDuration = $_.Split($gitSep)[2]
					Author       = $_.Split($gitSep)[3]
				}
				Write-Verbose "[BEGIN]Adding record to Report Array"
				$Report.Add($logItem) > $null
			}
	}
	Catch {
		"Unable to retrieve git log data"
		$Error[0].Exception.Message
	}
	$exportExcelSplat = @{
		Path          = $wksName
		AutoSize      = $true
		WorkSheetname = $wksTabName
	}
	if ((Get-ExcelSheetInfo -Path $wksName).Name -eq $wksTabName) {
		# Clear current worksheet
		Write-Verbose "[PROCESS]WClearing data from $($wksTabName)"
		Export-Excel @exportExcelSplat -ClearSheet
		# write data to cleared tab
		Write-Verbose "[PROCESS ]Writing Data to $($wksName)"
		$Report | Export-Excel @exportExcelSplat
	}
	Else {
		Write-Verbose "[PROCESS]Writing Data to $($wksName)"
		$Report | Export-Excel @exportExcelSplat
	}
}
END {
	Write-Verbose -Message "[END]Script Cleanup"
	Remove-Variable -Name Report
	[System.GC]::Collect()
}