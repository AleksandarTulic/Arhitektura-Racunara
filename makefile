main: main.o init.o check.o add_char.o remove_last_char.o length.o sum.o add_newElement.o stringOfValue.o removeAll.o
	gcc -o main main.o init.o check.o add_char.o remove_last_char.o length.o sum.o add_newElement.o stringOfValue.o removeAll.o
main.o: main.asm
	nasm -f elf64 -g -F dwarf main.asm
init.o: init.asm
	nasm -f elf64 -g -F dwarf init.asm
check.o: check.asm
	nasm -f elf64 -g -F dwarf check.asm
add_char.o: add_char.asm
	nasm -f elf64 -g -F dwarf add_char.asm
remove_last_char.o: remove_last_char.asm
	nasm -f elf64 -g -F dwarf remove_last_char.asm
length.o: length.asm
	nasm -f elf64 -g -F dwarf length.asm
sum.o: sum.asm
	nasm -f elf64 -g -F dwarf sum.asm
add_newElement.o: add_newElement.asm
	nasm -f elf64 -g -F dwarf add_newElement.asm
stringOfValue.o: stringOfValue.asm
	nasm -f elf64 -g -F dwarf stringOfValue.asm
removeAll.o: removeAll.asm
	nasm -f elf64 -g -F dwarf removeAll.asm
