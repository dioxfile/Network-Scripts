#!/bin/sh
incr=0x1
hex=0x1
export NIC=$(route -n | egrep "0.0.0.0" | awk '{print $8}' | sort -u) # With or not Gateway)
rede=$( dialog --stdout --inputbox 'Insert IPv6 (Format ->HHHH::):'    0 0 )
mask=$( dialog --stdout --inputbox 'Insert Prefix (ex. /n format):'    0 0 )
Quantity=$( dialog --stdout --inputbox 'Insert IP Quantity (n):'    0 0 )

ifconfig $NIC down
ifconfig $NIC up

for conta in $(seq 1 $Quantity);
do
    hex=$(($hex+$incr))
    hex=$(printf '%#X' $hex)
    hex_=$(echo $hex | awk -F"X" '{print $2}')
    ifconfig $NIC add $rede$hex_/$mask
done;

ifconfig > NIC 
dialog \
--title 'Ifconfig Show'  \
--textbox NIC \
0 0
rm NIC
