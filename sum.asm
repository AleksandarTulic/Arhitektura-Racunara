section .text
global sum
sum:
	push rbp
	mov rbp, rsp

	;sacuvao vrijednosti
	push rbx
	push rcx

	;sadrzi vrijednost za koju izracunavamo rax * 8
	mov rax, [rbp + 16]

	;iterativno 7 puta sumiramo
	mov rcx, 7
	mov rbx, rax

	.for:
		add rax, rbx
	loop .for

	;vracanje starih vrijednosti
	pop rcx
	pop rbx
	pop rbp
ret

;MIJENJA SE: RAX
