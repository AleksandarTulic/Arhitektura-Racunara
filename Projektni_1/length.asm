section .text
global length
length:
	push rbp
	mov rbp, rsp
	
	;stavljamo na stek da bi sacuvali vrijednosti
	push rax
	push rcx
	push rbx

	;rax ima adresu stringa ciju duzinu trazimo
	mov rax, [rbp + 16]

	;prolazimo kroz string i tamo gdje je 0 tolika je duzina stringa
	mov rcx, 0
	mov rbx, 0
	
	.for:
		mov rbx, [rax + rcx]
		cmp bl, 0
		je .end

		inc rcx
	jmp .for
	
	.end:
		;duzina stringa se uvijek skladisti u rdx registar u mojoj implementaciji
		mov rdx, rcx

		;vracamo vrijeednosti koje su ile prije poziva funkcije
		pop rbx	
		pop rcx
		pop rax	
		pop rbp
ret

;MIJENJA SE: RDX
