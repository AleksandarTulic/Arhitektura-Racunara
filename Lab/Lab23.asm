;PROMJENLJIVE
section .data

    f0 db 0
    f1 db 1

;NEINICIJALIZOVANI PODACI
section .bss
    
    rez resb 1

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov al, [f0]
    mov bl, [f1]
    call Fibonacci
    mov [rez], al
    
    ;samo provjeravam koja je vrijednost zapisana i 144 je prvi fibonacijev trocifren broj
    mov rax, [rez]

Fibonacci:
    cmp al, 99
    ja .condition1

    mov cl, al
    add al, bl
    mov bl, cl
    call Fibonacci

    .condition1:
    ret

mov rax, 60
mov rdi, 0
syscall







