<#
.SYNOPSIS
    Digitally signs a PowerShell script.
.DESCRIPTION
    Digitally signs a PowerShell script. Uses the first CodeSigning certificate found in your 
    certificate store.
.PARAMETER sFile
    Name of Script to be Signed
.EXAMPLE
    C:\etc\scripts>.\sign-psfile -ScriptFile C:\etc\scripts\test-script.ps1
    Another example of how to use this cmdlet
.NOTES
    ===========================================================================
    Created with: 	Visual Studio Code
    Created on:   	05.02.2014
    Created by:   	John Kavanagh
    Organization: 	Kavanaghtech
    Filename:     	sign-psfile.ps1
    ===========================================================================
    06.08.2017 JJK: TODO: Add File Open Dialog Box to allow operator to select file to
                    sign
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param( 
    [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
    [Alias("ScriptFile")]
    [String]$sFile 
)
# If file entered on commandline exists digitally sign    
if (test-path $sFile){
    "Signing $sFile"
    # Select the Certificate designate for CodeSigning
    $cert = @(Get-ChildItem cert:\CurrentUser\Root -codesigning)[0]
    # Sign file 
    Set-AuthenticodeSignature $sFile $cert
}
Else { "Unable to find $($sFile)" }