# Use alias but don't save your script with them
# Use Shift+Alt+E
gwmi win32_OperatingSystem
sv -Name SomeVariable -Scope Script
gci *.ps1 -Path C:\etc\scripts
mv test.ps1 -Destination C:\etc\discard

# Make your arrays look good
# Select the following selection and press Ctrl+K Ctrl+F
$splat = @{
	Field1 = "A Value"
	Field2 = $env:COMPUTERNAME
	LongFieldNameThrowsoffalignment = "This is a really long value"
}
# and oh yeah, use splatting to prevent long lines of code