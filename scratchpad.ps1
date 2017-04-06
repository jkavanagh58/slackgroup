# Just a place for testing work amongst the slack group
<#
Code I would use
[CmdletBinding(SupportsShouldProcess)]
Param(
    [String]$sourcePath = "\\clvprdinfs001\IT_FileSrv\jkav",
    [String]$backupLocation = "c:\etc\temp\FNG",
    [String]$view = "server2",
    [DateTime]$dateMarker = (get-date).AddDays(-60)
)
"Collecting updated files"
$newfiles = get-childitem $sourcePath | where {$_.LastWriteTime -gt $dateMarker}
"Processing {0} files" -f $newfiles.count
$destPath = Join-Path -Path $backuplocation -ChildPath "$(get-date -f yyyyMMdd)\$view"
ForEach ($obj in $newfiles){
    copy-item $obj.FullName -Destination $destPath -Force
}
#>
# This will be re-written since there is no need for the if statement if you collect all the files in the
# get-childitem object
$thisdate = get-date -f yyyyMMdd
$Curr_date = get-date
$Max_days = "-20"
$pub = "server1"
$taskP = New-Item -ItemType Directory -Path "C:\etc\temp\PTC\PTC issues\$thisdate\$pub\Taskmanager\Publisher"
$pubSource = "\\clvprdinfs001\IT_FileSrv\Jkav"
Foreach($file in (Get-ChildItem $pubSource))
{
    if($file.LastWriteTime -gt ($Curr_date).adddays($Max_days))
    {
        Copy-Item -Path $file.fullname -Destination $taskP     
    }
}
