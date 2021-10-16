;EKSTERNE FUNKCIJE
extern printf
extern init
extern fopen
extern fclose
extern fwrite
extern fgetc
extern fputs
extern check
extern add_char
extern length
extern remove_last_char
extern add_newElement
extern fread
extern stringOfValue
extern time
extern removeAll

section .data
	;ISPIS
	option db 'Compress......[1]', 10, 'Decompress....[2]', 10, 'Exit..........[3]', 10, 'Input option: ', 10, 0
	msg_file1 db 'Unesite fajl za citanje: ', 10, 0
	msg_file2 db 'Unesite fajl za ispis: ', 10, 0

	;KOMPRESIJA - PODACI

	;MODOVI - CITANJA
	mod_read db 'r', 0
	mod_readB db 'rb', 0

	;MODOVI - ISPISA
	mod_out db 'w', 0
	mod_outB db 'wb', 0

	;GRESKA
	mis db 'Program nije u mogucnosti da izvrsi operaciju!!!', 0

	ispisM db '%d %s', 10, 0
	ispisInt db 'Vrijeme izvsavanja: %d sekunda[e]', 10, 0

section .bss

	;UNOS - koju operaciju korisnik zeli da izvrsi
	inOption resb 10

	;NIZ - vrijednosti s'kojima enkodujemo i dekodujemo
	niz resq 65536
	;C - vrijednost koja privremeno sadrzi neke vrijednosti
	c resb 1
	;now - string na osnovu kojeg posmatramo vektor NIZ
	;postavili smo na resb 8 jer jedan clan NIZ-a ima 8 bita tj najvise 7 karaktera jer jedan oznacava uvijek kraj
	now resb 8

	bufferNow resb 8
	
	;nameFile - naziv datoteke
	nameFileIn resb 100
	nameFileOut resb 100

	;outB - vrijednost koja sluzi za ispisivanje u binarnu datoteku
	outB resb 2
	inB resb 2
	inB_o resb 2

	;pamtimo sa ovom promjenljivom ucitan char od fgetc
	remInputChar resb 1

	;time
	vrijeme resq 1

section .text

%macro printSentence 0
	push rbp
	mov rbp, rsp
	push rbx
	push rsi
	push rdi

	mov rax, 0
	call printf

	pop rdi
	pop rsi
	pop rbx
	mov rsp, rbp
	pop rbp
%endmacro

global main

main:
	jmp .for

	;DESILA SE GRESKA
	.mistake:
		mov rdi, mis
		printSentence

	;KORISNIK DOK NE UNESE NAREDBU ZA EXIT NE IZLAZI IZ PROGRAMA
	.for:
		mov rax, niz
		push rax
		call removeAll
		pop rax
		mov rax, 0

		;postavljamo vrijeme na nula
		mov rax, vrijeme
		mov rbx, 0
		mov [rax], rbx

		;IPISUJEMO OPCIJE KORISNIKU
		mov rdi, option
		printSentence

		;KORISNIK BIRA OPCIJU
		mov rax, 0
		mov rdi, 0
		mov rsi, inOption
		mov rdx, 10
		syscall

		mov rax, inOption
		mov rbx, 10
		cmp [rax + 1], bl
		jne .for

		mov bl, [rax + 0]

		cmp rbx, 49
		je .compress

		cmp rbx, 50
		je .decompress

		cmp rbx, 51
		je .end

		;KOMPRESIJA
		.compress:
			;ispisujemo poruku - korisnik treba unijeti naziv fajla
			;unosimo naziv fajla odakle citamo i gdje trebamo upisivati vrijednosti
			mov rdi, msg_file1
			printSentence

			mov rax, 0
			mov rdi, 0
			mov rsi, nameFileIn
			mov rdx, 100
			syscall

			mov rax, nameFileIn
			push rax
			call length
			pop rax

			mov rbx, 0
			mov [rax + rdx - 1], bl

			mov rdi, msg_file2
			printSentence

			mov rax, 0
			mov rdi, 0
			mov rsi, nameFileOut
			mov rdx, 100
			syscall

			mov rax, nameFileOut
			push rax
			call length
			pop rax

			mov rbx, 0
			mov [rax + rdx - 1], bl 
			
			;KOMPRESIJA - POCINJE
			push rbp
			mov rbp, rsp
			push rcx
			push rdx
			push rbx
			push rsi
			push rdi

			;------------------- vrijeme - pocinje ---------------------
			mov rdi, 0			
			mov rax, 0
			call time

			mov rbx, vrijeme
			mov [rbx], rax

			;otvaramo datoteku nameFileIn
			mov rdi, nameFileIn
			mov rsi, mod_read
			mov rax, 0
			call fopen

			;provjeravamo da li se datoteka moze otvoriti za citanje
			cmp rax, -1
			je .mistake

			;pokazivac fp = fopen(...) za citanje iz tekstualne
			push rax

			;otvaramo datoteku nameFileOut
			mov rdi, nameFileOut
			mov rsi, mod_outB
			mov rax, 0
			call fopen

			;pokazivac fp = fopen(...) za pisanje u Binarnu
			push rax

			;koliko elemenata ima vektor NIZ
			mov rax, 256
			push rax
			
			;inicijalizuje se vektor elemenata NIZ
			mov rax, niz
			push rax ;----- punimo stek za jedan element
			call init
			pop rax ;----- praznimo stek za jedan element

			.for1:
				;pored r8 koristim i rdi
				;rdi jer prvi clan funkcije fgetc
				;pop r8 - fp = fopen za binarnu datoteku
				;pop rdi - fp = fopen za tekstualnu datoteku

				pop r9
				pop r8
				pop rdi
				push rdi ;----- prvo tekstualnu
				push r8	 ;----- drugo binarnu
				push r9

				mov rax, 0
				call fgetc

				;provjeravamo da li su svi elementi procitani
				cmp rax, -1
				je .end1

				;rax - ucitana char vrijednost karaktera
				mov rbx, remInputChar
				mov [rbx], al
	
				mov rdi, now		
				push rdi
				push rax ;----- sadrzi vrijednost char koji se dodaje
					call add_char
				pop rax
				pop rdi

				;trebamo provjeriti da li je now.length() == 7
				;jer toliko je maks elemenata koje moze da sadrzi
				;ako je toliko onda prelazimo odmah na .jump
				mov rax, now
				push rax
				call length
				pop rax

				cmp rdx, 6
				ja .jump

				;prebacujemo vrijednosti preko steka na neu funkciju(eksterni fajl)
				pop r9
				push r9
				mov rax, niz
				push rax
				mov rax, now
				push rax
				mov rax, r9
				push rax

				;gledamo da postoji string u vektoru NIZ
				call check

				;praznimo stek sa promjenljivima koje smo slali na funkciju check
				pop r8
				pop r8
				pop r8

				;POSMATRAMO DA LI POSTOJI STRING U VEKTORU NIZ
				;-1 NE, OSTALO DA
				cmp rax, -1
				je .jump
				jmp .reset ;----- preskacemo ispisivanje zato sto now + rax postoji vec u NIZ-u

				;ovde ne postoji now + rax u NIZ-u
				;potrebno je ispisati vrijednost za now u binarnu datoteku
				;now = rax, tj ima samo jedan char
				.jump:
					;SADA IMAMO SAMO NOW A NE: NOW + RAX
					mov rax, now
					push rax ;----- prebacujemo elemente
					call remove_last_char
					pop rax ;----- praznimo stek

					.jump_subSection:
						;prebacujemo vrijednosti preko steka na neu funkciju(eksterni fajl)
						pop r9
						push r9
						mov rax, niz
						push rax
						mov rax, now
						push rax
						mov rax, r9
						push rax

						;TRAZIMO VRIJEDNOST ZA NEKI STRING(sigurno postoji)
						call check

						;praznimo stek sa promjenljivima koje smo slali na funkciju check
						pop r8
						pop r8
						pop r8

						;pored r8 koristim i rdi
						;rdi jer prvi clan funkcije fwrite
						;pop r8 - fp = fopen za binarnu datoteku
						;pop rdi - fp = fopen za tekstualnu datoteku
						pop r9
						pop r8
						pop rdi
						push rdi
						push r8
						push r9
						
						;ISPISIVANJE VRIJEDNOSTI
						mov [outB], ax ;----- premjestamo vrijednost iz rax registra na memorijsku lokaciju outB
						mov rdi, outB ;----- adresa sa koje se vrijednost upisuje u binarnu datoteku
						mov rsi, 2 ;----- kolika je velicina jednog elementa 
						mov rdx, 1 ;----- koliko se elemenata upisuje u binarnu datoteku
						mov rcx, r8 ;----- pokazivac fp = fopen(...) binarna datoteka
						mov rax, 0
						call fwrite

						;ukoliko je now.length() == 7 onda se ne moze dodavati char prethodno je receno zasto
						;i necemo dodavati novi string u NIZ - jer ovaj sigurno postoji
						mov rax, now
						push rax
						call length
						pop rax
						
						inc dl
						cmp rdx, 6
						ja .jump_subSection1

					;samo ukoliko je broj elemenata NIZ-a manji od 65535 onda mozemo dodati novi element
					;preko toga nemozemo zbog definicije velicine NIZ-a
					pop rax
					push rax
					cmp rax, 65535
					ja .jump_subSection1

					;dodajemo char rax koji smo dobili sa fgetc na now
					mov rax, now
					push rax
					mov rax, 0					
					mov al, [remInputChar]
					push rax
						call add_char
					pop rax
					pop rax

					;DODAJEMO NOVI ELEMENT KOJI DO SADA NIJE BIO POZNAT NOW + RAX
					pop r9
					push r9
					mov rax, niz
					push rax
					mov rax, now
					push rax
					mov rax, r9
					push rax				
						call add_newElement
					pop rax
					pop rax
					pop rax

					;povecavamo brojac koji nam govori koliko elemenata ima gl
					pop rax
					inc rax
					push rax

					.jump_subSection1:
						;trebamo postavit now = rax
						;posto je rax sigurno jedan char onda
						;samo stavljamo da je prvi char od now[0] = rax, now[1] = 0
						;0 da znamo da je kraj, iako se iza 0 nalaze neki karakteri nama to nije vazno jer 0 uvijek oznacava kraj
						mov rax, 0						
						mov al, [remInputChar]
						mov rbx, now
						mov [rbx + 0], al
						mov rax, 0
						mov [rbx + 1], al
						mov [rbx + 2], al
						mov [rbx + 3], al
						mov [rbx + 4], al
						mov [rbx + 5], al
						mov [rbx + 6], al
						mov [rbx + 7], al
				.reset:
					mov rax, remInputChar
					mov rbx, 0
					mov [rax], bl
					mov rax, 0
			jmp .for1

			;da bi znali kad je kraj citanja elemenata
			.end1:
				;prebacujemo vrijednosti preko steka na zbog funkcije check koja nam vraca indeks string u vektoru NIZ ako postoji
				pop r9
				push r9
				mov rax, niz
				push rax
				mov rax, now
				push rax
				mov rax, r9
				push rax

				call check

				;praznimo stek sa promjenljivima koje smo slali na funkciju check
				pop r8
				pop r8
				pop r8

				;pored r8 koristim i rdi
				;rdi jer prvi clan funkcije fwrite
				;pop r8 - fp = fopen za binarnu datoteku
				;pop rdi - fp = fopen za tekstualnu datoteku
				pop r9
				pop r8
				pop rdi
				push rdi
				push r8
				push r9

				cmp rax, -1
				jne .jump_subSection2

				mov rax, 0

				.jump_subSection2:
				;ISPISIVANJE VRIJEDNOSTI
					mov [outB], ax ;----- premjestamo vrijednost iz rax registra na memorijsku lokaciju outB
					mov rdi, outB ;----- adresa sa koje se vrijednost upisuje u binarnu datoteku
					mov rsi, 2 ;----- kolika je velicina jednog elementa 
					mov rdx, 1 ;----- koliko se elemenata upisuje u binarnu datoteku
					mov rcx, r8 ;----- pokazivac fp = fopen(...) binarna datoteka
					mov rax, 0
					call fwrite

				;zatvaramo datoteku nameFileOut
				pop rdi
				pop rdi
				call fclose

				;zatvaramo datoteku nameFileIn
				pop rdi
				call fclose

				;------------------- vrijeme - zavrsava ---------------------
				mov rdi, 0
				mov rax, 0
				call time

				mov rbx, [vrijeme]
				sub rax, rbx

				mov rdi, ispisInt
				mov rsi, rax
				mov rax, 0
				call printf

				;KOMPRESIJA ZAVRSAVA
				pop rdi
				pop rsi
				pop rbx
				pop rdx
				pop rcx
				mov rsp, rbp
				pop rbp
		jmp .for
		
		;DEKOMPRESIJA
		.decompress:
			;ispisujemo poruku - korisnik treba unijeti naziv fajla
			;unosimo naziv fajla odakle citamo i gdje trebamo upisivati vrijednosti
			mov rdi, msg_file1
			printSentence

			mov rax, 0
			mov rdi, 0
			mov rsi, nameFileIn
			mov rdx, 100
			syscall

			mov rax, nameFileIn
			push rax
			call length
			pop rax

			mov rbx, 0
			mov [rax + rdx - 1], bl

			mov rdi, msg_file2
			printSentence

			mov rax, 0
			mov rdi, 0
			mov rsi, nameFileOut
			mov rdx, 100
			syscall

			mov rax, nameFileOut
			push rax
			call length
			pop rax

			mov rbx, 0
			mov [rax + rdx - 1], bl 

			;DEKOMPRESIJA POCINJE
			push rbp
			mov rbp, rsp
			push rcx
			push rdx
			push rbx
			push rsi
			push rdi

			;------------------- vrijeme - pocinje ---------------------
			mov rdi, 0			
			mov rax, 0
			call time

			mov rbx, vrijeme
			mov [rbx], rax

			;otvaramo datoteku nameFileIn
			mov rdi, nameFileIn
			mov rsi, mod_readB
			mov rax, 0
			call fopen

			;provjeravamo da li se datoteka moze otvoriti za citanje
			cmp rax, -1
			je .mistake

			;pokazivac fp = fopen(...) za citanje iz binarne datoteke
			push rax

			;otvaramo datoteku nameFileOut
			mov rdi, nameFileOut
			mov rsi, mod_out
			mov rax, 0
			call fopen

			;pokazivac fp = fopen(...) za pisanje u tekstualnu datoteku
			push rax

			;pamtimo vrijednost - BR. ELEMENATA VEKTORA NIZ----------------------------------------------------------------------
			mov rax, 256
			push rax
			
			;inicijalizuje se vektor elemenata NIZ
			mov rax, niz
			push rax ;----- punimo stek za jedan element
			call init
			pop rax ;----- praznimo stek za jedan element

			;TREBAMO PROCITATI PRVU VRIJEDNOST
			;ostale se citaju dok su u petlji
			mov rdi, inB
			mov rsi, 2
			mov rdx, 1
			pop r9
			pop r8
			pop rcx
			push rcx
			push r8
			push r9
			mov rax, 0
			call fread

			;ucitana vrijednost u inB sigurno je u range-u tj manje je od broja elemenata vektora NIZ
			;zato sto uvijek se prva vrijednost koja se zapisuje je jedan karakter
			mov rax, now
			push rax
			mov rax, niz
			push rax
			mov rax, 0
			mov ax, [inB]
			push rax

			call stringOfValue

			pop rax
			pop rax
			pop rax

			mov rdi, now
			pop r9
			pop rsi
			pop r8
			push r8
			push rsi
			push r9
			mov rax, 0
			call fputs

			;pamtimo prvi karakter string-a now koji se ispisuje u prethodnom koraku
			mov rax, now
			mov rbx, 0
			mov bl, [rax + 0]
			mov [remInputChar], bl

			;sada vrijednost inB je stara vrijednost(inB_old) a ucitava se nova u inB
			mov rax, 0
			mov ax, [inB]
			mov [inB_o], ax

			;prolazimo kroz cijelu binarnu datoteku
			.for2:
				mov rdi, inB
				mov rsi, 2
				mov rdx, 1
				pop r9
				pop r8
				pop rcx
				push rcx
				push r8
				push r9
				mov rax, 0
				call fread

				cmp rax, rdx
				je .jump_subSection3

				mov rax, 0
				mov ax, [inB]
				mov rbx, 0
				pop rbx
				push rbx

				;provjeravamo da li ucitan short int postoji kao index u vektoru NIZ
				;tj da li broj koji je ucitan manji od velicine vektora NIZ
				cmp rax, rbx
				jb .grantValue

				mov rax, now
				push rax
				call length
				pop rax

				add dl, 1
				cmp rdx, 6
				ja .grantValue
				
				mov rax, now
				mov rbx, 0
				mov [rax + 0], bl
				mov [rax + 1], bl
				mov [rax + 2], bl
				mov [rax + 3], bl
				mov [rax + 4], bl
				mov [rax + 5], bl
				mov [rax + 6], bl
				mov [rax + 7], bl

				;dohvatamo string na poziciji inB_o i dodajemo mu zapamcenu vrijednost remInputChar
				mov rax, now
				push rax
				mov rax, niz
				push rax
				mov rax, 0
				mov ax, [inB_o]
				push rax

				call stringOfValue

				pop rax
				pop rax
				pop rax

				mov rax, now
				push rax
				mov rax, 0
				mov al, [remInputChar]
				push rax
				call add_char
				pop rax
				pop rax
				jmp .jump3
				;ukoliko ucitana vrijednost je manja od velicine NIZ-a
				.grantValue:
					;ucitana vrijednost postoji pa onda pronalazimo string koji ona indeksira
					mov rax, now
					push rax
					mov rax, niz
					push rax
					mov rax, 0
					mov ax, [inB]
					push rax

					call stringOfValue

					pop rax
					pop rax
					pop rax
					
				.jump3:
				;ispisujemo string now u tekstualnu datoteku
				mov rdi, now
				pop r9
				pop rsi
				pop r8
				push r8
				push rsi
				push r9
				mov rax, 0
				call fputs

				;pamtimo opet prvi karakter ispisane vrijednosti
				mov rax, now
				mov rbx, 0
				mov bl, [rax]
				mov rax, remInputChar
				mov [rax], bl

				;posto je unsigned short int vrijednost koja se upisuje u binarnu datoteku kada vrsimo kompresiju
				;maksimalna vrijednost je 65536
				;ali je vektor NIZ indeksiran od 0
				;tako da zadnja pozicija moze biti 65535
				;ukoliko ispunjava uslov onda se odgovarajuci string na odgovarajucoj poziciji
				pop rax
				push rax

				cmp rax, 65536
				je .jump2

				;pronalazimo string na poziciji inB_o u vektoru NIZ				
				mov rax, bufferNow
				push rax
				mov rax, niz
				push rax
				mov rax, 0
				mov ax, [inB_o]
				push rax

				call stringOfValue

				pop rax
				pop rax
				pop rax

				mov rax, bufferNow
				push rax
				call length
				pop rax

				add dl, 1
				cmp rdx, 7
				je .jump2

				mov rax, bufferNow
				mov rbx, 0
				mov bl, [remInputChar]

				;dodajemo karakter na kraj stringa now koji smo prethodno dobili
				push rax
				push rbx
				call add_char
				pop rbx
				pop rax

				;dodajemo novi element na poziciju br
				pop r9
				push r9
				mov rax, niz
				push rax
				mov rax, bufferNow
				push rax
				mov rax, r9
				push rax

				call add_newElement

				pop rax
				pop rax
				pop rax

				;povecavamo vrijednost br koji je broj elemenata vektora NIZ-a
				pop rax
				inc rax
				push rax
				
				.jump2:
					;sada vrijednost koju smo u ovoj iteraciji ucitali postaje stara vrijednost
					mov rax, 0					
					mov ax, [inB]
					mov rbx, inB_o
					mov [rbx], ax
			jmp .for2

			.jump_subSection3:
				;zatvaramo datoteke
				pop rdi ;broj elemenata vektora NIZ
				pop rdi
				call fclose

				pop rdi
				call fclose

				;------------------- vrijeme - zavrsava ---------------------
				mov rdi, 0
				mov rax, 0
				call time

				mov rbx, [vrijeme]
				sub rax, rbx

				mov rdi, ispisInt
				mov rsi, rax
				mov rax, 0
				call printf

				pop rdi
				pop rsi
				pop rbx
				pop rdx
				pop rcx
				mov rsp, rbp
				pop rbp
		jmp .for

	.end:
ret

