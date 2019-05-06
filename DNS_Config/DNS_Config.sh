#!/bin/sh

DNS=$( dialog --stdout --inputbox 'Enter Primary DNS:'    0 0 )
DNS2=$( dialog --stdout --inputbox 'Enter Secondary DNS:'    0 0 )

echo "# DNS recorded by DNS_Config - By dioxfile Unemat Barra do Bugres." > /etc/resolv.conf
echo nameserver $DNS >> /etc/resolv.conf
echo nameserver $DNS2 >> /etc/resolv.conf
echo "#                      End of Archive resolv.conf" >> /etc/resolv.conf
dialog \
--title 'WARNING' \
--msgbox 'Make sure everything is OK with DNS and Be Happy...' \
6 40
dialog \
--title 'File Contents resolv.conf'  \
--textbox /etc/resolv.conf \
0 0
dig
reset 
