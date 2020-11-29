;PROMJENLJIVE
section .data

	;0 - zavrsava
    niz db 'Sutra ce biti', 0

;NEINICIJALIZOVANI PODACI
section .bss

    broj resb 1
	tabela resq 2

;PROGRAMSKI KOD
section .text

extern calWords

global _start
_start:

	;SMATRAMO DA SU RECENICE TACNO FORMIRANE
	mov qword[tabela], niz
	mov qword[tabela+8], broj
	mov rbx, tabela
	call calWords
	mov al, [broj]

mov rax, 60
mov rdi, 0
syscall






