<#
.SYNOPSIS
	Securely delete files from the Recycle Bin
.DESCRIPTION
	Securely delete files from the Recycle Bin
.NOTES
	===========================================================================
	Created with:	Visual Studio Code
	Created on:		05.09.2017
	Created by:		John Kavanagh
	Organization:	TekSystems
	Filename:		erase-recyclebin.ps1
	===========================================================================
	05.09.2017 JJK: Working with command line parameters
	05.11.2017 JJK: Added -nobanner
	05.16.2017 JJK: Added function to create sdelete variable dynamically
	05.16.2017 JJK: TODO: If sdelete is not found, function will throw exit
	09.12.2017 JJK: FIXME: Handle folders better
#>
Function get-sdcmdline {
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
)
write-information "Building SDelete cmdline" -Tags "Process"
$script:sdelete = (get-childitem sdelete.exe -Path c:\ -Recurse -ErrorAction SilentlyContinue ).FullName
}
Begin {
	#$sdelete = "C:\Chocolatey\lib\sdelete.2.00\tools\sdelete.exe"
	get-sdcmdline # Function to generate sdelete command line
}
Process {
	if (test-path $sdelete){
		$Recycler = (New-Object -ComObject Shell.Application).NameSpace(0xa)
		$varItems = $Recycler.items()
		foreach ($item in $varItems) {
			"Secure delete of {0}." -f $item.Name
			try {
				# SDelete of file
				. $sdelete -p 7 -s $item.path -nobanner
			}
			catch  {
				# Handle the failure
				write-warning -Message "Unable to delete $item.name"
			}
		}
	}
	Else {
		"Unable to find sdelete executable."
	}
}