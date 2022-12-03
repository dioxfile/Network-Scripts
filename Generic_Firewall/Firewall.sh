#!/bin/bash

### BEGIN INIT INFO
# Provides:          Firewall
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Firewall at boot time
# Description:       Enable service provided by Firewall.
### END INIT INFO

##### Firewall para Rede local by Professor Esp. Diógenes Antonio Marques José UNEMAT BB ######

#				   MINI TUTORIAL IPTABLES
###############################################################################################
##                                        LEGENDAS:                                          ##
##   DROP    - Nega a passagens de Pacotes						     ##	
##   ACCEPT  - Deixa os pacotes passarem                                                     ## 
##   Regras  - comandos passados ao iptables. EX: iptables -A INPUT -s 123.123.123.1 -j DROP ##
##   Chains  - São onde as regras definidas são armazenadas para operação.                   ## 
##   Tabelas - São usadas para armazenar chains e regras com características comuns.         ##
##	*filter - INPUT, OUTPUT e FORWARD.                                                       ##
##	*nat    - PREROUTING:consultado quando um PKT deve ser modificado logo que chegar ao     ## 
##                  firewall.                                                                ## 
##	        - OUTPUT: consultado quando um PKT local precisa ser modificado antes de ser     ## 
##                  roteado;                                                                 ##
##	        - POSTROUTING: consultado quando o PKT precisa ser modificado após tratamento    ## 
##                  de roteamento;	                                                         ## 
##   	*mangle - utilizado para alterações especiais de PKT como ToS.                       ##
##	        - INPUT - Consultado quando os pacotes precisam ser modificados antes de         ##
##                  serem enviados para o chain INPUT da tabela filter.                      ##
##              - FORWARD - Consultado quando os pacotes precisam ser modificados antes de   ## 
##                  serem enviados para o chain FORWARD da tabela filter.                    ##
## 	        - PREROUTING - Consultado quando os pacotes precisam ser modificados antes       ## 
##                  de serem enviados para o chain PREROUTING da tabela nat.                 ##
##      	- POSTROUTING - Consultado quando os pacotes precisam ser modificados            ##
##                  antes de serem enviados para o chain POSTROUTING da tabela nat.          ##
##	        - OUTPUT - Consultado quando os pacotes precisam ser modificados antes de        ##
##                  serem enviados para o chain OUTPUT da tabela nat.                        ##
##                                                                                           ##
##                                                                                           ## 
##                                   OUTROS CONCEITOS                                        ##
##  * LOG - envia uma mensagem que é gravada no syslog caso a regra confira. EX:             ##
##       1: iptables -A OUTPUT -m string --string "conta" -j LOG --log-prefix "ALERTA: dados ## 
##          confidenciais ";                                                                 ##
##       2: iptables A OUTPUT -m string --string "conta" -j DROP;                            ##
##  * MASQUERADE: faz com que uma rede inteira seja vista por um único endereço IP 'NAT'     ##
##                                                                                           ##
##                                       COMANDOS:                                           ## 
## -A - Append: anexa uma ou mais regras para a chain especificada no final da lista;        ##
## -D - Delete: deleta uma ou mais regras da chain especificada;                             ##
## -I - Insert: insere uma ou mais regra na chain especificada no início da lista;           ##
## -R - Replace: substitui uma ou mais regras em uma chain;                                  ##
## -L - List: lista todas as regras da chain especificada 'iptables -t nat -n -L';           ##
## -S - List Rules: imprime todas as regras da chain selecionada 'iptables -S;               ##
## -F - Flush: deleta todas as regras uma por uma;                                           ##
## -P - Policy: seta uma politica para chain para um dado alvo. O adrão é ACCEPT             ##
##                                                                                           ##
##                                       PARÂMETROS:                                         ## 
## -t - indica o tipo de tabela a ser usada (filter, nat ou mangle).                         ##
## -p - protocolos - -p udp,tcp,icmp;                                                        ##
## -s - fonte especificada - -s 10.10.10.1/24;                                               ##
## -d - destino especificado - -d 11.11.11.1/28;                                             ##
## -j - jump especifica o alvo da regra. O que fazer se o PKT for compatível                 ##
## -i - especifica uma interface pelo qual um pacote foi recebido - -i $NIC,...,ethn;        ##
## -o - interface de saída pelo qual um pacote está indo para ser enviado;                   ##
## -m - compatível com uma regra ou estado.                                                  ##
##  ! - significa exclusão e é utilizado quando se deseja aplicar uma excessão a uma regra.  ##
##       EX:[]... -s ! 10.0.0.3 ...[]. Refere-se a todos os endereços possíveis com excessão ##
##       do 10.0.0.3).                                                                       ## 
##  * string:  esse módulo é extremamente útil quando precisamos realizar um controle de     ## 
##      tráfego baseado no conteúdo de um pacote. EX: iptables -A INPUT -m string --string   ## 
##      "sexo" -j DROP.                                                                      ##
##  * owner: esse módulo é capaz de determinar o criador de determinado pacote, liberar ou   ## 
##      bloquear um determinado usuario ou grupo, ou simplesmente fazer uma filtragem por    ##
##      grupo ou ##usuario. EX: iptables -A OUTPUT -m owner --uid-owner 42 -p tcp -j ACCEPT  ##
##  Diferença entre o REJECT e o DROP o REJECT descarta o pacote com pacote de erro e o DROP ##
## não.                                                                                      ##
#####################################FIM TUTORIAL##############################################
 
. /lib/lsb/init-functions

###############  Pega os parâmetros de rede ON DEMAND para sistemas com DHCP  ##################
#route add default wlan0
#route add default gw 192.168.140.2 dev wlan0
#export NIC=$(route -n | egrep "0.0.0.0" | egrep "UG" | awk '{print $8}') #Gateway
export NIC=$(route -n | egrep "0.0.0.0" | awk '{print $8}' | sort -u)     #with or without GW
#export NIC=$(route -n | egrep "UG" | awk '{print $8}')                   #No Gateway
#export EXGW=$(route -n | egrep "UG" | awk '{print $2}')                   #Get Gateway
export MASK=$(ifconfig $NIC | egrep "netmask" | awk -F"netmask" '{print $2}' | awk  'END {print $1}')
export LAN=$(route -n | egrep $MASK | cut -d " " -f1)/$MASK
#export LAN=0/0
#export MEUIP=$(ifconfig $NIC | egrep "inet end:" | cut -d " " -f12 | cut -d ":" -f2)/255.255.255.255
################################################## END ########################################
#Configuração Casa
#LAN=192.168.1.0/24
#MEUIP=193.169.29.210
#NIC=wlan0
#Configuração Trabalho
#LAN=192.168.6.0/255.255.255.0
#MEUIP=192.168.6.2

iniciar() {
# Carregando Módulos 
modprobe iptable_nat    # Redirecionamento 
modprobe ip_tables      # Permite filtrar os dados ajudando o NAT
modprobe ipt_recent     # Deixa uma porta fechada e abre se necessário (port noking)
modprobe iptable_filter # Filtro de Pacotes

###Zerando as regras
iptables -F         &&
iptables -F INPUT   &&
iptables -F OUTPUT  &&
iptables -F FORWARD &&
echo "Todas as regras LIMPAS"
             
#Mudando Políticas - primeiro bloqueia-se tudo para então liberar apenas o que é necessário.
iptables -P INPUT DROP      &&
iptables -P FORWARD ACCEPT  &&
iptables -P OUTPUT ACCEPT   &&
iptables -N ICMPSCAN        &&
echo "Policies Default"

#Habilitando o roteamento/encaminhamento
echo "1" > /proc/sys/net/ipv4/ip_forward
#Allow masquerade only if requested internet address
iptables -A POSTROUTING -s $LAN ! -d $LAN -o $NIC -j MASQUERADE
#Allow forward from localnet to internet
iptables -A FORWARD -s $LAN  ! -d $LAN  -i $NIC -j ACCEPT

#Liberacao do Loopback para processos locais
iptables -A INPUT -i lo -j ACCEPT

# Habilita conexões previamente aceitas (estados Estabelecida e Relacionada)
# Importante para não bloquear conexões já estabelecidas quando aplicar regras
iptables -A INPUT -m state --state ESTABLISHED,RELATED -i $NIC -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -o $NIC -j ACCEPT

#######-------------------Proteções contra ataques e tentativas de conexões----------###########
# Rejecting ping (ping protection from death ping)
iptables -I INPUT -p icmp -i $NIC -m icmp --icmp-type echo-request -j ICMPSCAN 
iptables -A ICMPSCAN -i $NIC -m recent --set --name badicmp --rsource
iptables -A ICMPSCAN -i $NIC -m recent --update --seconds 1 --hitcount 2 --name badicmp --rsource -j LOG --log-level 6 --log-prefix "WARNING DEATH PING ATTACK!!!:" 
iptables -A ICMPSCAN -i $NIC -m recent --update --seconds 1 --hitcount 2 --name badicmp --rsource -j DROP
iptables -A ICMPSCAN -i $NIC -m recent --update --seconds 1 --hitcount 1 --name badicmp --rsource -j ACCEPT
#Proteção contra port scanners ocultos
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

# Bloqueando ataques SYN-Floods (Ativando syn cookies)
echo 1 > /proc/sys/net/ipv4/tcp_syncookies

# IP Spoofing Bloqueia todos os IP que não provem de $NIC
#iptables -A INPUT -s $LAN ! -i $NIC -j DROP
#Bloqueia todos os IPs diferentes da LAN
#iptables -A INPUT ! -s $LAN -i $NIC -j DROP
echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter 

#iptables -A INPUT -p icmp --icmp-type echo-request -j DROP ---> não precisa
#iptables -A INPUT -p icmp --icmp-type echo-reply -j DROP ---> não precisa
           
#Impedindo echo response ICMP 8
#echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

#Essa regra permite apenas o usuario com id 42  enviar pacotes para fora do  nossa rede sob o protocolo tcp
#iptables -A OUTPUT -m owner --uid-owner 42 -p tcp -j ACCEPT

##exemplo de bloqueio por palavra
#iptables -A INPUT -m string --string "sexo" -j DROP

### Acesso SSH ultilizando a técnica Port Knocking
#Parte 1 recebea batida na porta dropa o pacote e registra a mesma
#iptables -A INPUT -p tcp --sport 1024:65535 --dport 22020 -m recent --rsource --set --name SSHBATE -j DROP
#Parte 2 confere mac da fonte
#iptables -A INPUT -p tcp --dport 22022 -m recent --rcheck --rsource --name SSHBATE -j ACCEPT
#Parte 3 fechar a porta
#iptables -A INPUT -p tcp --sport 1024:65535 --dport 22021 -m recent --remove --rsource --name SSHBATE -j DROP 
#######------------------------------------FIM---------------------------------------###########


#########################ACESSOS PERMITIDOS AOS SERVIÇOS DE REDES###############################

### Acesso SSH ultilizando a técnica Port Knocking
#Parte 1 recebea batida na porta dropa o pacote e registra a mesma
#iptables -A INPUT -p tcp --sport 1024:65535 --dport 22020 -m recent --rsource --set --name SSHBATE -j DROP
#Parte 2 confere mac da fonte
#iptables -A INPUT -p tcp --dport 22022 -m recent --rcheck --rsource --name SSHBATE -j ACCEPT
#Parte 3 fechar a porta
#iptables -A INPUT -p tcp --sport 1024:65535 --dport 22021 -m recent --remove --rsource --name SSHBATE -j DROP 

#iptables -A INPUT -p tcp --dport 30001 -m mac --mac-source 08:00:27:F5:60:91 -j LOG --log-level 1 --log-prefix "SSH TESTE Raimisson!!!"
#iptables -A INPUT -p tcp -s $LAN --dport 30001 -m mac --mac-source 08:00:27:F5:60:91 -j ACCEPT

# Liberando Serviços
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 80,443 -j ACCEPT
#iptables -A INPUT -p tcp -i $NIC --dport 36100 -j ACCEPT # Squid
iptables -A INPUT -p tcp -i $NIC -m multiport --dport 22,22022 -j  LOG --log-level 6 --log-prefix "Acessando SSH - ACCEPT:"
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 22,22022 -j ACCEPT # SSH
#iptables -A INPUT -p tcp -i $NIC  --dport 67 -j ACCEPT # DHCP Server
#iptables -A INPUT -p udp --dport 67 -j ACCEPT # DHCP Server
#iptables -A INPUT -p tcp --dport 67 -j ACCEPT # DHCP Server
#iptables -A INPUT -p tcp -i $NIC --dport 53 --dport 53 -j ACCEPT # DNS Server pacotes acima de 512
#iptables -A INPUT -p tcp -i $NIC  --dport 3306 -j ACCEPT # Mysql
#iptables -A INPUT -p udp -i $NIC --dport 53 -j ACCEPT # DNS Server
#iptables -A INPUT -p udp -i 199.10.1.50/255.255.255.255  --dport 53 -j ACCEPT # DNS Server
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 21,20,21021 -j ACCEPT # FTP
iptables -A INPUT -p udp -i $NIC -m multiport --dport 137,138 -j ACCEPT # Samba udp
iptables -A INPUT -p tcp -i $NIC -m multiport --dport 139,445 -j ACCEPT # Samba tcp
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 80,3838,1024,909,9090:9100,21355 -j ACCEPT
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 0:65535 -j ACCEPT # Jgroups
#socket_python
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 4001,9000:9100,19001 -j ACCEPT
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 4001,9000:9100,19001 -j ACCEPT
#ip6tables -A INPUT -p udp -i $NIC -m multiport --dport 6379,3838,9090:9100 -j ACCEPT # socket_python
#ip6tables -A INPUT -p tcp -i $NIC -m multiport --dport 6379,22,22022,3838,9090:9100,30040,40000 -j ACCEPT
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 30000:65535 -j ACCEPT # Jgroups
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 30000:65535 -j ACCEPT # Jgroups
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 5000:5201 -j ACCEPT # iperf TCP
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 5000:5201 -j ACCEPT # iperf UDP
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 1500:1600 -j ACCEPT # OFFICE_1 TCP
#iptables -A INPUT -p udp -i $NIC -m multiport --dport 1500:1600 -j ACCEPT # OFFICE_1 UDP
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 5000 -j ACCEPT # Samba admin
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 901 -j ACCEPT # Samba SWAT
#iptables -A INPUT -p tcp -i $NIC -m multiport --dport 10000 -j ACCEPT # Webmin

#iptables -A INPUT -p tcp --dport 1723 -j ACCEPT # VPN
##Teste GID ou UID
#iptables -A OUTPUT -m owner --gid-owner 1000 -p tcp -j ACCEPT

# Bloqueia inválidas(INVALID) CONEXÕES
iptables -A INPUT -m state --state INVALID -i $NIC -j LOG --log-level 6 --log-prefix "firewall invalid: -i"
iptables -A FORWARD -m state --state INVALID -o $NIC -j LOG --log-level 6 --log-prefix "firewall invalid -o:"
iptables -A INPUT -m state --state INVALID -i $NIC -j DROP
iptables -A FORWARD -m state --state INVALID -o $NIC -j DROP



############################ TABELA MANGLE ToS #################################################

#                                  Minimum cost
iptables -t mangle -A INPUT -i $NIC -m multiport -p tcp --dport 110,143 -j TOS --set-tos 0x01
iptables -t mangle -A PREROUTING -p tcp -m multiport --dport 110,143 -j TOS --set-tos 0x01 # POP3,IMAP

#                                  Maximum reliability
iptables -t mangle -A INPUT -i $NIC -p tcp --dport 25 -j TOS --set-tos 0x02
iptables -t mangle -A PREROUTING -p tcp --dport 25 -j TOS --set-tos 0x02 # SMTP

#                                  Maximum throughput
iptables -t mangle -A INPUT -i $NIC -m multiport -p udp --dport 137,138 -j TOS --set-tos 0x04
iptables -t mangle -A INPUT -i $NIC -m multiport -p tcp --dport 139,445 -j TOS --set-tos 0x04
iptables -t mangle -A PREROUTING -p tcp -m multiport --dport 139,445 -j TOS --set-tos 0x04 # Samba tcp
iptables -t mangle -A PREROUTING -p udp -m multiport --dport 137,138 -j TOS --set-tos 0x04 # Samba udp
iptables -t mangle -A INPUT -i $NIC -m multiport -p tcp --dport 20 -j TOS --set-tos 0x04
iptables -t mangle -A PREROUTING -p tcp -m multiport --dport 20 -j TOS --set-tos 0x04 # FTP

#                                  Minimum delay portas SSH e HTTP
iptables -t mangle -A INPUT -i $NIC -m multiport -p tcp --dport 21,80,443,22022 -j TOS --set-tos 0x08 # HTTP,HTTPS,SSH,MSN
iptables -t mangle -A PREROUTING -p tcp -m multiport --dport 21,22022,80,443 -j TOS --set-tos 0x08 # SSH, HTTP, HTTPS 

## NAT ##
# Redirecionamento de porta para o servidor proxy
#iptables -t nat -A PREROUTING -s $LAN -p tcp -i $NIC --dport 3306 -j REDIRECT --to-port 3307

#Ajustando a MTU da rede para conexão ADSL ----> IMPORTANTE
#iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1400:1536 -l TCPMSS --clamp-mss-to-pmtu
#iptables -A INPUT -p icmp --icmp-type echo-request -j LOG --log-level 1 --log-prefix "Tentativa de ping da MORTE "

##Loga pacotes suspeitos ou corrompidos
#iptables -A FORWARD -m unclean -j LOG --log-level 1 --log-prefix "Pacotes suspeitos UNCLEAN "
#bloqueia pacotes suspeitos ou danificados
#iptables -A FORWARD -m unclean -j DROP

#Loga tentativas de sincronização de novas conexões TCP externas
iptables -A FORWARD -p tcp ! --syn -m state --state NEW -j LOG --log-level 6 --log-prefix "firewall new syn:" 
#Bloqueando requisiçõees de conexões externas. Bloqueia tudo exceto o que foi especificado.
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
}

parar(){
# Limpando as tabelas
iptables -F
iptables -X
iptables -F -t nat
iptables -X -t nat
iptables -F -t mangle
iptables -X -t mangle
echo 0 > /proc/sys/net/ipv4/ip_forward
}

# $? código de retorno do ultimo comando executado
case "$1" in

        "start") 
                if iniciar exit 0; then 
		log_action_begin_msg "Ativando Firewall"
                log_action_end_msg $?
	else
                log_action_end_msg $? 
        fi
	;;

       	"stop") 
		if parar exit 0; then
		log_action_begin_msg "Desativando Firewall"
		log_action_end_msg $?
	else
		log_action_end_msg $? 
	fi
	;;

        "restart")
		if parar exit 0; then
		log_action_begin_msg "Desativando Firewall"
		log_action_end_msg $?
	else
		log_action_end_msg $?
	fi

		if iniciar exit 0; then
		log_action_begin_msg "Ativando Firewall"
		log_action_end_msg $?
	else
		log_action_end_msg $?
	fi
	;;

	*) echo "Use os parâmetros start, stop ou restart."
esac
