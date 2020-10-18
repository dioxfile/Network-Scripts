@echo off
choice /C FAC /M "Pressione: [F]ixo, [A]utomatico ou [C]ancelar"
IF errorlevel=3 goto FIM
IF errorlevel=2 goto AUTOMATICO
IF errorlevel=1 goto FIXO

:FIXO
set /p INTERFACE=Nome da Interface--^>
set /p IP=Ip--^>
set /p MASCARA=Masc--^> 
set /p GATEWAY=Gw--^>
set /p DNS=Dns--^>
netsh int ip set address name="%INTERFACE%" source=static %IP% %MASCARA% %GATEWAY% 1
netsh int ip set dns name="%INTERFACE%" static %DNS% 
goto :FIM

:AUTOMATICO 
netsh int ip delete dns name="%INTERFACE%" all
netsh int ip set address name="%INTERFACE%" source=dhcp
netsh int ip set dns name="%INTERFACE%" dhcp
goto :FIM

:FIM
@echo Finished
ipconfig

