# IPV4 Configuration
![all text](https://github.com/dioxfile/Network-Scripts/raw/master/DNS_Config/DNS_Config.png)

This code aims to quickly and easily configure IPV4.

It uses the 'dialog' program to have a more user friendly interface, making it easier to use and thus reducing the chances of errors.

This script is adapted for networks that use net-toos packages.

# What do you need to use this software?
- You will need the 'dialog' program installed on your machine.<br/>
Dialog is a program used to design user-friendly interfaces, with buttons and menus, from a Shell Script.<br/>

- You will need the 'net-tools' program installed on your machine.<br/>

# How to use it?
You should first check if you have the dialog installed.<br/>
Call the program by its terminal like command:<br/>
`$dialog`<br/>

If you have a return as:<br/>
`$ Unknown command dialog`<br/>
So you do not have the program installed<br/>

To install it on Debian-based distributions simply use the command:<br/>
`$sudo apt install dialog`<br/>
Net-tools<br/>
`$sudo apt install net-tools`<br/>

To install it on Arch-based distributions simply use the command:<br/>
`$sudo pacman -S dialog`<br/>
Net-tools<br/>
`$sudo pacman -S net-tools`<br/>

To install it on Red Hat-based distributions simply use the command:<br/>
`$sudo dnf install dialog`<br/>
Net-tools<br/>
`$sudo dnf install net-tools`<br/>


Execution permission to DNS_Config with the command<br/>
`$sudo chmod +x rede_ipv4.sh`<br/>

After that you just run the program:<br/>
`./rede_ipv4.sh`


