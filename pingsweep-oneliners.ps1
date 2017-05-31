# old version 
# Limitations... multiple reasons why WMI might not respond
# but this is just a quick sweep
1..254 | %{ if (test-connection -Computername "172.22.65.$_" -Count 1 -ErrorAction SilentlyContinue){
	If ($var = gwmi win32_operatingsystem -Computername "172.22.65.$_" -ErrorAction SilentlyContinue){
		$var.caption
	}
}
}
# Less network traffic with this one as it is a DNS lookup using your machine 
1..254 | %{"172.22.65.$_";(Resolve-DnsName "172.22.65.$_" -ErrorAction SilentlyContinue).NameHost} 
# Use .Net 
1..254 | %{"172.22.65.$_";Try{"`t$([system.net.dns]::getHostByAddress("172.22.65.$_").HostName)"}Catch{"`tNo Data Returned"}}