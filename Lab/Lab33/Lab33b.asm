section .text
global calWords
calWords:
	mov rsi, [rbx]
	mov rdi, [rbx + 8]

	.petlja:
		lodsb
		cmp al, 0
		je .kraj

		cmp al, ' '
		je .dodaj
		jmp .petlja

	.dodaj:
		inc byte[rdi]
		jmp .petlja

		
	loop .petlja

	.kraj:
		inc byte[rdi]
	ret
