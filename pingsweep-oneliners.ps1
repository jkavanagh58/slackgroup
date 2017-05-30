# old version 
# Limitations... client machine WMI does not return data but this is a one-liner
1..254 | %{ if (test-connection -Computername "172.22.65.$_" -Count 1 -ErrorAction SilentlyContinue){
	If ($var = gwmi win32_operatingsystem -Computername "172.22.65.$_" -ErrorAction SilentlyContinue){
		$var.caption
	}
}
}
# Less network traffic with this one as it is a DNS lookup
1..254 | %{"172.22.65.$_";(Resolve-DnsName "172.22.65.$_" -ErrorAction SilentlyContinue).NameHost} | out-file c:\etc\65subnet.txt