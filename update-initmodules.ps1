<#
.LINK https://p0w3rsh3ll.wordpress.com/2018/05/04/about-updating-inbox-powershell-modules/
    This is the code that influenced this code
#>
$modules = "pester", "packagemanagement", "PowerShellGet"
ForEach ($module in $modules){
    # Inspect module first before wasting time updating it
    
    # Step 1: Save locally
    Find-Module -Name $module -Repository PSGallery -Verbose | 
    Save-Module -Path  ~/Downloads -Verbose
    
    # Step 2: remove alternate stream if any
    dir ~/Downloads/$module/* -rec -for -ea 0 | 
    Unblock-File -Verbose
    
    # Step 3: move to Programfiles
    gi ~/Downloads/$module/* | 
    Copy-Item -Destination "C:\Program Files\WindowsPowerShell\Modules\$module" -Recurse




    Install-Module -Name $module -Repository PSGallery -SkipPublisherCheck
    Install-Module -Name $module -SkipPublisherCheck -Force -Repository PSGallery 
}