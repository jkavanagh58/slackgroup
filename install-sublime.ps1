#Requires -RunAsAdministrator

$pkgs = "sublimetext3","sumblime.packageControl"
ForEach ($pkg in $pkgs){
    install-package -Name $pkg 
}
# Open sublime, Press "Ctrl" + "Shift" + "P" and Install PowerShell