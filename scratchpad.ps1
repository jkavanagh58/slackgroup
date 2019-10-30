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
$mythisdate = get-date -UFormat %Y%M%d
$Curr_date = get-date
$Max_days = "-20"
$pub = "server1"
$taskP = New-Item -ItemType Directory -Path "C:\etc\temp\PTC\PTC issues\$thisdate\$pub\Taskmanager\Publisher"
$pubSource = "\\clvprdinfs001\IT_FileSrv\Jkav"
Foreach ($file in (Get-ChildItem $pubSource)) {
    if ($file.LastWriteTime -gt ($Curr_date).adddays($Max_days)) {
        Copy-Item -Path $file.fullname -Destination $taskP
    }
}
get-installedmodule | sort-object Name | select-object Name, Version, @{N = "OnlineVersion"; e = {(find-module -Name $_.Name).version}}

<#
// CIM //
.LINK
    https://blogs.msdn.microsoft.com/powershell/2013/08/19/cim-cmdlets-some-tips-tricks/
#>
(get-cimclass -ClassName win32_operatingsystem).CimClassMethods
<#
    Reboot a computer via CIM
    This is really just about using CIM to invoke a method. Personally I prefer the restart-computer cmdlet
    since it provides the Wait and For parameters so that you can restart a computer and then pause processing
    until the computer is back up.
#>
invoke-cimmethod -ClassName Win32_operatingsystem -computer $varComputer -MethodName Reboot
# WMI is still a little slicker here but just a quick start
$slack = get-ciminstance -ClassName Win32_Process -Filter "Name = 'Slack.exe'"
# I need to clean this up because if one is dependent it fails as where
# (get-process slack).kill() is rock solid but this is an example
$slack | ForEach {Invoke-CimMethod -InputObject $_ -Method Terminate}


$usercreds = get-credential "john.kavanagh@somedomain.com"
send-mailmessage -From "john.kavanagh@somedomain.com" -to "john.kavanagh@somedomain.com" -Body "PowerShell Message" -BodyAsHtml -Subject "Long winded" -SmtpServer "smtp.somedomain.com" -Credential $usercreds
$usercreds = get-credential "john.kavanagh@somedomain.com"
# Now lets splat it
$mailargs = @{
    From       = "John.Kavanagh@somedomain.com"
    To         = "John.Kavanagh@somedomain.com"
    Body       = "PowerShell Message"
    BodyAsHTML = $true
    Subject    = "Splatted"
    SmtpServer = "smtp.somedomain.com"
    Credential = $usercreds
}
send-mailmessage @mailargs

# test-connection vs ping

$returnedIP = (test-connection wks-jkavanag-01 -Count 1 -Quiet).IPV4Address

# Port 445 - File and Printer Sharing
$netBTKey = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" 
IF(Test-Path -Path $netBTKey) { 
    Set-ItemProperty -Path $netBTKey -Name "SMBDeviceEnabled" -Value 0 
} 
Set-Service lanmanserver -StartupType Disabled 
Stop-Service lanmanserver -Force

# https://www.powershellgallery.com/packages/Test-WannaCryVulnerability/1.4/DisplayScript
install-script -Name Test-wannacryVulnerability -Path c:\etc\scripts -RequiredVersion 2.0 -Scope AllUsers

# Disable SMB1 Protocol
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Disable SMB1 Feature
Disable-WindowsOptionalFeature -FeatureName SMB1Protocol -Online


# Only check for SMB1 - Remote
$cimsession = New-CimSession -ComputerName somecomputer -credential $admcreds
$smbVals = get-smbserverconfiguration -cimSession $cimsession
If ($smbvals.EnableSMB1Protocol){"`nSMB1 Should be disabled"}Else{"`nSMB1 is not enabled"}
$cimsession.Dispose()

# Check for SMB1 and Disable - Remote
$cimsession = New-CimSession -ComputerName somecomputer -credential $admcreds
$smbVals = get-smbserverconfiguration -cimSession $cimsession
If ($smbvals.EnableSMB1Protocol){
    "`nSMB1 Being disabled"
    try {
        # Process to run
        Set-SmbServerConfiguration -CimSession $cimsession -EnableSMB1Protocol $False -confirm:$False
    }
    catch  {
        # Handle the failure
        Write-Warning -Message "Unable to remotely disabled SMB1 Protocol"
    }
}
Else {"`nSMB1 is not enabled"}
$cimsession.Dispose()
