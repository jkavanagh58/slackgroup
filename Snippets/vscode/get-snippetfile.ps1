# Needs CBH
[CmdletBinding()]
Param (
    [parameter(Mandatory=$False, ValueFromPipeline=$True,
        HelpMessage = "URL For the Sample VSCode PowerShell Snippet File")]
    [System.String]$snippetURL = "https://gist.github.com/jkavanagh58/9312bd0d78eddc54d51998c0a5c9831a",
    [parameter(Mandatory=$False, ValueFromPipeline=$False,
        HelpMessage = "VSCode Folder location for User Snippets")]
    [System.String]$snippetFolder,
    [parameter(Mandatory=$False, ValueFromPipeline=$False,
        HelpMessage = "VSCode Folder location for User Snippets")]
    [System.String]$snippetFile
)
BEGIN {
    $snippetFolder = Join-Path $env:APPDATA -ChildPath "\code\User\snippets"
    $snippetFile = Join-Path $snippetFolder -ChildPath "powershell.json"
    If (test-path $snippetFile){
        # Backup the existing Snippet file if it exists
        $snippetBackup = Join-Path $snippetFolder -ChildPath "powershell.bak"
        Rename-Item $snippetFile -NewName $snippetBackup
    }
}
PROCESS {
    Try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        $snip = Invoke-WebRequest -Uri $snippetURL -OutFile $snippetFile -PassThru
        $snip
    }
    Catch {
        $Error[0].Exception.Message
    }

}
END {
    Remove-Variable -Name snip*
    [System.GC]::Collect()
}