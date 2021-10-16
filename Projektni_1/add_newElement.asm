extern sum

section .text
global add_newElement
add_newElement:
	push rbp
	mov rbp, rsp

	push rbx
	push rcx
	push rdx
	push r8
	push r9

	mov rax, [rbp + 16]  ;----- na koju poziciju dodajemo, tj koliko elemenata ima vektor NIZ
	mov rbx, [rbp + 24] ;----- string koji dodajemo u vektor NIZ
	mov r8, [rbp + 32] ;----- adresa vektora NIZ

	;izracunavamo vrijdnost 8 puta vecu
	push rax
	call sum
	pop r9 ;----- praznimo prethodno stavljanje elementa na stek
	

	;brojac za petlju
	mov rcx, 0

	;dodajemo novi element na vektor NIZ
	;tako sto na poziciju rax dodajemo karakter po karakter stringa cija adresa je u rbx
	.for:
		cmp byte[rbx + rcx], 0
		je .end
		
		mov rdx, 0
		mov dl, [rbx + rcx]
		mov [r8 + rax], dl
		add rax, 1

		inc rcx
	jmp .for

	.end:
		pop r9
		pop r8
		pop rdx
		pop rcx
		pop rbx
		pop rbp
ret

;MIJENJA SE: rax registar
