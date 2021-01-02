section .data

	input_data db 'alo.txt', 0
	mod db  'r', 0

section .bss

	c resb 1
	niz resq 4

section .text
global main

	extern fopen, fclose, fgetc

main:

	push rbp
	mov rbp, rsp
	push rbx
	push rsi
	push rdi

	mov rsi, mod
	mov rdi, input_data
	mov rax,0
	call fopen

	push rax
	.petlja:
		pop rdi
		push rdi
		mov rax, 0
		call fgetc

		cmp al, 255
		jg .kraj
		cmp rax, 0
		jb .kraj

		;OVDE SE NESTO RADI
	jmp .petlja
	
	.kraj:
		pop rdi
		call fclose

	pop rdi
	pop rsi
	pop rbx
	mov rsp, rbp
	pop rbp

mov rax, 60
mov rdi, 0
ret
