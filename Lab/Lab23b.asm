;PROMJENLJIVE
section .data

    num times 10 db 21, 34, 1, 2 , 11, 121, 9, 3, 22, 89

;NEINICIJALIZOVANI PODACI
section .bss

;PROGRAMSKI KOD
section .text
global _start
_start:

    mov rsi, num
    mov rdi, num
    mov cl, 100

    .petlja:
        ;ovo ucitava u nasem slucaju u al vrijednost prvog clana num-a
        ;uvecava rsi        
        lodsb
        
        cmp al, 10
        jb .sljedeci

        ;upisuje sadrzaj al u rdi i uvecava rdi
        stosb

    .sljedeci:
        loop .petlja
        mov byte [rdi], 0

mov rax, 60
mov rdi, 0
syscall






