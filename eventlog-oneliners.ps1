# Get Logon Type 10 entries for the last day
(get-eventlog -LogName Security -after ((get-date).AddDays(-1))).where{$_.InstanceID -eq "4624" -Or $_.InstanceID -eq "4634" -and $_.ReplacementStrings[8] -eq 10}
