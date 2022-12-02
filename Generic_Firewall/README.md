
# Generic Firewall
![all text](https://github.com/dioxfile/Network-Scripts/raw/master/FIREWALL/Firewall.png)
# This script does the following:
## 1 - Shares the Internet with a single network interface;<br/>
## 2 - Makes secure access to SSH through knocking on the door;<br/>
## 3 - Use ToS;<br/>
## 4 - Automatically capture the network card, netmask, and network. 
## After that apply these settings to Firewall, etc.<br/>

## Firewal script that blocks and detects portscan and DoS by pinging (death ping).

# EXAMPLE OF USE:
# What do you need to use this software?
- You will need <br/>
 IPTables;<br/>
 Net-tools.

# How to use it?
- 1 - insert this line (without the quotes):<br/>
`'*.=info  -/var/log/iptables.log'` in /etc/rsyslog.d/50-default.conf<br/>
- 2 - restart rsyslog:<br/>
`$sudo service rsyslog restart` <br/>
- 3 - run firewall:<br/>
`$sudo ./Firewall`<br/>
- 4 - verify log:<br/>
`$tail -f /var/log/iptables.log`<br/>
- 5 - log line example:<br/>
    a) PortScan Detection:<br/>
    `Aug 13 16:49:13 diogenes-inspiron kernel:`<br/>
    `[11549.184256] WARNING PORTSCAN ATTACK!!!:IN=wlan0`<br/>
    `OUT= MAC=b0:10:41:fe:2d:2b:08:00:27:b5:8d:f4:08:00` <br/>
    `SRC=104.105.212.60 DST=113.167.9.21 LEN=40 TOS=0x00`<br/>
    `PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=443 DPT=59152`<br/>
    `WINDOW=0 RES=0x00 RST URGP=0` <br/><br/>
    
    b)DEATH PING Detection:<br/>
    `Aug 13 16:48:41 diogenes-inspiron kernel:`<br/>
    `[11517.279744] WARNING DEATH PING ATTACK!!!:IN=wlan0`<br/>
    `OUT= MAC=b0:10:41:fe:2d:2b:64:1c:67:f8:be:58:08:00`<br/>
    `SRC=113.167.9.40 DST=113.167.9.21 LEN=84 TOS=0x00`<br/> 
    `PREC=0x00 TTL=64 ID=12546 DF PROTO=ICMP TYPE=8`<br/> 
    `CODE=0 ID=7488 SEQ=7`
