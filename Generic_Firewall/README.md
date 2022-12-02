
# Generic Firewall
![image](https://github.com/dioxfile/Network-Scripts/raw/master/Generic_Firewall/frame.png = 250x250)
# This script does the following:
## 1 - Shares the Internet with a single network interface;<br/>
## 2 - Makes secure access to SSH through knocking on the door;<br/>
## 3 - Use ToS;<br/>
## 4 - Automatically capture the network card, netmask, and network. After that apply these settings to Firewall, etc.<br/>

## Firewal script too blocks DoS by pinging (death ping).

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
    a) DEATH PING Detection:<br/>
    `Aug 13 16:48:41 diogenes-inspiron kernel:`<br/>
    `[11517.279744] WARNING DEATH PING ATTACK!!!:IN=wlan0`<br/>
    `OUT= MAC=b0:10:41:fe:2d:2b:64:1c:67:f8:be:58:08:00`<br/>
    `SRC=113.167.9.40 DST=113.167.9.21 LEN=84 TOS=0x00`<br/> 
    `PREC=0x00 TTL=64 ID=12546 DF PROTO=ICMP TYPE=8`<br/> 
    `CODE=0 ID=7488 SEQ=7`
