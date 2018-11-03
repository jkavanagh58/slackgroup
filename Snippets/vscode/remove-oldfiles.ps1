[CmdletBinding()]
Param (
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to directory for fine cleanup.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Path $_ -PathType 'Container'}]
    [System.String[]]$homeFolder
)
BEGIN {

}
PROCESS {
    Foreach ($file in (Get-ChildItem $pubSource)) {
        if ($file.LastWriteTime -gt ($Curr_date).adddays($Max_days)) {
            Copy-Item -Path $file.fullname -Destination $taskP     
        }
    }
}