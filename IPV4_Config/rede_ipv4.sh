#!/bin/bash
export NIC=$(route -n | egrep "0.0.0.0" | awk '{print $8}' | sort -u) # With or not Gateway
rede=$( dialog --stdout --inputbox 'Insert the Network Scope (ex. 10.0.0):' 0 0 )
mask=$( dialog --stdout --inputbox 'Insert the Netmask /n format:' 0 0 )
Quantity=$( dialog --stdout --inputbox 'Insert IPs Quantity (n):'    0 0 )
ifconfig $NIC down
ifconfig $NIC up

for conta in $(seq 1 $Quantity);
do
ifconfig $NIC:$conta $rede.$conta/$mask up
done;

ifconfig > NIC 
dialog \
--title 'Ifconfig Show'  \
--textbox NIC \
0 0
rm NIC
