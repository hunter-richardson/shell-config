#!/usr/bin/fish

function iwgetid -d 'display SSID if connected to the Internet'
  builtin printf '%s\n' (builtin string split ' ' (command powershell 'if(Get-NetConnectionProfile | select IPv4Connectivity | where IPv4Connectivity -eq "Internet") { Write-Host (Get-NetConnectionProfile -IPv4Connectivity "Internet").Name }'))[1]
end
