section .text
global prostCheck
prostCheck:
	mov rbp, rsp
	mov rdi, [rbp + 16]
	mov al, [rdi]

	cmp al, 1
	je .kraj

	mov bl, al
	mov dl, 2
	mov cl, 0
	
	.petlja:
		cmp dl, al
		je .kraj

		div dl
		inc dl

		cmp ah, 0
		je .flag

		mov al, bl
		mov ah, 0		

	loop .petlja

	.kraj:
		mov rdi, [rbp + 8]
		mov al, 1
		mov [rdi], al
		ret

	.flag:
		mov rdi, [rbp + 8]
		mov al, 0
		mov [rdi], al
		ret
