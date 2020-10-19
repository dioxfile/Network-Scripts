@echo off
choice /C FAC /M "Pressione: [F]ixo, [A]utomatico ou [C]ancelar"
IF errorlevel=3 goto FIM
IF errorlevel=2 goto AUTOMATICO
IF errorlevel=1 goto FIXO

:FIXO
set /p INTERFACE=Nome da Interface--^>
set /p IP=Ipv6--^>
set /p GATEWAY=Gw (Ex. FD00::/7)--^>
set /p DNS=Dns--^>
set /p DNS2=Dns2--^>
 netsh interface ipv6 add address interface="%INTERFACE%" address=%IP%
 netsh interface ipv6 add dnsserver "%INTERFACE%" %DNS% 
 netsh interface ipv6 add dnsserver "%INTERFACE%" %DNS2% index=2
 netsh interface ipv6 add route %IP% interface="%INTERFACE%" %GATEWAY% publish=yes
goto :FIM
 
:AUTOMATICO
FOR /F "tokens=3,*" %%A IN ('netsh interface ipv6 show interface^|find "Connected"') DO (set INTERFACE=%%B)
netsh interface ipv6 delete address interface="%INTERFACE%"
ipconfig /release6 
ipconfig /renew6
netsh interface ipv6 delete dnsserver "%INTERFACE%" all
netsh interface ipv6 set int interface="%INTERFACE%" advertise=enable managed=enable
goto :FIM

:FIM
@echo Finished
ipconfig
