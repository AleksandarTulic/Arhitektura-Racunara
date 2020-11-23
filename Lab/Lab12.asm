;PROMJENLJIVE
section .data

    niz times 96 db 3

;NEINICIJALIZOVANI PODACI
section .bss

    tmp resw 12

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov al, 65
    mov cl, 10h
    mov rdi, 20

    ;mogao sam samo i [niz]
    mov [niz + 0], al
    mov rbx, tmp
    mov rdx, niz

    ;relativno adresiranje
    mov [tmp + 10], cl

    ;bazno-indeksno adresiranje
    ;rdx ima adresu pocetka niza
    mov [rdx + rdi], cl

    ;bazno-indeksno adresiranje
    mov [rdx + rdi + 1], cl

    ;skalirano indeksno adresiranje
    ;96 = 4 * 24 , mi trebamo na 21
    ;rdi = 20 * 4 + 1 -> 21 pozicija ako gledamo kao 4bajta da je jedan element
    mov [rdx + 4 * rdi + 1], cl
mov rax, 60
mov rdi, 0
syscall







