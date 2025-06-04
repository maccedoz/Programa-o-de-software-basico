.nolist
.include "../m328Pdef.inc"
.list

; Definições de registradores
.def index = r24        ; Unidade (0-9)
.def index2 = r23       ; Dezena (0-9)
.def aux = r22          ; Auxiliar

.org 0x0000
	rjmp main

; Tabela de segmentos (sem PB7)
table:
	.db 0b00111111 ; 0
	.db 0b00000110 ; 1
	.db 0b01011011 ; 2
	.db 0b01001111 ; 3
	.db 0b01100110 ; 4
	.db 0b01101101 ; 5
	.db 0b01111101 ; 6
	.db 0b00000111 ; 7
	.db 0b01111111 ; 8
	.db 0b01101111 ; 9

main:
	; Configura PB0-PB6 como saída (segmentos)
	; PB7 será usado para seleção da casa (dezena/unidade)
	ldi aux, 0xFF
	out DDRB, aux

	ldi index, 0
	ldi index2, 0

loop:
	; Exibe unidade (PB7 desligado)
	cbi PORTB, 7              ; Desliga PB7 (seleciona unidade)
	rcall display_digit_unidade
	rcall delay_5ms

	; Exibe dezena (PB7 ligado)
	rcall display_digit_dezena
	rcall delay_5ms

	; Incrementa contador
	rcall incrementa_contador

	rjmp loop

; --- Rotinas de exibição ---
display_digit_unidade:
	ldi ZH, high(table*2)
	ldi ZL, low(table*2)
	add ZL, index
	adc ZH, r1
	lpm aux, Z
	out PORTB, aux
	ret

display_digit_dezena:
	ldi ZH, high(table*2)
	ldi ZL, low(table*2)
	add ZL, index2
	adc ZH, r1
	lpm aux, Z
	neg aux
	out PORTB, aux
	sbi PORTB, 7              ; Liga PB7 (seleciona dezena)
	ret

; --- Incrementa contador (0-99) ---
incrementa_contador:
	inc index
	cpi index, 10
	brlo fim_incrementa
	ldi index, 0
	inc index2
	cpi index2, 10
	brlo fim_incrementa
	ldi index2, 0
fim_incrementa:
	ret

; --- Delay 5ms aproximado ---
delay_5ms:
	ldi r20, 5
delay_outer:
	ldi r19, 80
delay_middle:
	ldi r18, 255
delay_inner:
	dec r18
	brne delay_inner
	dec r19
	brne delay_middle
	dec r20
	brne delay_outer
	ret
oq está errado
