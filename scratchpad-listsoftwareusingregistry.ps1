<#
.SYNOPSIS
	List Installed Software
.DESCRIPTION
	Uses registry to list 32bit and 64bit installed software using the registry. Using WMI to interact with
	installed applications (win32_product) is not advised.
.EXAMPLE
	C:\PS>c:\etc\scripts\scracthpad-listsoftwareusingregistry.ps1
	List 32bit and 64bit applications
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		08.14.2017
	Created by:		Kavanagh, John J.
	Organization:	TEKSystems
	Filename:		scratchpad-listsoftwareusingregistry.ps1
	===========================================================================
	08.17.2017 JJK:	TODO: Add switch param to just display 32bit or 64bit software titles.
#>
[CmdletBinding()]
Param()
Begin {
	$regpath32 = get-itemproperty "HKLM:\Software\wow6432node\microsoft\windows\currentversion\uninstall\*" |
		where DisplayName -ne $Null |
		Select-Object -Property DisplayName
	$regpath64 = get-itemproperty "HKLM:\Software\microsoft\windows\currentversion\uninstall\*" |
		where DisplayName -ne $Null |
		Select-Object -Property  DisplayName
}
Process {
	"32bit Software"
	ForEach ($item in $regpath32 | sort DisplayName){
	"`tName:`t{0}" -f $item.DisplayName
	}
	"64bit Software"
	ForEach ($item in $regpath64 | sort DisplayName){
	"`tName:`t{0}" -f $item.DisplayName
	}
}
End {
	Remove-Variable -Name regpath32,regpath64,item
	[System.GC]::Collect()
}