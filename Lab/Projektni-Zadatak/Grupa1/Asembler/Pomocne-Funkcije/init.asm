section .text
global funkcija
funkcija:

	mov rbp, rsp
	mov rdi, [rbp + 8]
	pop rax
	mov rax, rdi

	push rbx
	push rcx

	mov rcx, 0
	.for:
		cmp rcx, 96
		je .end

		mov rbx, rcx
		add rbx, ' '
		mov [rax + rcx * 8], bl
		mov rbx, 0
		mov [rax + rcx * 8 + 1], bl

		inc rcx
	jmp .for
	
	.end:
		pop rcx
		pop rbx
ret

; prenos parametara: preko steka
; funkcija: izracunavanje pocetne konfiguracije niza
; vrijednosti koje se mijenjaju:
;   - rax - prije samog poziva
