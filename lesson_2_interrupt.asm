.include "m8515def.inc"

.def current_value = r16
.def temp1 = r17
.def temp3 = r27
.def interrupt_counter = r18
.def interrupt_counter1 = r23
.def interrupt_counter2 = r24
.def interrupt_counter3 = r29

; Переход к основной программе
rjmp main

; Обработчик прерывания
interrupt_handler:
  inc interrupt_counter
  rjmp data

.org $06
  ; Увеличение счетчика прерывания
  inc interrupt_counter3
  cpi interrupt_counter1, $01
  brsh blinking
  rjmp interrupt_handler

data:
  ; Установка бита 7
  bset 7

  cpi interrupt_counter, $01
  breq number

  cpi interrupt_counter, $04
  brlo comparison

  cpi input_number2, $01
  breq stop

  cpi input_number2, $01
  brne blinking

  rjmp interrupt_handler

main:
  ; Настройка стека
  ldi r30, low(RAMEND)
  out SPL, r30
  ldi r30, high(RAMEND)
  out SPH, r30

  ; Настройка таймера
  ldi temp, $80
  out timsk, temp
  ldi temp, $01
  out tccr0, temp
  ldi temp, $03
  out tccr1b, temp

  ; Вызов функции reset
  rcall reset
  rjmp interrupt_handler

number:
  ; Считывание значения TCNT0
  in current_value, TCNT0
  mov temp3, current_value
  ; Вывод значения в порт B
  out PortB, current_value
  ldi r26, $13
  Add r25, r26
  Add current_value, r25
  out TCNT0, current_value
  rjmp interrupt_handler

comparison:
  ; Сравнение с предыдущим значением PORTA
  in input_number2, PINA
  com input_number2
  add interrupt_counter2, input_number2
  cp interrupt_counter2, temp3
  breq flag
  mov input_number2, interrupt_counter2
  rjmp data

flag:
  ; Установка флага
  ldi input_number1, $01
  rjmp data

stop:
  ; Остановка мигания
  ldi temp1, $ff
  out PortB, temp1
  cpi interrupt_counter, $07
  breq main
  rjmp data

blinking:
  ; Мигание светодиодом
  bset 7
  ldi interrupt_counter1, $FF
  inc interrupt_counter1
  inc interrupt_counter2
  ldi temp3, 0
  ldi temp1, $ff
  out PortB, temp1
  cpi interrupt_counter3, $06
  breq main
  cpi interrupt_counter2, $ff
  breq blinking1
  rjmp delay

blinking1:
  ; Мигание светодиодом (часть 2)
  ldi interrupt_counter1, $FF
  ldi interrupt_counter2, 0
  inc temp3
  out PortB, current_value
  cpi interrupt_counter3, $06
  breq main
  cpi temp3, $ff
  breq blinking
  rjmp delay

reset:
  ; Инициализация переменных
  ldi temp1, 0
  out DDRA, temp1
  ldi temp1, $FF
  out DDRB, temp1
  ldi current_value, $00
  ldi temp3, $00
  ldi interrupt_counter, $00
  ldi interrupt_counter1, $00
  ldi interrupt_counter2, $00
  ldi interrupt_counter3, $00
  ldi input_number2, $00
  ret

delay:
  ; Задержка
  dec interrupt_counter1
  cpi interrupt_counter1, $00
  breq blinking

  rjmp delay
