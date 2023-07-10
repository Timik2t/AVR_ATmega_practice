.include "m8515def.inc"

.def temp1 = R17
.def temp2 = R18
.def counter5 = R27
.def counter1 = R20
.def counter2 = R21
.def data = R22
.def counter3 = R23
.def data1 = R24
.def counter4 = R25
.def data2 = R26


; Основная программа
main:
	cli

	; Настройка порта B
	ldi temp1, $1D
	out DDRB, temp1

	; Настройка порта C
	ldi temp1, $FF
	out DDRC, temp1

	; Настройка стека
	ldi r30, low(RAMEND)
	out SPL, r30
	ldi r30, high(RAMEND)
	out SPH, r30

	; Установка флага вращения вправо
	sbi PORTB, 4

	; Правое вращение
rotate_right:
	clr data2
	sbi PORTB, 3

main_loop:
	clr data1
	ldi counter3, $10

Acprun:
	; Включение линии ACPR
	sbi PORTB, 0
	rcall delay
	cbi PORTB, 0
	nop
	ldi counter1, $08

sclckrun:
	; Генерация тактового сигнала
	sbi PORTB, 2
	rcall write
	cbi PORTB, 2
	dec counter1
	brne sclckrun
	nop
	rjmp middle

write:
	; Запись данных
	sbic PINB, 1
	inc data
	lsl data
	ret

middle:
	dec counter3
	add data1, data
	cpi counter3, $00
	breq comparison
	rcall delay5
	rjmp Acprun

comparison:
	; Сравнение значений
	lsr data1
	rol temp2
	lsr data1
	rol temp2
	lsr data1
	rol temp2
	lsr data1
	cp temp2, data2
	brlo led1
	mov data2, data1
	rjmp main_loop

led1:
	; Вывод значения на порт C
	out PORTC, data1
	cbi PORTB, 3
	rcall delay2

; Левое вращение
rotate_left:
	out PORTC, data2
	cbi PORTB, 4
	cp data1, data2
	breq stop1
	rjmp main_loop

delay:
	; Задержка
	ldi counter2, $03
delay1:
	dec counter2
	brne delay1
	ret

delay5:
	; Большая задержка
	ldi counter2, $FF
delay7:
	ldi counter1, $02
delay8:
	dec counter1
	brne delay8
	dec counter2
	brne delay7
	ret

delay2:
	; Малая задержка
	ldi counter2, $FF
delay3:
	ldi counter1, $A0
delay4:
	dec counter1
	brne delay4
	dec counter2
	brne delay3
	ret

stop1:
	; Остановка вращения
	sbi PORTB, 4
	rcall delay2
	rcall delay2
	rcall delay2
	rjmp rotate_right




