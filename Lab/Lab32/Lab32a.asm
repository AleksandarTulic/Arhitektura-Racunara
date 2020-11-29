;PROMJENLJIVE
section .data

    niz times 10 db 12, 1, 45, 7, 19, 22, 21, 121, 113, 201

;NEINICIJALIZOVANI PODACI
section .bss

    rez resb 1
	num resb 1

;PROGRAMSKI KOD
section .text

extern prostCheck

global _start
_start:

    mov rsi, niz
    mov r8, 0

    .petlja:

		push rsi
		push rez

		call prostCheck

		lodsb

		mov bl, [rez]
		mov dl, [num]
		add dl, bl
		mov [num], dl

	cmp r8, 100
	jb .petlja

mov rax, 60
mov rdi, 0
syscall






