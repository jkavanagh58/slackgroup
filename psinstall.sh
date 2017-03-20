#! shell script to install PS Core on Ubuntu 
# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Register the Microsoft Ubuntu repository
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
# Update apt-get
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell
# / Remarked out to append vscode install
# Start PowerShell
#powershell
# Install Visual Studio Code
# ubuntu folks use umake personally I prefer apt-get
# umake web visual-studio-code
# / From the Code docs
# Add the repo to application sources
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# Helps to keep prompts down as well as on high secure config if not trusted then unavail
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# Make debian package list compliant
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# / package should now be in list
# Make sure installs are current
sudo apt-get update
# Install vscode
sudo apt-get install code 
# / Optional if you would prefere insiders build
# sudo apt-get install code-insiders 
