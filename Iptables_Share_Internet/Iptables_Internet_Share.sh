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

if [ "$ON_OFF_FORWARDING" = "0" ]; then
{ dialog \
--title 'AVISO' \
--msgbox 'FIN: Operation stoped!!!' \
0 0;exit; }
fi

if [ "$ON_OFF_FORWARDING" = "1" ]; then
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

modprobe iptable_nat    # Forwarding
###Empty rules
iptables -F         &&
iptables -F INPUT   &&
iptables -F OUTPUT  &&
iptables -F FORWARD &&
echo "Cleanning Rules "
             
#Changing Policies - first block everything and 
#then release only what is needed.
iptables -P INPUT DROP      &&
iptables -P FORWARD ACCEPT  &&
iptables -P OUTPUT ACCEPT   &&
echo "Policies Default"

#Loopback local process
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -i $IFACE_IN -j ACCEPT

echo $ON_OFF_FORWARDING > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o $IFACE_OUT -j MASQUERADE
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

iptables -L -n |egrep "FORWARD"

else
{ dialog \
--title 'WARNING' \
--msgbox 'ERROR: value must be '1' or '0'!!! ' \
0 0;exit; }
fi



