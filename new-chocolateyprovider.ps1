# Use ChocolateyGet provider as it seems to help with problem packages
# https://github.com/jianyunt/ChocolateyGet
Find-PackageProvider ChocolateyGet -verbose
Install-PackageProvider ChocolateyGet -verbose
Import-PackageProvider ChocolateyGet

# Now let's try that failing package
install-package -Name KeePass  -Verbose -ProviderName ChocolateyGet
