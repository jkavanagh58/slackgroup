<#
.EXAMPLE
	.\test-parameterser.ps1 -workstation
	Will pass the workstation filter to the get-adcomputer cmdlet
.EXAMPLE
	.\test-parameterser.ps1 -server
	Will pass the server filter to the get-adcomputer cmdlet
#>
Param (
	[Switch]$server,
	[Switch]$workstation
)
If ($server -AND $workstation){
	"You cannot specify both ChairForce"
	break
}
If ($server){$filter = "{OperatingSystem -like '*server*'}"}
If ($workstation){$filter = "{OperatingSystem -like '*workstation*'}"}

"You will be using {0} as your filter" -f $filter