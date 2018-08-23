<#
.SYNOPSIS
	List local logon activity
.DESCRIPTION
	Query security EventLog for logon entries
.EXAMPLE
	I ♥ PS #  C:\etc\scripts\get-logoninfo.ps1
	Example of how to use this script
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		09.13.2017
	Created by:		Kavanagh, John J.
	Organization:	TEKSystems
	Filename:		get-logoninfo.ps1
	===========================================================================
	09.13.2017 JJK:	Just a framework
#>

[cmdletbinding()]
Param(

)
Begin{
#Requires -RunAsAdministrator
$weekago = (get-date).AddDays(-7)
$Report = @() # Array for report objects
$elParams = @{
	LogName    = "Security"
	InstanceID = "4624"
	After      = $weekago
}
}
Process {
	# Query eventlog for a week worth of data and ignore SYSTEM logins
	$logentries = Get-EventLog @elParams  | Where ReplacementStrings -notcontains "SYSTEM"
	ForEach ($entry in $logentries){
		$obj = [pscustomobject]@{
			Time           = $entry.TimeGenerated
			User           = $entry.ReplacementStrings[5]
			Domain         = $entry.ReplacementStrings[6]
			Path           = $entry.ReplacementStrings[17]
			Authentication = $entry.ReplacementStrings[10]
			Message        = $entry.Message.Split("`r")[0]
		}
		$Report += $obj
	}
}
End {
	$Report
}