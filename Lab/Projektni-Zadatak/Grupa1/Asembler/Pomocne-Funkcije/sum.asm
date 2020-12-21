section .text
global funkcija
funkcija:

	mov rbp, rsp
	mov rdi, [rbp + 8]
	pop rax
	mov rax, rdi

	push rbx
	push rcx
	mov rcx, 8
	mov rbx, rax

	.for:
		add rax, rbx
	loop .for

	.end:
		pop rcx
		pop rbx
ret

; - prenos parametara: preko steka
; - funkcija: parametar u rax se mnozi sa 8
; - vrijednosti koje se mijenjaju:
;   - rax - sadrzi broj 8 puta veci
