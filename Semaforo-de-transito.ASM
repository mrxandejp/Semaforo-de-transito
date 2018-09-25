;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		CONT		;UMA VARIÁVEL AUXILIAR, PARA CONTAGENS 
		DISPLAY		;VARIAVEL USADA PARA RECEBER OS BITS DO SINAL
		DISPLAY_AUX	;VARIAVEL PARA CONVERTER OS BITS DO SINAL DE ENTRADA
				;PARA OS BITS EQUIVALENTE AO SEU NÚMERO, POR EXEMPLO
				;A TECLA 1 EQUIVALE AOS BITS 0000000 DO SINAL
				;MAS SEU NUMERO EM BINÁRIO É 0000001
		
		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAIDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000011'	;DEFININDO O TEMPO EM 1:16
	MOVWF	OPTION_REG	;DEFINE OPCOES DE OPERACAO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPCOES DE INTERRUPCOES
	CALL 0X3FF
	MOVWF OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL.
	
	;UTILIZO AS PORTAS GP0,GP1,GP2,GP3,GP4 E GP5
	;GP0, GP1, GP2 E GP4 SERVEM PARA SETAR O DISPLAY
	;GP3 É MINHA ENTRADA DO SINAL
	;GP5 É UTILIZADO PARA SET O LED
	BTFSC	GPIO,GP3    ;FICO CONFERINDO SE CHEGOU ALGUM SINAL NA ENTRADA
	GOTO	MAIN	    ;SE NÃO CHEGOU NADA FICO NESSE LOOP SEMPRE CONFERINDO
	MOVLW	.107	    ;SE ENTROU SET O TMR0 PARA INICIAR EM 107, POIS SE 
	MOVWF	TMR0	    ;ESTOUROU O TEMPO, QUER DIZER QUE CHEGOU UM START BIT
	BCF	INTCON, T0IF	;LIMPO O T0IF
START_BIT	
	BTFSS	GPIO,GP3    ;FICO CONFERINDO SE O SINAL ACABOU
	GOTO	START_BIT   ;SE NÃO ACABOU, FICARÁ NESSE LOOP ATÉ ACABAR
	BTFSS	INTCON,T0IF ;SE ACABOU, VEJO SE O TEMPO ESTOUROU, SE NÃO ESTOUROU
	GOTO	MAIN	    ;É PORQUE NÃO CHEGOU UM START BIT
	MOVLW	.6	    ;SE CHEGOU UM STARTBIT, UTILIZO O CONT COMO AUXILIAR
	MOVWF	CONT	    ;PARA LIMITAR OS BITS QUE VOU ARMAZENAR 
LOOP_1	
	BTFSC	GPIO,GP3    ;FICO CONFERINDO O SINAL ATÉ O SINAL CHEGAR
	GOTO	LOOP_1
	MOVLW	.181	    ;SE O SINAL CHEGOU, SET O TEMPO EM 181
	MOVWF	TMR0	    ;PARA VER SE O BIT É 0 OU 1
	BCF	INTCON,T0IF ;LIMPO O T0IF
TECLA_BIT	
	BTFSS	GPIO,GP3    ;CONFIRO ATÉ O SINAL ACABAR
	GOTO	TECLA_BIT
	MOVLW	.219	    ;SE ELE ACABAR, EU FAÇO UMA COMPARAÇÃO PARA VER
	SUBWF	TMR0	    ;SE O TEMPO FOI DE 600 OU 1200
	BTFSS	STATUS,C
	GOTO	BIT_0	    ;SE O SINAL FOR DE 600 SET O BIT EM 0
	GOTO    BIT_1	    ;SE O SINAL FOR DE 1200 SET O BIT EM 1
BIT_0
	BCF	DISPLAY,6   ;SET O BIT MAIS SIGNFICATIVO, E ROTACIONO PARA
	RRF	DISPLAY	    ;ELE IR ATÉ O MENOS SIGNIFICATIVO 
	GOTO	FORA
BIT_1
	BSF	DISPLAY,6   ;UTILIZO A MESMA ESTRATÉGIA PARA O BIT 1
	RRF	DISPLAY
	GOTO	FORA
FORA
	DECF	CONT,F	    ;CONFIRO SE JA PREENCHI TODOS OS BITS
	BTFSS	STATUS,Z    ;SE NÃO, EU VOLTO PARA O LOOP_1 PARA COMPLETAR OS BITS
	GOTO	LOOP_1
	MOVFW	DISPLAY	    ;SE SIM, CONFIRO SE RECEBI UMA TECLA MENOR QUE 10
	MOVWF	DISPLAY_AUX ;SE SIM, EU COLOCO NO DISPLAY QUAL FOI A TECLA
	MOVLW	.10	    ;QUE FOI PRESSIONADA
	SUBWF	DISPLAY_AUX ;SE NÃO, EU COLOCO O LED PARA ACENDER POR 100ms
	BTFSS	STATUS,C
	GOTO	SET_DISPLAY_1
	BSF	GPIO,GP0    ;APAGO O DISPLAY SET AS SAIDAS EM 1
	BSF	GPIO,GP1    
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	MOVLW	.25
	MOVWF	CONT
	BSF	GPIO,GP5    ;LIGO O LED, FICO CONFERINDO SE ELE ATINGIU O TEMPO
LED			    ;UTILIZANDO UM CONTADOR DE 25, POIS DO JEITO QUE SETEI
	MOVLW	.6	    ;O TMR0 ELE NÃO PASSARÁ DE 4ms, 
	MOVWF	TMR0
	BCF	INTCON,T0IF
LOOP_2	
	BTFSS	INTCON,T0IF
	GOTO	LOOP_2	    
	DECF	CONT,F	    ;QUANDO O CONT CHEGAR A 0, É PQ ATINGIU O TEMPO 
	BTFSS	STATUS,Z    ;E POSSO DESLIGAR O LED
	GOTO	LED
	BCF	GPIO,GP5    ;DESLIGO O LED APÓS 100ms
	GOTO	MAIN	
SET_DISPLAY_1	
	MOVFW	DISPLAY	    
	MOVWF	DISPLAY_AUX ;CONFIRO SE O SINAL QUE CHEGOU FOI 0001001
	MOVLW	.9	    ;POIS ESSE SINAL EQUIVALE A TECLA 0
	SUBWF	DISPLAY_AUX ;SE FOR ISSO QUE CHEGOU, EU SET AS SAIDAS EM 0000
	BTFSS	STATUS,Z    ;PARA O DISPLAY MOSTRAR O NUMERO 0
	GOTO	SET_DISPLAY_2	;SE NÃO FOI ESSE SINAL, EU VOU PARA O SET_DISPLAY_2
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	GOTO	MAIN	    ;VOLTO PARA O INICIO
SET_DISPLAY_2
	MOVLW	.1	    ;SOMO O SINAL COM 1, PARA COLOCAR NO DISPLAY O VALOR 
	ADDWF	DISPLAY,F   ;CERTO DA TECLA
	BTFSS	DISPLAY,0   ;CONFIRO O BIT NA POSIÇÃO 0, SE FOR 1 EU SETA O GP0 
	GOTO	CLEARGP0	   ;SE FOR 0, DOU UM CLEAR NO GP0
	GOTO	SETGP0	   ;E ESSA REGRA SERVE PARA OS BITS SEGUNITES
BIT1
	BTFSS	DISPLAY,1
	GOTO	CLEARGP1
	GOTO	SETGP1
BIT2
	BTFSS	DISPLAY,2
	GOTO	CLEARGP2
	GOTO	SETGP2
BIT3
	BTFSS	DISPLAY,3
	GOTO	CLEARGP4
	GOTO	SETGP4
	
;NESSA PARTE SET OU CLEAR OS GPIO, FORMANDO A SAIDA EQUIVALENTE AO NUMERO	
;SE O AUXILIAR ESTIVER 1001, AS SAIDAS GP0=1 GP1=0 GP2=0 GP4=1
SETGP0
	BSF	GPIO,GP0 
	GOTO	BIT1
CLEARGP0	
	BCF	GPIO,GP0
	GOTO	BIT1
SETGP1	
	BSF	GPIO,GP1
	GOTO	BIT2
CLEARGP1	
	BCF	GPIO,GP1
	GOTO	BIT2
SETGP2
	BSF	GPIO,GP2
	GOTO	BIT3
CLEARGP2
	BCF	GPIO,GP2
	GOTO	BIT3
SETGP4
	BSF	GPIO,GP4
	GOTO	MAIN 
CLEARGP4	
	BCF	GPIO,GP4
	GOTO	MAIN
	
	
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
