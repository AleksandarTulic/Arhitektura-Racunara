extern sum

section .text
global stringOfValue
stringOfValue:
	push rbp
	mov rbp, rsp

	push rax
	push rbx
	push rcx
	push r8

	mov rax, [rbp + 16] ;----- short int vrijednost koju trazimo
	mov rbx, [rbp + 24] ;----- adresa vektora NIZ-a
	mov rcx, [rbp + 32] ;----- adresa string-a NOW gdje upisujemo vrijednost iz NIZ-a

	push rax
	call sum
	pop r9

	add rax, rbx

	mov r8, 0
	.for:
		mov rbx, 0
		mov bl, [rax + r8]

		cmp bl, 0
		je .end

		mov [rcx + r8], bl
		inc r8
	jmp .for

	.end:
		mov rbx, 0
		mov [rcx + r8], bl

		pop r8
		pop rcx
		pop rbx
		pop rax
		pop rbp
ret
