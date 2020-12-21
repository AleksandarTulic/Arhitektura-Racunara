section .text
global add_newElement

	extern sum

add_newElement:
	; + 8 - treci argument proslijedjen
	; + 16 - drugi argument proslijedjen
	; + 24 - prvi argument prosljedjen
	mov rbp, rsp
	mov rax, [rbp + 8]
	mov rbx, [rbp + 16]
	mov rdx, [rbp + 24]

	push rax
	push rdx
	call sum
	mov rdx, rax
	pop rax

	mov rcx, 0
	.for:
		cmp byte[rbx + rcx], 0
		je .end
	
		mov dil, [rbx + rcx]
		add rdx, rcx
		mov [rax + rdx], dil

		inc rcx
	jmp .for

	.end:
		mov byte[rax + rdx], 0
		pop rax
		pop rbx
		pop rdx
ret

; + 24 - broj gdje se treba dodati
; + 16 - koji string se dodaje
; + 8 - na sta se dodaje string

; - prenos parametara: preko steka
; - funckija: dodati novi string u niz 
