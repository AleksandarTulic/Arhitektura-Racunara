section .text
global add_char
add_char:
	; + 8 - drugi argument proslijedjen
	; + 16 - prvi argument prosljedjen

	mov rbp, rsp
	mov rbx, [rbp + 8]
	mov rax, [rbp + 16]

	push rcx
	mov rcx, 0

	.for:
		cmp byte[rax + rcx], 0
		je .end

		inc rcx
	jmp .for

	.end:
		push rdx
		mov rdx, [rbx]
		mov [rax + rcx], dl
		mov byte[rax + rcx + 1], 0
		pop rdx		
		pop rcx		
		pop rbx
		pop rax
ret

; - prenos parametara: preko steka
; - funckija: na prvi argument dodati char sa drugog argumenta
; - vrijednosti koje se mijenjaju:
; 	- rax i rbx ostaju kakve su bile prije samog poziva, kada su u njima postavite adrese stringova 
