;PROMJENLJIVE
section .data

	niz db 'ALEKSANDAR'
	duz equ $-niz

;NEINICIJALIZOVANI PODACI
section .bss

;PROGRAMSKI KOD
section .text

%macro change 2
	mov rsi, %1
	mov rcx, %2
	sub rcx, 1

	.petlja:
		mov dl, [rsi + rcx]
		sub dl, 'A'
		add dl, 'a'
		mov [rsi + rcx], dl
		loop .petlja

	mov dl, [rsi]
	sub dl, 'A'
	add dl, 'a'
	mov [rsi], dl
%endmacro

global _start
_start:

	change niz, duz

mov rax, 60
mov rdi, 0
syscall






