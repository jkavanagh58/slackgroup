[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
Param(
	[array]$extArray,
	[String]$curExt
)
Begin{
# Configure vscode with suggested extensions
# array of suggested extensions
$extArray = @(
	"denisgerguri.hunspell-spellchecker",
	"WakaTime.vscode-wakatime",
	"Compulim.vscode-ipaddress",
	"invalid"
)
$curExt = invoke-express -command ".code --list-extensions"
}
$isRunning = (get-process)Name -contains "code")
Process {
If ($isRunning){
	"Visual Studio Code is running and willl needs to be closed"
	Try{
		(get-process)
	}
}
ForEach ($ext in $extArray){
	if ($curExt -contains $ext){
		"{0} extension is already installed"
	}
	Else{
		try {
		. code --install-extension $ext
		}
		Catch {
			$msg = "Unable to install {0}" -f $ext
			write-warning -Message $msg
		}
	}
}


