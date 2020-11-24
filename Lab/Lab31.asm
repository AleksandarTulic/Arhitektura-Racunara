;PROMJENLJIVE
section .data

;NEINICIJALIZOVANI PODACI
section .bss

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov al, 101
    mov dx, 0

    mov cx, ax
    .petlja:
        add dx, cx
    loop .petlja

mov rax, 60
mov rdi, 0
syscall






