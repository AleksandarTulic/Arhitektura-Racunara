extern length

section .text
global remove_last_char
remove_last_char:
	push rbp
	mov rbp, rsp

	;sacuvamo vrijednost registra
	push rdx
	push rbx

	;adresa stringa ciji zadnji element brisemo
	;brisemo tako sto postavimo na 0
	;ukoliko je duzina 0 necemo nista raditi
	mov rax, [rbp + 16]

	push rax
	call length
	pop rax

	cmp rdx, 0
	je .end

	;jer rdx - gdje postavljamo novi element
	;a mi brisemo stari zadnji ppostavljen
	sub rdx, 1

	mov rbx, 0
	mov [rax + rdx], bl

	.end:
		pop rbx
		pop rdx
		pop rbp
ret

;MIJENJA SE NIJEDAN REGISTAR
