section .text

global init
init:
	push rbp
	mov rbp, rsp

	push rbx
	push rcx

	mov rdi, [rbp + 16]
	mov rax, rdi

	mov rcx, 0
	.for:
		cmp rcx, 256
		je .end

		mov rbx, rcx
		mov [rax + rcx * 8], cl
		mov rbx, 0
		mov [rax + rcx * 8 + 1], bl

		inc rcx
	jmp .for
	
	.end:
		pop rcx
		pop rbx
		pop rbp
ret

;MIJENJA SE: NIJEDAN REGISTAR
