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
#>
$sdelete = "C:\Chocolatey\lib\sdelete.2.00\tools\sdelete.exe"
if (test-path $sdelete){
    $Recycler = (New-Object -ComObject Shell.Application).NameSpace(0xa)
    $varItems = $Recycler.items()
    foreach ($item in $varItems) { 
        "Secure delete of {0}." -f $item.Name
        . $sdelete -p 7 $item.path -nobanner
    }
}
Else {
    "Unable to find sdelete executable."
}