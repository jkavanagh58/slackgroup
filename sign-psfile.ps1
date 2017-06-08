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
    [Parameter(ValueFromPipeline=$true, Mandatory=$false)]
    [Alias("ScriptFile")]
    [String]$sFile 
)
# Show an Open File Dialog and return the file selected by the user.
function Read-OpenFileDialog([string]$WindowTitle, [string]$InitialDirectory, [string]$Filter = "All files (*.*)|*.*", [switch]$AllowMultiSelect) {  
    Add-Type -AssemblyName System.Windows.Forms
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = $WindowTitle
    if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
    $openFileDialog.Filter = $Filter
    if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }
    $openFileDialog.ShowHelp = $true    # Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $openFileDialog.ShowDialog() > $null
    if ($AllowMultiSelect) { return $openFileDialog.Filenames } else { return $openFileDialog.Filename }
}
$sFile = Read-OpenFileDialog -WindowTitle "Select the script to be Digitally Signed" -InitialDirectory 'C:\' -Filter "Script files (*.ps1)|*.ps1"
if (![string]::IsNullOrEmpty($filePath)) { "You selected {0} to be digitally signed" -f $sFile}
else { "You did not select a file." }
# If file entered on commandline exists digitally sign    
if (test-path $sFile){
    "Signing $sFile"
    # Select the Certificate designate for CodeSigning
    try {
        $cert = @(Get-ChildItem cert:\CurrentUser\Root -codesigning)[0]
    }
    Catch {
        "No Appropriate Certificate was found."
        Exit
    }
    # Sign file 
    Set-AuthenticodeSignature $sFile $cert
}
Else { "Unable to find $($sFile)" }