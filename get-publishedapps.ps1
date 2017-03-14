<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.PARAMETER Path
    Specifies a path to one or more locations.
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of LiteralPath is used exactly as it
    is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose
    it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
    characters as escape sequences.
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    Author: John J. Kavanagh
    General notes
.COMPONENT
    The component this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
$broker = [System.Net.Dns]::GetHostByName(($env:computerName)).HostName # use local computer FQDN
$Report = @() # Array for collection report data
ForEach ($col in get-rdsessioncollection -ConnectionBroker $broker){
    $rdapps = Get-RDRemoteApp -ConnectionBroker $broker -CollectionName $col.collectionname
    ForEach ($rdapp in $rdapps){
        $obj = [pscustomobject]@{
            CollectionFieldName     = $rdapp.CollectionName;
            Display                 = $rdapp.DisplayName;
            Application             = $rdapp.FileCollection;
            Access                  = $rdapp.UserGroups
        }
        $Report += $obj
    }
}
