#!/bin/dash
if ! [ -x "$(command -v dialog)" ]; then
  echo 'Error: "dialog" is not installed. Please Install it first!!!' >&2
  exit 1
fi
dialog \
--title 'SHARED INTERNET WITH IPTABLES FOR TWO IFACES (LAN/WAN)' \
--msgbox 'CLICK IN "OK" AND TYPE BELOW THE PARAMETERS FOR SHARE THE INTERNET' \
0 0
ON_OFF_FORWARDING=$(dialog --stdout --inputbox 'Type 1 for enable Forwarding or 0 to turn off it:'    0 0 )
[ "$ON_OFF_FORWARDING" ] ||
{ dialog \
--title 'WARNING' \
--msgbox 'ERROR: value can not by empty!!!' \
0 0;exit; }
if [ "$ON_OFF_FORWARDING" != "1" || "$ON_OFF_FORWARDING" != "0" ]; then
{ dialog \
--title 'WARNING' \
--msgbox 'ERROR: value must be '1'or '0'!!! ' \
0 0;exit; }
fi
if [ "$ON_OFF_FORWARDING" = "0" ]; then
{ dialog \
--title 'AVISO' \
--msgbox 'FIN: Operation stoped!!!' \
0 0;exit; }
fi

IFACE_IN=$( dialog --stdout --inputbox 'Type your LAN Iface:'    0 0 )
[ "$IFACE_IN" ] ||
{ dialog \
--title 'WARNING' \
--msgbox 'ERROR: value can not by empty!!!' \
0 0;exit; }
IFACE_OUT=$( dialog --stdout --inputbox 'Type your WAN Iface'    0 0 )
[ "$IFACE_OUT" ] ||
{ dialog \
--title 'WARNING' \
--msgbox 'ERROR: value can not by empty!!!' \
0 0;exit; }

echo $ON_OFF_FORWARDING > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i $IFACE_IN -o $IFACE_OUT -j ACCEPT
iptables -A FORWARD -i $IFACE_OUT -o $IFACE_IN -m state --state ESTABLISHED,RELATED \
         -j ACCEPT

[ "$?" = "0" ] && dialog \
--title 'SUCCESS' \
--msgbox 'OK: Internet Shared!!!' \
0 0 || dialog \
--title 'FAIL' \
--msgbox 'ERROR: Internet not Shared. Please verify all proccess again!!!' \
0 0 
fi
clear
reset 


