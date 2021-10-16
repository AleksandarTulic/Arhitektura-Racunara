section .text

global removeAll
removeAll:
	mov rbp, rsp
	mov rax, [rbp + 8]

	push rbx
	push rcx

	mov rbx, 0
	mov rcx, 525000
	;524288

	.for:
		mov [rax + rcx], bl
	loop .for

	mov [rax + 0], bl
	
	pop rcx
	pop rbx
ret
