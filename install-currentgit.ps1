#Requires -Module Chocolatey
<#
.SYNOPSIS
	Install git
.DESCRIPTION
	Use Chocolatey to install git for local computer. Determines install versions in choco folder
	and cleans up. Post cleanup runs install based on processor avail.
.PARAMETER chocoInstallPath
	Specifies a path to one or more locations.
.PARAMETER chocoInstallVersion
	Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
	is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
	it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
	characters as escape sequences.
.PARAMETER procAvail
	Specifies the object to be processed.  You can also pipe the objects to this command.
.EXAMPLE
	PS>_
	Example of how to use this cmdlet
.EXAMPLE
	PS>_
	Another example of how to use this script.
.INPUTS
	Inputs to this cmdlet (if any)
.OUTPUTS
	Output from this cmdlet (if any)
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		10.13.2019
	Created by:		John J. Kavanagh
	Organization:	organization
	Filename:		Untitled-1
	===========================================================================
	10.13.2019 JJK:	TODO: Determine currently installed version
	10.13.2019 JJK:	TODO: Handle git and git.install folders
#>
[CmdletBinding()]
Param (
	[parameter(Mandatory = $False, ValueFromPipeline = $False,
		HelpMessage = "HelpMessage")]
	[Int32]$procAvail = ([System.IntPtr]::Size) * 8,
	[parameter(Mandatory = $False, ValueFromPipeline = $False,
		HelpMessage = "Path for Chocoaltey install packages")]
	[System.IO.DirectoryInfo]$chocoInstallPath = "C:\chocolatey\lib",
	[parameter(Mandatory = $False, ValueFromPipeline = $False,
		HelpMessage = "Count of current git installs")]
	[System.IO.DirectoryInfo]$chocoInstallPaths
)
Begin {
	$chocoInstallPaths = $chocoInstallPath.GetDirectories("git*")
	$gitMostCurrent = $chocoInstallPaths | measure-object -Property LastWriteTime -Maximum

	Function clear-gitinstall {
		<#
			.SYNOPSIS
				Remove previous install folders
		#>
		[CmdletBinding()]
		Param(
			[parameter(Mandatory = $False, ValueFromPipeline = $False,
				HelpMessage = "Currently installed version, used to remo")]
			[VariableType]$VariableName
		)

	}
}
Process {
	# Clear up older installs
	$oldInstalls = $chocoInstallPaths |
		where-object { $_.LastWriteTime -lt $gitMostCurrent.Maximum.Date }
	ForEach ($oldInstall in $oldInstalls) {
		clear-gitinstall
	}
}
End {

}