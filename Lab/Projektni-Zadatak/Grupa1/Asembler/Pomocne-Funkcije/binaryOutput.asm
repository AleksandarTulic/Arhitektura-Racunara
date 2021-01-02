binaryOutput:
	push rbp
	mov rbp, rsp
	push rbx
	push rsi
	push rdi

	mov rdi, out_data
	mov rsi, mod_binary
	mov rax, 0
	call fopen

	push rax
	mov rdi, value_output
	mov rsi, 2
	mov rdx, 1
	mov rcx, rax
	mov rax, 0
	call fwrite

	pop rdi
	mov rax, 0
	call fclose

	pop rdi
	pop rsi
	pop rbx
	mov rsp, rbp
	pop rbp
ret

; mijenja se: rax
; funkcija: ispis broja koji je velicine 2 bajta
