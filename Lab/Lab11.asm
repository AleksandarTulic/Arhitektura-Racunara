;PROMJENLJIVE
section .data

    nbcd1 db 2h, 1h     ; nbcd 12
    nbcd2 db 6h, 2h, 4h ; nbcd 426

    pbcd1 db 12h        ; bcd 12
    pbcd2 db 26h, 4h    ; bcd 426

    ;db - word, 8 bita
    intb1 db 12h
    intb2 db 01011100b
    intb3 db -78

    ;dw - double word, 16 bita
    intw1 dw 12h
    intw2 dw 426
    intw3 dw -7
    intw4 dw 1234h

    ;dd - Double word, 32 bita
    intd1 dd 12h
    intd2 dd 426
    intd3 dd -7
    intd4 dd 1234h

    ;dq - tip QWORD, 64 bita
    intq1 dq 12h
    intq2 dq 426
    intq3 dq -7
    intq4 dq 123456789ABCDEFh

    ;dd - za jednostruku preciznost
    reals1 dd 1.0
    reals2 dd -1.0
    reals3 dd 123.5
    reals4 dd 5.5E5

    ;dq - za dvostruku preciznost
    realsq1 dq 1.0
    realsq2 dq -1.0
    realsq3 dq 123.5
    realsq4 dq 5.5E5

;NEINICIJALIZOVANI PODACI
section .bss

;PROGRAMSKI KOD
section .text
global _start
_start:
    ;prepisujemo lokaciju nbcd1 povetka memorije u registar rax
    ; da je bilo [nbcd1] onda to predstavlja vrijednost memorijske lokacije tj 12h
    ; posto je rax je registar od 64b a nbcd1 nije onda ovo -> [nbcd1] nece dobro funkcionisati
    mov rax, nbcd1

    ;ali zato mov rsi (takodje 64b) radi za dq jer ti podaci su takodje 64b
    mov rsi, [intq2]
mov rax, 60
mov rdi, 0
syscall







