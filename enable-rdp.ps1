
$fdenyTS = get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections"
if ($fdenyTS.fDenyTSConnections -ne 0){
    Try {
        set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
    }
    Catch {
        "Unable to make changes to fDenyTSConnections"
        $error[0].Exception.Message
    }
}
# value 0 is off
# Let's splat this so it looks better
# now let's align the key pairs
$setItemPropertySplat = @{
    Path  = 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
    Name  = "UserAuthentication"
    Value = 1
}
set-ItemProperty @setItemPropertySplat
get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication"
# Enabled False is off
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Get-Netfirewallrule -DisplayGroup "Remote Desktop" | format-table Name, Enabled -autosize
Get-Netfirewallrule -DisplayGroup "Remote Desktop" | Select-object Name, Enabled | format-table -autosize