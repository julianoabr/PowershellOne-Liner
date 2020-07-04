#Usefull commands to daily tasks


Get-Service | Sort-Object -Property Status | ConvertTo-Xml -As String

Get-Service | ConvertTo-Xml -As String | Out-File .\servicesxml.xml

Get-Service | Where Status -eq Running

Get-Service | Where CanShutDown -eq True

Get-Service | Where Name.Length -gt 5

############################################################################
$AllServices = Get-Service

$nameServices = $AllServices | Select-Object -ExpandProperty Name

Foreach ($name in $nameServices){
    if ($name.Length -gt 20){
    Write-Output $name
    } 
}
#############################################################################

Get-Service | Where-Object -Property Status -eq Running

Get-Service | Where-Object -FilterScript {$PSItem.Status -eq 'Running'}

Get-Service | Where-Object -FilterScript {$_.Status -eq 'Running' -or $_.Status -eq 'Starting'}

Measure-Command {Get-Service | Sort-Object -Property Name | Where-Object -FilterScript {$PSITEM.StartType -eq 'Manual'}}

Measure-Command {Get-Service | Where-Object -FilterScript {$PSItem.StartType -eq 'Manual'} | Sort-Object -Property Name}

Measure-Command {Get-Service | Where Name -Like svc*}

Measure-Command {Get-Service -Name svc*}

#Must have in same directory a text file called computers.txt
Get-Service -ComputerName (Get-Content .\computers.txt) | Select-Object -Property MachineName,ServiceName,Status | Sort-Object -Property MachineName


#Get service of all computers in domain
Get-ADComputer –Filter * | Select @{n='ComputerName';e={$PSItem.Name}} | Get-Service –Name *

Get-ADComputer –Filter * | Select @{n='ComputerName';e={$PSItem.Name}} | Get-Service -Name * | Select-Object -Property MachineName,ServiceName,Status

Get-ADComputer -filter * | Select-Object -ExpandProperty Name | foreach {Get-Service -ComputerName * | Select-Object -Property MachineName,ServiceName,Status}

#Set service to automatic em computers
Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | foreach {Set-Service -ComputerName $_ -Name WinRM -StartupType Automatic -Confirm:$false -Verbose}

#Group by some parameter
Get-Service | Format-Table –GroupBy Status

Get-Service | Sort Status | Format-Table –GroupBy Status


Get-WmiObject -Namespace root\Cimv2 -Class Win32_Service -Recurse | Select-Object -Property Name,ProcessID,State,Status,ExitCode | Sort-Object -Property Name | Format-Table -AutoSize -Wrap


#CHANGE PASSWORD OF A SERVICE
Get-WmiObject –Class Win32_Service –Filter "Name='MyService'" | ForEach-Object { $PSItem.Change($null,$null,$null,$null,$null,$null,$null,"P@ssw0rd")}

Get-WmiObject -Class win32_service | Where-Object -FilterScript {$psitem.startname -like "n*"} | Select-Object -Property Name,Status,StartName


#TRY CATCH FIRST 
$name = 'ServerName'
try
{
   Get-WmiObject -Class Win32_Service -ComputerName $name -ErrorAction Stop
}
catch 
{
    Write-Output "Error connection to Computer: $name"
}

#TRY CATCH TO AN ERROR VARIABLE
try
{
    Get-CimInstance -ClassName win32_Service -ComputerName $name -OperationTimeoutSec 2 -ErrorAction Stop -ErrorVariable MyErr
}
catch 
{
    Write-Host "Error to Connect to Computer: $name" -ForegroundColor Red -BackgroundColor White
    $MyErr | Out-File -FilePath "$env:SystemDrive\Errors.txt"
}

#JOB
Invoke-Command -ScriptBlock {get-service} -ComputerName ServerName -AsJob


