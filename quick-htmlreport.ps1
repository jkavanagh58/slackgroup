$Report = @()
$style = @'
<style type="text/css">
table {
	width: 100%;
}
th {
	background-color: darkBlue;
	color: yellow;
}
caption {
    background-color: #f5f5f0;
    font-family: Monospace;
    border: 1px solid black
}
table, th, td {
	border: 1px solid black;
    border-collapse:collapse;
}
tr:nth-child(even) {
    background-color: AliceBlue};
}
'@
}
Process {
	#Build list of servers
	If ((get-date).Month -eq 1){
		# Handle report run in January
		$serverlist = get-adcomputer -Filter {OperatingSystem -like "*Server*"} -Properties OperatingSystem, WhenCreated |
		where {(get-date($_.WhenCreated)).Month -eq 12 -And (get-date($_.WhenCreated)).Year -eq (get-date).AddYears(-1).Year} |
		Sort-Object -Property WhenCreated
	}
	Else {
		$serverlist = get-adcomputer -Filter {OperatingSystem -like "*Server*"} -Properties OperatingSystem, WhenCreated |
		where {(get-date($_.WhenCreated)).Month -eq (get-date).AddMonths(-1).Month -And (get-date($_.WhenCreated)).Year -eq (get-date).Year} |
		Sort-Object -Property WhenCreated
	}
	ForEach ($srv in $serverlist ){
		Try {
			$nslooktest = [System.Net.Dns]::GetHostAddresses($srv.DNSHostName)
			$DNSRec = $True
			$ipAddr = $nslooktest.IPAddressToString
		}
		Catch {
			$DNSRec = $False
			$ipAddr = "No Data"
		}
		if ($DNSRec){
			try {
				$machType = get-wmiobject -Class Win32_ComputerSystem -ComputerName $srv.DNSHostName -ErrorAction Stop
				Switch ($machType.Manufacturer) {
					"VMware, Inc." {$platform = "VMware"}
					"Microsoft Corporation" {$platform = "Hyper-V"}
					Default {$platform = "Physical"}
				}
			}
			Catch {
				$platform = "No Data"
			}
		}
		Else {
			$platform = "No Data"
		}
		$obj = [pscustomobject]@{
			ServerName  = $srv.Name
			IPAddress   = $ipAddr
			DateCreated = $srv.WhenCreated
			OS          = $srv.OperatingSystem
			InDNS       = $DNSRec
			Platform    = $platform
		}
		$Report += $obj
		remove-variable ipAddr, DNSRec
	}
	"Found {0} new servers to report on" -f $serverlist.count
	$tblHeader = "Servers Created in Last {0} Days" -f $serverAge
	$headerString = "<table><caption> Servers Created in {0}</caption>" -f (Get-Culture).DateTimeFormat.GetMonthName((get-date).AddMonths(-1).Month)
	$htmParams = @{
		Body = "<h1>Monthly New Server Report<h1>"
		Head = $style
		Title = "New Server Report"
		As = "Table"
		PreContent = $headerString
	}
	$reportData = $Report | ConvertTo-HTML @htmParams | out-string