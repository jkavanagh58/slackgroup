#Requires -RunAsAdministrator
[CmdletBinding()]
Param (
	[parameter(Mandatory = $False, ValueFromPipeline = $False,
		HelpMessage = 'Counter for Prgress Bar')]
	[Int16]$modCounter = 0
)
Begin {
	Function Remove-ModuleVersion {
		[CmdletBinding()]
		Param (
			[parameter(Mandatory = $True, ValueFromPipeline = $True,
				HelpMessage = 'Module Data')]
			$modObject
		)
		Write-Information -MessageData "Uninstall $($modObject.Name) Version $($modObject.Version)" -InformationAction Continue
		Uninstall-Module $modObject -Force
	}
	$modList = Get-InstalledModule
	"Processing $($modList.Count) Installed Modules"
}
Process {
	ForEach ($modItem in $modList) {
		$modCounter++
		Write-Progress -Activity 'Cleaning up Module Installs' -Status "Evaluating $($modItem.Name)" -PercentComplete ((($modCounter) / $modList.Count) * 100)
		$modName = $modItem.Name
		$modMax = $modItem.Version
		$modLesser = Get-InstalledModule -Name $modName -AllVersions | Where-Object { $_.Version -ne $modMax }
		If ($modLesser.Count -ge 1) {
			ForEach ($mod in $modLesser) {
				#Uninstall-Module $mod -WhatIf
				Remove-ModuleVersion -modObject $mod
			}
		}
		Else {
			Write-Information -MessageData "No cleanup needed for $($modName)" -InformationAction Continue
		}
	}

}
End {
	#Remove-Variable -Name modCounter, modList, modItem, modName, modMax
	[System.GC]::Collect()
}
