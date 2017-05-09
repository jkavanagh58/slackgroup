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
#>
$sdelete = "C:\Chocolatey\lib\sdelete.2.00\tools\sdelete.exe"
if (test-path $sdelete){}
    $Recycler = (New-Object -ComObject Shell.Application).NameSpace(0xa)
    $Recycler.items() | foreach { . $sdelete -p 7 $_.path }
}
Else {
    "Unable to find sdelete executable."
}