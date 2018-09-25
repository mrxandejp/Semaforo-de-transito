# Semáforo de trânsito

## Objetivo: 
Exercício de aplicação da linguagem Assembly.

## Contexto: 
Um aplicativo em Assembly (PIC12F675) para controlar o semáforo de um cruzamento
simples de rua: fecha para um lado e abre para o outro, utilizando 1 dígito BCD e 1 porta: LED.

## Especificações:
* Utilizado dois LEDs (verde e vermelho) aplicados a uma única porta para funcionar em oposição, segundo
a notação:
  * quando a porta é HIGH → LED1 é ON e LED2 é OFF;
  * quando a porta é LOW → LED1 é OFF e LED2 é ON;
* Para transição de estado (verde → vermelho ou vermelho → verde), ocorrerá após uma contagem
decrescente, de 9 até 0;
* A contagem deve ser indicada em um display de 7 segmentos, no kit de bancada;
* Por se tratar de um semáforo didático, cada transição da contagem (indicada no display) deve ocorrer a
cada 300 ms.
