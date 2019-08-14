# Firewalln
![all text](https://github.com/dioxfile/Network-Scripts/raw/master/DNS_Config/DNS_Config.png)

Firewal script that blocks and detects portscan and DoS by pinging (death ping).



# What do you need to use this software?
- You will need <br/>


# How to use it?
- 1 - insert this line: '*.=info  -/var/log/iptables.log' in /etc/rsyslog.d/50-default.conf<br/>
- 2 - restart rsyslog: /etc/init.d/rsyslog<br/>
- 3 - run firewall: sudo ./Firewall<br/>
- 4 - verify log: tail -f /var/log/iptables.log<br/>


If you have a return as:<br/>
`$ Unknown command dialog`<br/>
So you do not have the program installed<br/>

To install it on Debian-based distributions simply use the command:<br/>
`$sudo apt install dialog`<br/>

To install it on Arch-based distributions simply use the command:<br/>
`sudo pacman -S dialog`<br/>

To install it on Red Hat-based distributions simply use the command:<br/>
`sudo dnf install dialog`<br/>

Execution permission to DNS_Config with the command<br/>
`$sudo chmod +x DNS_Config.sh`<br/>

After that you just run the program:<br/>
`./DNS_config.sh`

