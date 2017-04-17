# add 365 credentials to variable
$o365 = get-credential
# Connect to O365
Connect-MsolService -Credential $o365
# Quick list of User accounts
get-msoluser | where isLicensed