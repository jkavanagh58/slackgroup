# Use ChocolateyGet provider
# https://github.com/jianyunt/ChocolateyGet
Find-PackageProvider ChocolateyGet -verbose
Install-PackageProvider ChocolateyGet -verbose
Import-PackageProvider ChocolateyGet

# Now let's try that failing package
install-package -Name KeePass  -Verbose -ProviderName ChocolateyGet