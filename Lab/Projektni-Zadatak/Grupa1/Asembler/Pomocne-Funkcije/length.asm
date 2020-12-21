section .text
global length
length:

	mov rbp, rsp
	mov rdi, [rbp + 8]
	pop rax
	mov rax, rdi

  push rbx
	mov rdx, 0
	
	.for:
		mov bl, [rax + rdx]
		cmp bl, 0
		je .end
		
		inc rdx
	jmp .for

	.end:
    pop rbx
ret

;- prenos parametara: preko steka
;- vrijednosti koje se mijenjaju su:
;  - rax - prije poziva se mijenja
;  - rdx - sadrzat ce duzinu stringa
