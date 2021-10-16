extern sum
extern length

section .text

global check
check:
	push rbp
	mov rbp, rsp

	push rcx
	push rdx
	push rbx
	push r8
	push r9
	push r10

	mov rcx, [rbp + 16] ;----- koliko elemenata ima vektor NIZ
	mov rbx, [rbp + 24] ;----- string koji provjeravamo da li se nalazi u vektroru NIZ
	mov r9, [rbp + 32]  ;----- adresa NIZ-a

	sub rcx, 1 ;jer rcx pokazuje gdje treba da se doda novi element NIZ-a

	;izracunavamo duzinu proslijedjenog stringa
	;racunamo samo jednom
	mov rax, rbx
	push rax
		call length
	pop rax ;----- izbacujemo rax koji je na steku
	mov r10, rdx
	
	;prolazimo kroz sve elemente NIZ-a kako bi smo pronalsi da li se vec pojavio
	;ukoliko nije rax = -1 ukoliko jeste pozicija od 0 do rcx - 1
	.for:
		;izracunavamo rax * 8
		;ZASTO? zato sto svaki element je resq tj 8 bajtova pa moramo svako polje po 8 preskakati
		mov rax, rcx
		push rax
			call sum		
		pop r8 ;----- izbacujemo rax koji je na steku
		add rax, r9 ;----- dodajemo adresu pocetka vektora NIZ i tako dobijamo adresu pocetka odg. polja

		;izracunavamo duzinu clana vektora NIZ
		push rax
			call length
		pop rax
		mov r8, rdx

		;provjeravamo da li su iste duzine
		cmp r10, r8
		jne .endNotOk

		;jer je 0 indeksirano
		sub r8, 1

		;prolazimo kroz elemente stringova iste duzina
		.for1:
			;provjeravamo da li smo u range-u duzine stringa
			cmp r8, -1
			je .endOk

			mov rdx, 0
			mov dl, [rax + r8]
			
			;provjeravamo da li su isri char
			;negledamo kad su karakteri 0 zato sto pocinjemo pregled od kraja
			cmp dl, [rbx + r8]
			jne .endNotOk

			sub r8, 1
		jmp .for1
	
		;uspjesno se zavrsilo
		;rax ima vrijednost sa kojim se string mijenja
		;tj poziciju u vektoru NIZ
		.endOk:
			mov rax, rcx
			
			;vracamo stare vrijednosti
			pop r10			
			pop r9
			pop r8
			pop rbx
			pop rdx
			pop rcx
			pop rbp
			ret

		;ponavaljamo operaciju samo za drugi clan vektora NIZ
		.endNotOk:
	loop .for

	mov rax, -1

	;vracamo stare vrijednosti
	pop r10
	pop r9
	pop r8
	pop rbx
	pop rdx
	pop rcx
	pop rbp
ret

;MIJENJA SE: RAX
