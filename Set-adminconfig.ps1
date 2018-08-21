Function Enable-RDPAccess {
#Requires -RunAsAdministrator
[CmdletBinding()]
Param (

)
    # Enable RDP
    $setItemPropertySplat = @{
        Path = 'HKLM:SystemCurrentControlSetControlTerminal Server'
        Name = "fDenyTSConnections"
        Value = 0
    }
    set-ItemProperty @setItemPropertySplat
    # Open Firewall Rule for Remote Desktop
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    # Enforce Secure Connections
    $setItemPropertySplat = @{
        Path = 'HKLM:SystemCurrentControlSetControlTerminal ServerWinStationsRDP-Tcp'
        Name = "UserAuthentication"
        Value = 1
    }
    set-ItemProperty @setItemPropertySplat
}
Function Enable-WinHyperV {
#Requires -RunAsAdministrator
[cmdletBinding()]
Param (

)
    $hdwrCheck = Get-CimInstance -ClassName win32_processor -Property Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions 
    If ($hdwrCheck.SecondLevelAddressTranslationExtensions){
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
    }
    Else {
        Write-Error -Message "Unable to enable Hyper-V; SLAT is not enabled."
        Exit
    }

}
