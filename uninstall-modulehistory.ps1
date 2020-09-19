<#
	Here is an example of how you can do this as a oneliner
	#$Latest = Get-InstalledModule (modulename); Get-InstalledModule (modulename) -AllVersions | ? {$_.Version -ne $Latest.Version} | Uninstall-Module -WhatIf
	The following code cleans it up and makes it reusable code (aka Toolmaking)
	TODO: Wrap a disk size report into the process as a nice report option
#>
[CmdletBinding()]
Param(
	[parameter(Mandatory=$False, ValueFromPipeline=$False,
		HelpMessage = "Collection of locally installed modules")]
	[System.Array]$modInstalled
)
Begin {
	Function Get-FreeSpace {
		[System.String]$driveInfo = $env:psmodulepath.split(";")[0].SubString(0,2)
		$free = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID = '$driveInfo'"
		Return $free.FreeSpace / 1GB
	}
	$startFree = Get-FreeSpace
	"Gathering list of Installed Modules"
	$modInstalled = Get-InstalledModule
}
Process {
	ForEach ($curModule in $modInstalled){
		$modInfo = Get-InstalledModule $curModule.Name -AllVersions
		"{0} has an installed history of {1} versions, Latest version is {2}" -f $curModule.Name, $modinfo.count, $curModule.Version
		$oldVersions = $modinfo | Where-Object {$_.Version -ne $curModule.Version}
		If ($oldVersions){
			ForEach ($deprecated in $oldversions){
				Try {
					$deprecated | Uninstall-Module -Confirm:$false -Force
					"`tUninstalled Version: {0}" -f $deprecated.Version
				}
				Catch {
					"`tUnable to Uninstall Version: {0}" -f $deprecated.Version
					$error[0].Exception.Message
				}
			}
		}
		Else {
			"`tNo Clean-up needed for {0}" -f $curModule.Name
		}

	}
}
End {
	$endFree = Get-FreeSpace
	Remove-Variable -Name curModule, modInstalled, modInfo
	[System.GC]::Collect()

}