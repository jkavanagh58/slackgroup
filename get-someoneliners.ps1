<#
Collection of oneliners for easy reference

.NOTES
    07.22.2018 JJK: Using regions to help code folding if using ISE
#>
<# 
    Powershell Operations
    This is a Collection specific to PowerShell general operations
#>
#region  PoshOps

# Install a Module(s) from PSGallery - these are key if you are using VSCode
Install-Package -Name editorse* -Scope AllUsers -Confirm:$false -Force
# Install a software via chocolatey 
install-package -Name sysinternals -ProviderName Chocolatey -Verbose

#endregion
<# 
File Operations
This is a Collection specific to File Object operations
#>
#region  FileOps

Get-ChildItem *.zip -Path $env:USERPROFILE\Downloads | Unblock-File -Verbose


#endregion

<# 
Network Operations
This is a Collection specific to Network operations
#>
#region NetOps

# Flush the DNS Cache
Clear-DnsClientCache
# Get report of your current DNS Cache - added an example of filtering based on record type
Get-DnsClientCache -RecordType A
# Get report of your current DNS Cache - this one is in here because you need to check the output type
# if you pipe the cmdlet to Get-Member you will see not just text
# Check Get-DnsClientCache | get-member -Name Section
<#
    Name    MemberType Definition
    ----    ---------- ----------
    Section Property   byte Section {get;}
#>
(Get-DnsClientCache).Where{$_.Section -ne 1}

#endregion

<# 
ActiveDirectory Operations
This is a Collection specific to AD operations
#>
#region ADOps

# Get Active Servers Only
get-adcomputer -Filter {OperatingSystem -like "*Windows Server*"} -Properties PasswordLastSet |
    Where-Object {((get-date)-$_.PasswordLastSet).TotalDays -lt 31} |
    Select-Object -Property Name, PasswordLastSet, @{N="DaysElapsed";e={((get-date)-$_.PasswordLastSet).TotalDays}} |
    sort-object -Property Name

#endregion