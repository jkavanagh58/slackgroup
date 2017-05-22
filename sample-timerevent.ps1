$timer = [Diagnostics.Stopwatch]::StartNew() ; get-date
Get-InstalledModule | out-null
$timer.Stop() ; get-date

"Script took {0} seconds" -f $timer.Elapsed.TotalSeconds

