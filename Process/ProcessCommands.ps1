<#
.Synopsis
   Usefull commands to work with process in windows
.DESCRIPTION
   Usefull commands to work with process in windows
.EXAMPLE
   Each line has one command 
.AUTHOR
  Juliano Alves de Brito Ribeiro (find me at @julianoalvesbr@live.com
 
#>

Get-Process | Select-Object Name,ID,@{n='VirtualMemory';e={$PSItem.VM}},@{n='PagedMemory';e={$PSItem.PM}}

Get-Process | Select-Object Name,ID,@{label='VirtualMemory';expression={$PSItem.VM}},@{l='PagedMemory';expression={$PSItem.PM}}


Get-Process | Select-Object Name,ID,
        @{label='VirtualMemory';expression={$PSItem.VM}},
        @{label='PagedMemory';expression={$PSItem.PM}}


Get-Process | Select-Object Name,
                            ID,
                            @{label='VirtualMemory';expression={[math]::Round($PSItem.VM / 1MB)}},
                            @{label='PagedMemory(MB)';expression={[math]::Round($PSItem.PM / 1MB)}}



Get-Process | Select-Object Name,
                            ID,
                            CPU,
                            @{label='VirtualMemory(MB)';expression={[math]::Round($PSItem.VM / 1MB)}},
                            @{label='PagedMemory(MB)';expression={[math]::Round($PSItem.PM / 1MB,2)}}


Get-Process -ComputerName onetamxa0060 |
	ft @{Label = "NPM(K)"; Expression = {[int]($_.NPM / 1024)}},
	@{Label = "PM(K)"; Expression = {[int]($_.PM / 1024)}},
	@{Label = "WS(K)"; Expression = {[int]($_.WS / 1024)}},
	@{Label = "VM(M)"; Expression = {[int]($_.VM / 1MB)}},
	@{Label = "CPU(s)"; Expression = {if ($_.CPU) {$_.CPU.ToString("N")}}},
	Id, MachineName, ProcessName -Auto


Get-Process | Sort-Object -Property Name -Descending |
Select-Object -Property Name,
                          ID,
                          @{label='Virtual Memory(MB)';expression={'{0:N0}' -f ($PSItem.VM / 1MB)}},
                          @{label='Paged Memory(MB)'; expression={'{0:N0}' -f ($PSItem.PM / 1MB)}}
