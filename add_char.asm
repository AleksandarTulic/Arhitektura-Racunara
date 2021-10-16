extern length

section .text
global add_char
add_char:
	push rbp
	mov rbp, rsp

	;da se vrijednosti ne mijenjaju
	push rbx
	push rdx

	mov rax, [rbp + 24] ;string na koji se dodaje karakter
	mov rbx, [rbp + 16] ;karakter koji se dodaje na prethodni

	push rax
	call length
	pop rax

	;prvo postavljamo karakter na poziciju koja se nalazi u rdx registru
	;onda trebamo ponovo poslije dodatog karaktera postaviti nula vrijednost da se zna da je tu kraj
	mov [rax + rdx], bl
	mov rbx, 0
	mov [rax + rdx + 1], bl

	;vracamo stare vrijednosti registara
	pop rdx
	pop rbx
	pop rbp
ret

;MIJENJA SE: NIJEDAN REGISTAR
