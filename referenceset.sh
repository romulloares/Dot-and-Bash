########### Pedido do cliente

Preciso pegar usuários acessando sistemas a partir de computador que não seja o dele,
exemplo eu ia na maquina do caique e colocar minha senha pra acessar algum sistema, com o caique logado la

########### Teste - Criando arquivo de amostra

<13>Feb 13 11:48:24 MCANDC11V AgentDevice=WindowsLog	AgentLogFile=Security	PluginVersion=7.2.9.72	
|Source=Microsoft-Windows-Security-Auditing	Computer=MCANDC11V.cliente.su.net	OriginatingComputer=10.217.62.252	
User=	Domain=	EventID=4776	EventIDCode=4776	EventType=8	EventCategory=14336	RecordNumber=43390751	TimeGenerated=1581601701	
TimeWritten=1581601701	Level=Log Always	Keywords=Audit Success	Task=SE_ADT_ACCOUNTLOGON_CREDENTIALVALIDATION	
Opcode=Info	Message=The computer attempted to validate the credentials for an account.  Authentication Package: MICROSOFT_AUTHENTICATION_PACKAGE_V1_0 
Logon Account: ui74821a Source Workstation:  Error Code: 0x0

Arquivo na máquina 61 caminho /root/cliente

Enviando para máquina 63

/opt/qradar/bin/logrun.pl -d 172.16.1.63 -p 514 -f amostra.log -u 20.20.20.20 -v 1


########### Campos utilizados para a Regra
    	
; Event Name ; Nome_do_Usuario (custom) ; computerName (custom)


########### Criando Reference table - Geral
	/opt/qradar/bin/ReferenceDataUtil.sh  create  cliente_usuario_por_maquina2 MAP ALN

########### Conteudo Inicial load.txt
key1,data
ui74821a,MCANDC5V.cliente.com.br

########### Fazendo Load inicial dos dados
	/opt/qradar/bin/ReferenceDataUtil.sh load cliente_usuario_por_maquina2 `pwd`/load.txt

########### Validando import
	/opt/qradar/bin/ReferenceDataUtil.sh list cliente_usuario_por_maquina2 displayContents

##################################################################
########### Test AQL
##################################################################
#### Compare se é igual
	SELECT 
		"Nome_do_Usuario"											  	AS 'Username',
		"computerName" 													AS 'Maquina usada para Login', 
		REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario")	AS 'Maquina permitida para esse usuario' 
	FROM	
		events
	WHERE
		REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario") IS NOT NULL AND
		REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario") = "computerName" 
	LAST 
		10 MINUTES
	
#### Compare os diferente

SELECT 
	"Nome_do_Usuario"											  	AS 'Username',
	"computerName" 													AS 'Maquina usada para Login', 
	REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario")	AS 'Maquina permitida para esse usuario' 
FROM	
	events
WHERE
	REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario") IS NOT NULL AND
	REFERENCEMAP('cliente_usuario_por_maquina2',"Nome_do_Usuario") != "computerName" 
LAST 
	10 MINUTES
