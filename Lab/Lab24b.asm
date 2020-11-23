;PROMJENLJIVE
section .data

;NEINICIJALIZOVANI PODACI
section .bss
    
    rez resq 1

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov rax, 1
    mov rbx, 1

    .petlja:
    cmp rbx, 127
    je .kraj
    shl rax, 1
    add rbx, rax
    loop .petlja

    .kraj:

    mov [rez], rbx

mov rax, 60
mov rdi, 0
syscall
