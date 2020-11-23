;PROMJENLJIVE
section .data

    ;ima prenos CF = 1
    ;num1 dq 123456789221
    ;num2 dq 989333111455

    ;nema prenosa CF = 0
    num1 dq 122111111111
    num2 dq 422333333333

;NEINICIJALIZOVANI PODACI
section .bss
    
    suma resd 1

;PROGRAMSKI KOD
section .text
global _start
_start:
    ;posto je eax i ebx 32 bita onda ce iz num1 i num2 procitat samo 32 bita 
    mov eax, [num1]
    mov ebx, [num2]
    add eax, ebx
    
    ;jc _ispis
    ;sad u ecx i edx koji su takodje 32 bita cita sljedecih 32 bita iz num1 i num2 (oni su 64 bitni)
    mov ecx, [num1 + 4]
    mov edx, [num2 + 4]
    adc ecx, edx

    mov [suma], eax
    mov [suma + 4], ecx

    mov rax, [suma]

    ; koristio za provjeru da li je setovan Cf = carry flag
    ;_ispis:
    ;mov eax, '23'
    ;mov [suma], eax

mov rax, 60
mov rdi, 0
syscall







