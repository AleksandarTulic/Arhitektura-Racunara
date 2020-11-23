;PROMJENLJIVE
section .data
    
    broj dw 65121

;NEINICIJALIZOVANI PODACI
section .bss
    
    rez resb 1

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov si, [broj]
    mov bx, 0
    mov cx, 10
    call Petlja

    mov [rez], bx
    mov rax, [rez]

Petlja:
mov ax, si
cmp ax, 0
je .kraj

div cx
add bx, dx
    
    mov [rez], ax
    mov si, [rez]
    mov ax, 0
    mov dx, 0

call Petlja

.kraj:
ret

mov rax, 60
mov rdi, 0
syscall
