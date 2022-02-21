#	makefile for main.asm, shift.asm, jump.asm, and validate.c
FILE = main
FILE2 = shift
FILE3 = jump
FILE4 = validate
all: $(FILE)

$(FILE): $(FILE).asm $(FILE2).asm $(FILE3).asm $(FILE4).c
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	gcc -c $(FILE4).c -o $(FILE4).o
	gcc -m64 -o $(FILE) $(FILE).o $(FILE2).o $(FILE3).o $(FILE4).o -lm

run: $(FILE)
	./$(FILE)

clean: 
	rm *.o  *.lst
