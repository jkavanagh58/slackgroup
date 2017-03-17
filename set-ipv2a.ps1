Begin {
	$file = 'C:\etc\srv03sb.csv'
	$computers = Import-Csv -Path $file -Header ComputerName, IPAdress, DNSServer1, DNSServer2, DNSServer3 
	$rptfile = "c:\etc\setip-debug.txt"
}# End Begin
Process {
foreach ($computer in $computers) {
    if(Test-Connection -ComputerName $computer.ComputerName -Count 1 -ea 0) {            
        try {            
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computer.ComputerName -EA Stop | where {$_.IPEnabled}
		}
		catch {            
            Write-Warning "Error occurred while querying $computer."            
            Continue            
        } 
        foreach ($Network in $Networks) {
				#region debug
					$computer.DNSServer1 | out-file $rptfile -Append
				#endregion            
                $dns = @($computer.DNSServer1,$computer.DNSServer2)
				Try {$Network.SetDNSServerSearchOrder($dns) | Out-file $rptfile -Append}
				Catch{
					"Unable to update the DNSSearchOrder for {0}" -f $computer.ComputerName
					$error[0].exception.message
				}
                
        }          
    }
}
} #End Process