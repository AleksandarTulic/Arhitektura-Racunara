;PROMJENLJIVE
section .data

    niz times 10 db 1, 2, 3, 4, 5, 6, 7, 8, 9, 0

;NEINICIJALIZOVANI PODACI
section .bss
    
    suma resq 1

;PROGRAMSKI KOD
section .text
global _start
_start:

    ;brojac postavljamo na 1
    ;isto kao u for petlji i = 1
    mov rcx, 1
    mov rsi, niz

    .petlja:
    ;PAZNJA: mora al biti zato sto je ono 8bita a svaki od podataka u promjenljivoj niz je takodje 8 bita
    mov al, [rsi + rcx]
    add [suma], al
    add rcx, 2
    cmp rcx, 101
    jne .petlja

    mov rax,[suma]

mov rax, 60
mov rdi, 0
syscall
