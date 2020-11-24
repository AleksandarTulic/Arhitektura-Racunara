;PROMJENLJIVE
section .data

    ;SMATRAT CEMO DA SU SAMO SLOVA ODRAZUMIJEVANA POD KARAKTERIMA
    tekst times 10 db 'aABYZghued'
    buffer dq 0

;NEINICIJALIZOVANI PODACI
section .bss
    
    ;mislim da su mislili na mala i velika slova
    ;da karaktere kao sto su ! @ i sl da ne uzimam u obzir
    ;za svaki karakter dovoljno je resb
    ;*2 za velika i mala slova
    razlika resb 26*2

;PROGRAMSKI KOD
section .text
global _start
_start:

    ;kopiram adresu pocetka niza u registar rsi
    mov rax, tekst
    mov rsi, razlika
    ;isto kao i za for petlju
    mov rdx, 0

    .petlja1:
        cmp rdx, 99
        jg .kraj1
        
        mov bl, [rax + rdx]
        cmp bl, 91
        jl .preskoci1
        
        sub bl, 'a'
        mov [buffer], bl
        mov rdi, [buffer]
        mov cl, '/'
        mov [rsi + rdi], cl
        
        .preskoci1:
            inc rdx
            loop .petlja1

    .kraj1:

        mov rdx, 0

    .petlja2:
        cmp rdx, 99
        jg .kraj2
        
        mov bl, [rax + rdx]
        cmp bl, 90
        jg .preskoci2
        
        sub bl, 'A'
        mov [buffer], bl
        mov rdi, [buffer]
        mov cl, '/'
        mov [rsi + rdi + 26], cl
        
        .preskoci2:
            inc rdx
            loop .petlja2
    
    .kraj2:

        mov rdx, 0

    .petlja3:

        cmp rdx, 25
        jg .kraj3

        mov bl, [rsi + rdx]
        cmp bl, '/'
        je .preskoci3

        mov [buffer], rdx
        mov bl, [buffer]
        add bl, 'a'
        mov [rsi + rdx], bl

        inc rdx
        loop .petlja3

        .preskoci3:
            mov bl, '.'
            mov [rsi + rdx], bl
            inc rdx
            loop .petlja3
    
    .kraj3:

        mov rdx, 0

    .petlja4:
        add rdx, 26
        cmp rdx, 51
        jg .kraj4
        sub rdx, 26

        mov bl, [rsi + rdx + 26]
        cmp bl, '/'
        je .preskoci4

        mov [buffer], rdx
        mov bl, [buffer]
        add bl, 'A'
        mov [rsi + rdx + 26], bl

        inc rdx
        loop .petlja4

        .preskoci4:
            mov bl, '.'
            mov [rsi + rdx + 26], bl
            inc rdx
            loop .petlja4

    .kraj4:

mov rax, 60
mov rdi, 0
syscall

;ADRESA KOJA SE UZIMA MORA BITI SMJESTENA U EAX ILI RAX
;NE MOZE U AL ILI AX






