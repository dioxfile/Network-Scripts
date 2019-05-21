#!/bin/bash
dialog \
--title 'MAC ADDRESS TEST' \
--msgbox 'Insert Your MAC ADDRESS.' \
0 0
###############Insere MAC
MAC=$( dialog --stdout --inputbox 'Insert your MAC ADDRESS in the following format (aabbccddeeff):'    0 0 )
echo $MAC
if [[ $MAC =~ ^[0-9A-Fa-f]{12}$ ]]
then
dialog \
--msgbox 'Valid MAC.' \
0 0
else
dialog \
--msgbox 'Invalid MAC.' \
0 0
exit 1
fi
MAC=$(echo $MAC | sed -e 's!\.!!g;s!\(..\)!\1:!g;s!:$!!' -e 'y/abcdef/ABCDEF/')
dialog \
--title 'MAC ADDRESS'  \
--msgbox $MAC \
0 0
