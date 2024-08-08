#!/bin/sh
Number=$( dialog --stdout --inputbox 'Insira o Nº de DNS Servers:'    0 0 )
echo "# DNS gravado por DNS_Config - By dioxfile Unemat Barra do Bugres." > /etc/resolv.conf

for i in $(seq 1 $Number);
do
DNS=$( dialog --stdout --inputbox "Insira o DNS '$i':"    0 0 )
echo nameserver $DNS >> /etc/resolv.conf
done;
echo "#                      Fim do Arquivo resolv.conf" >> /etc/resolv.conf
dialog \
--title 'AVISO' \
--msgbox 'Verifique se Está tudo Certo com o DNS e Seja Feliz...' \
6 40
dialog \
--title 'Conteúdo do Arquivo resolv.conf'  \
--textbox /etc/resolv.conf \
0 0
#/etc/init.d/Firewall restart
dig
reset
