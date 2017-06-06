# White Spaces versus tabs
$adapters = get-ciminstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'"
ForEach ($adapter in $adapters){
	"{0} has default gateway is {1}" -f $adapter.Description, $($adapter.DefaultIPGateway)
}
