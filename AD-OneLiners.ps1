# Load RSAT ActiveDirectory module if it isn't already loaded
# # Requires Win2008R2 RSAT AD/DS Tools are installed
if (!(get-module activedirectory)){import-module activedirectory}

# Get an AD user object matching FirstName, LastName
get-aduser -Filter {(GivenName -eq 'FirstName') -and (Surname -eq 'LastName')}

# Test if a user is pointing to new home and profile paths
# Replace <samAccountName> with logon name
get-aduser <samAccountName> -Properties HomeDirectory,ProfilePath | select Name, HomeDirectory, ProfilePath

# Limit user list to only accounts that are Enabled
get-aduser -Filter {Enabled -eq $True} | Select Name
# Can be run against other domains/forests
get-aduser -Server Swagelokscs -Filter {Enabled -eq $True} | Select Name
# or Find Disabled Accounts
Get-ADUser -Filter {Enabled -eq $False} -Properties LastLogonDate | sort Name | select Name,LastLogonDate

# Get a list of group members
# Replace <groupName> with the Name of the group to be listed.
get-adgroupmember -Identity <groupname> | select Name

# Get a list of all groups a user is a member of
# Replace <samAccountName> with logon name
Get-ADPrincipalGroupMembership -Identity <samAccountName> | select Name
# List the groups GPO specific
Get-ADPrincipalGroupMembership -Identity juser | select-string gpo
# refine to just group name not the CN
Get-ADPrincipalGroupMembership -Identity juser | select-string gpo | %{(get-adgroup $_.line ).name}

# Un-lock a user account
# Replace <samAccountName> with logon name
unlock-adaccount <samAccountName>

# List all Windows 7 Computers
get-adcomputer -properties OperatingSystem -Filter "OperatingSystem -like 'W*7*'" | sort Name

# List all Windows Servers in a domain
Get-ADComputer -SearchBase 'dc=domain,dc=com' -Properties OperatingSystem -Filter {OperatingSystem -like 'W*Server*'} |
	sort Name | select Name, OperatingSystem
# Conversely 
Get-ADComputer -SearchBase 'dc=domain,dc=com' -Properties OperatingSystem -Filter {OperatingSystem -notlike 'W*Server*'} |
	sort Name | select Name, OperatingSystem

# List all domain controllers
Get-ADDomainController -Filter * | select name,OperationMasterRoles,Partitions
