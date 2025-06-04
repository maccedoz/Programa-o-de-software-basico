.nolist
.include "../m328Pdef.inc"
.list

.def index = r24
.def aux = r22
.def index2 = r20

.org 0x0000
	rjmp main
	
table:
	.db 0b0111111
	.db 0b00000110
	.db 0b1011011
	.db 0b1001111
	.db 0b1100110
	.db 0b1101101
	.db 0b1111101
	.db 0b0000111
	.db 0b1111111

main:
	; Configura PB0-PB7 como saída
	ldi aux, 0xFF
	out DDRB, aux
	ldi index2, 0
    ldi index, 0
	rjmp display1  ; começa em display1, ajustei para seguir o fluxo

display1:
    ; Configura Z para apontar para o início da tabela
    ldi ZH, high(table*2)  
    ldi ZL, low(table*2)
    add ZL, index         
    adc ZH, r1           

    ; Lê padrão da tabela
    lpm aux, Z
    out PORTB, aux
	rcall delay_500ms
	inc index
	cpi index, 9
	brlo display1   ; se index < 9, continua display1
	rjmp display2   ; senão, vai para display2

display2:
	sbi PORTB, 7    ; liga PB7
	ldi ZH, high(table*2)  
    ldi ZL, low(table*2)
    add ZL, index2       
    adc ZH, r1           

    ; Lê padrão da tabela
    lpm aux, Z
    out PORTB, aux
	rcall delay_500ms
	inc index2
	cbi PORTB, 7    ; desliga PB7
	ldi index, 0
	cpi index2, 9
	brlo display1   ; se index2 < 9, volta pro display1
	rjmp zerar

zerar:
	ldi index2, 0
	rjmp display1

delay_500ms:
	ldi		r20, 64
delay2:
	ldi		r19, 128
delay1:
	ldi		r18, 255
delay0:
	dec		r18
	brne	delay0
	dec		r19
	brne	delay1
	dec		r20
	brne	delay2
	ret
