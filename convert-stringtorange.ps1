
[array]$new = ForEach ($val in $fromcsv.Port | select-object -Unique){
	# Create fully populated array of port numbers
	Try {[int]::parse($val)}
	Catch{Invoke-Expression -Command $val}
}
49153 -in $new