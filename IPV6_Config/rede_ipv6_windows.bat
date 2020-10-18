@echo off
choice /C FAC /M "Pressione: [F]ixo, [A]utomatico ou [C]ancelar"
IF errorlevel=3 goto FIM
IF errorlevel=2 goto AUTOMATICO
IF errorlevel=1 goto FIXO

:FIXO
set /p INTERFACE=Nome da Interface--^>
set /p IP=Ipv6--^>
set /p GATEWAY=Gw--(Ex. FD00::/7)^>
set /p DNS=Dns--^>
set /p DNS2=Dns2--^>
 netsh interface ipv6 add address interface="%INTERFACE%" address=%IP%
 netsh interface ipv6 add dnsserver "%INTERFACE%" %DNS% 
 netsh interface ipv6 add dnsserver "%INTERFACE%" %DNS2% index=2
 netsh interface ipv6 add route %IP% interface="%INTERFACE%" %GATEWAY% publish=yes
goto :FIM

 
:AUTOMATICO 
ipconfig /renew6
ipconfig /release6
netsh interface ipv6 delete dnsserver "Rede" all
netsh interface ipv6 set int interface="Rede" advertise=enable managed=enabled
goto :FIM

:FIM
@echo Finished
ipconfig
netsh interface ipv6 show dns "Rede"
netsh interface ipv6 show address "Rede"



