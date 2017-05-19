<#
.SYNOPSIS
    Looks for servers where auser is logged on.
.DESCRIPTION
    Was written with an admin account in mind so it limits the search to servers but could be modified to run against
    enabled computers. For each computer that is found a simple online test is initiated if that test finds the computer is
    reachable the current processes are checked. Each instance of explorer is evaluated for the owner. If the username matches the owner
    it is reported. I use this in conjunction with get-lockedoutlocation when trying to find a reason for an account to continue
    to get unlocked. I scoped this to servers as that was more applicable for my use but the get-adcomputer can be changed based
    on need.
.PARAMETER username
    Specifies the logonname to evaluate and report on.
.EXAMPLE
    C:\PS>c:\etc\scripts\get-loggedonlocations.ps1 -username someuser
    Will return results for any instances matching someuser
.NOTES
    Author: John J. Kavanagh
    03.09.2017 JJK: TODO: Create Advanced function out of this script.
    04.06.2017 JJK: TODO: Provide switch param set to pick the computer type to run against
#>
Param($username)
$username = "admjkavanagh"
$servers = get-adcomputer -Filter {OperatingSystem -like "*Server*" -AND Enabled -eq $True} | sort-object Name
ForEach ($srv in $servers){
    if (test-connection -computername $srv.name -Count 1 -Quiet -ErrorAction SilentlyContinue){
        $usrProcs = Get-WmiObject Win32_Process -ComputerName $srv.Name -ErrorAction SilentlyContinue | Where {$_.Name -like "explorer.*"}
        if($usrProcs){
            ForEach ($proc in $usrProcs){
                if ($proc.GetOwner().User -eq $username){
                    "User logon found on {0}" -f $srv.Name
                }
            }
        }
    }
}


