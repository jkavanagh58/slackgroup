

# List the installed extensions
# TODO: verify name pattern and if consistent awk it to split the name and version number
$extPath = Join-Path -Path $env:USERPROFILE -ChildPath ".vscode-insiders\extensions"
if (test-path $extPath){
    $varExtensions = get-childitem -Path $extPath
    "You have {0} installed extensions" -f $varExtensions.count
    $varExtensions | sort-object -Property Name | select-object -Property Name
}
