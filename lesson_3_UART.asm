.include "m8515def.inc"

.def temp1 = R17
.def temp2 = R18
.def temp3 = R19
.def loop_counter1 = R20
.def loop_counter2 = R21
.def loop_counter3 = R25
.def input_number1 = R22
.def input_number2 = R23
.def flag = R24

; Переход к основной программе
rjmp main

.org $09
    ; Обработчик ввода
    rjmp input_handler
    ; Ожидание ввода
    rjmp wait

.org $0B
    ; Прерывание
    in flag, sreg
    push flag
    ldi temp1, $00
    out DDRA, temp1
    clr temp1
    out DDRB, temp1
    ldi temp2, $90
    out UCSRB, temp2
    out sreg, flag
    pop flag
    reti

main:
    ; Настройка стека
    bset 7
    ldi r30, low(RAMEND)
    out SPL, r30
    ldi r30, high(RAMEND)
    out SPH, r30

    clr temp1
    clr temp2
    clr loop_counter1
    clr loop_counter2
    ser input_number1
    ser input_number2
    clr flag
    clr temp3
    out DDRB, temp1
    ldi temp1, $FF
    out DDRA, temp1
    ldi temp3, $01
    out UBRRH, temp3
    ldi temp3, 0
    out UBRRL, temp3
    ldi temp1, $24
    out UCSRC, temp1
    ldi temp2, $90
    out UCSRB, temp2
    ser temp1
    out PORTA, temp1

    ; Ожидание ввода
    rjmp wait

.macro delay
    ; Макрос для задержки
    ser loop_counter1
    delay1:
        ser loop_counter2
        delay2:
            dec loop_counter2
            brne delay2
        dec loop_counter1
        brne delay1
.endmacro

wait:
    ; Ожидание ввода
    sbis PINB, 7
    rjmp compare_input1
    rjmp wait

compare_input1:
    ; Сравнение ввода
    delay
    in temp1, PINB
    cpi temp1, $FF
    breq input_handler
    rjmp compare_input1

input_handler:
    ; Обработка ввода
    sbi PINB, 7
    in input_number1, PINB
    cpi input_number1, $FF
    brne compare_input2
    rjmp input_handler

compare_input2:
    ; Сравнение ввода
    delay
    in temp1, PINB
    cpi temp1, $FF
    breq send_data
    rjmp compare_input2

send_data:
    ; Отправка данных
    ser temp1
    out DDRB, temp1
    ldi temp1, $48
    out UCSRB, temp1
    out UDR, input_number1
    rjmp wait1

wait1:
    ; Ожидание завершения отправки
    rjmp wait1

interrupt:
    ; Прерывание
    in flag, sreg
    push flag
    ldi temp1, $FF
    out DDRA, temp1
    in input_number2, UDR
    out PORTA, input_number2
    sbi PORTA, 7
    pop flag
    out sreg, flag
    delay
    reti
