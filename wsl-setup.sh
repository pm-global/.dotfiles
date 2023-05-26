#! /bin/bash

echo '(Get-NetIPAddress -InterfaceAlias "VEthernet (WSL)" | select -last 1).IPAddress' |powershell.exe -NoProfile -NoLogo | grep 192 | tr -d '\r' | read gateway; sudo ifconfig eth0 netmask 255.255.240.0; sudo ip route add default via $gateway; echo "Set gateway to $gateway"

