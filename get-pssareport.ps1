[CmdletBinding()]
Param (
	[System.IO.FileInfo]$xlfile = "c:\temp\slackreport.xlsx",
	[System.IO.DirectoryInfo]$repoFolder = "C:\users\johnk\Documents\github\slackgroup",
	[parameter(Mandatory = $False, ValueFromPipeline = $True,
		HelpMessage = "Specify to only generate report of errors")]
	[Switch]$errOnly
)
Begin {
	# Clean up report file
	If (Test-Path $xlfile) {
		"Deleting existing ScriptAnalyzer Report"
		Remove-Item $xlfile -Force
	}
}
Process {
	# Create array of settings for the Excel file generation
	$p = @{
		AutoSize          = $true
		AutoFilter        = $true
		Show              = $true
		IncludePivotTable = $true
		IncludePivotChart = $true
		Activate          = $true
		PivotRows         = 'Severity', 'RuleName'
		PivotData         = @{RuleName = 'Count' }
		ChartType         = 'BarClustered'
	}
	# Run PSSA reporting only errors
	If ($errOnly) {
		Invoke-ScriptAnalyzer -Severity Error -Path $repoFolder | Export-Excel $xlfile @p
	}
	Else {
		Invoke-ScriptAnalyzer -Path $repoFolder | Export-Excel $xlfile @p
	}
}
End {
	Remove-Variable -Name xlFile, repoFolder, p
	[System.GC]::Collect()
}

