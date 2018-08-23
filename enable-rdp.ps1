
#Requires -RunAsAdministrator
<#
.SYNOPSIS
	Enables RDP Access
.DESCRIPTION
	Modifies registry settings that pertain to RDP-tcp. These changes will enable remote desktop access to 
	the local computer
.EXAMPLE
	PS C:\> <example usage>
	Explanation of what the example does
.NOTES
	08.12.2018 JJK:	TODO: Find setting for keeping pc awake for connections
#>
$fdenyTS = get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections"
if ($fdenyTS.fDenyTSConnections -ne 0){
	Try {
        $setItemPropertySplat = @{
            Path  = 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
            Name  = "fDenyTSConnections"
            Value = 0
        }
		set-ItemProperty @setItemPropertySplat
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
$getItemPropertySplat = @{
	Name = "UserAuthentication"
	Path = 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
}
get-ItemProperty @getItemPropertySplat
# Enabled False is off
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Get-Netfirewallrule -DisplayGroup "Remote Desktop" | format-table Name, Enabled -autosize
Get-Netfirewallrule -DisplayGroup "Remote Desktop" | Select-object Name, Enabled | format-table -autosize