Get-EventLog -LogName System | Select-Object -First 10 | 
Select-Object -Property Index,Time,EntryType,Source,InstanceID,Message | ConvertTo-Csv | Out-File -FilePath .\first10SystemEvents.csv 

Get-EventLog -LogName System | Select-Object -First 10 -Property Index,Time,EntryType,Source,InstanceID,Message | 
ConvertTo-Csv | Out-File -FilePath .\TenFirstEventLog.csv -Append

Get-EventLog -LogName System | Select-Object -First 10

Get-EventLog -LogName System | Select-Object -First 10 | 
Select-Object -Property Index,Time,EntryType,Source,InstanceID,Message | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath .\first10SystemEventsb.csv 

Get-EventLog -LogName Security -Newest 100 | Where-Object -FilterScript {$PSItem.EventID -eq 4672 -and $PSItem.EntryType -eq 'SucessAudit'}


#Export Events To CSV and HTML
$parentPath = "$env:systemdrive\Temp"

$outputfile = ($parentPath + "\Report-Event4673.csv")

$event4673 = Get-EventLog -LogName Security -Newest 500 | Where-Object -FilterScript {$PSItem.EventID -eq '4673'} 

$event4673 | Select-Object -Property Index,@{label='Time';expression={$PSItem.TimeWritten}},EntryType,Source,Message | Format-Table -AutoSize -Wrap | Out-File $outputfile

$event4673 | Select-Object -Property TimeWritten,EventID,Message | ConvertTo-Html | Out-File "C:\temp\event4673.html"

#GET EVENT LOG REMOTE
Get-EventLog -ComputerName (Get-ADComputer -Filter 'Name -like "serverName*"' | Select-Object -ExpandProperty Name | 
Sort-Object) -LogName System -Newest 50 | 
Select-Object -Property MachineName, Index, Time, EntryType, Source, Message | Format-Table -AutoSize -ErrorAction Continue

#GET EVENTS AND CONVERT TO HTML
Get-EventLog -Logname System -Newest 5 | 
Select -Property EventID, TimeGenerated, TimeWritten, Message | sort -Property TimeWritten | ConvertTo-Html | Out-File C:\Error.html

#CHANGE EVENT LOG ACTION ON WINDOWS
$Logs = Get-EventLog -List | ForEach {$_.log}
Limit-EventLog -OverflowAction OverwriteAsNeeded -LogName $Logs
Get-EventLog -List

#GET SPECIFIC EVENTS
Get-WinEvent -LogName Microsoft-Windows-FailoverClustering/Operational | Where-Object -FilterScript {$_.Message -like "*serverName*"}








