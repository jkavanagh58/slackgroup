#Requires -Modules ImportExcel
# Quick Hit
$fileXLSX = "c:\temp\powershell-goodies.xlsx"

# Process Installed Modules
$installedModules = get-installedmodule | Sort-Object -Property Name | Select-Object -Property Name, Version
$exportExcelSplat = @{
    AutoSize      = $true
    WorksheetName = "PSGallery Modules"
    TableStyle    = 'Light3'
    ClearSheet    = $true
    FreezeTopRow  = $true
    Path          = $fileXLSX
    TableName     = "psModules"
}
$installedModules | Export-Excel @exportExcelSplat

# Process VSCode Extensions
$dataExtensions = @()
$installedCodeExtensions = code --list-extensions --show-versions
ForEach ($installedCodeExtension In $installedCodeExtensions){
    $varExtension = $installedCodeExtension.Split("@")
    $installedExtension = [PSCustomObject]@{
        Name = $varExtension[0]
        Version = $varExtension[1]
    }
    $dataExtensions += $installedExtension
}
$exportExcelSplat = @{
    AutoSize      = $true
    WorksheetName = "VSCode Extensions"
    TableStyle    = 'Light2'
    ClearSheet    = $true
    FreezeTopRow  = $true
    Path          = $fileXLSX
    TableName     = "vscodeExt"
}
$dataExtensions | Export-Excel @exportExcelSplat

Invoke-item -Path $fileXLSX

Remove-Variable -Name install*, exportExcelSplat, fileXLSX, data* 
[System.GC]::Collect()
