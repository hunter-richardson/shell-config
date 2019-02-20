#!/bin/bash

function iwgetid() {
  command powershell 'if(Get-NetConnectionProfile | select Name,IPv4Connectivity | where IPv4Connectivity -eq "Internet") { Write-Host (Get-NetConnectionProfile -IPv4Connectivity "Internet").Name }'
}

