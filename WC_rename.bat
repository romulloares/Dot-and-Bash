@echo off

echo Parando servico WinCollect

sc stop wincollect

echo renomeando certificado

del c:\IBM\wincollect\config\ConfigurationServer.PEM

echo criando backupconfig 

copy c:\IBM\wincollect\config\install_config.txt c:\IBM\wincollect\config\install_config.bpk.txt

echo editando backupconfig 
C:\Users\LEADCOMM\Desktop\19_12_2019\sed-4.7-x64.exe sed -i 's/172.16.1.61/172.16.1.224/' c:\IBM\wincollect\config\install_config.txt
sed '1s/^/_new/' arquivo.txt

echo gerando token
C:\IBM\WinCollect\bin\InstallHelper.exe -T 02470f53-493f-467e-aa28-02228fca2c77 

echo comparando tokens
type c:\IBM\wincollect\config\install_config.txt c:\IBM\wincollect\config\install_config.bpk.txt

explorer c:\IBM\wincollect\config\

sc start wincollect