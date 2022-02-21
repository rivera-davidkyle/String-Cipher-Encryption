; Kyle Rivera - CJ57691
; Sage Garcia - UH56499
; main.asm
; This file currently contains the main code for the program. It prompts a menu that takes an input, and jumps to the corresponding subroutine.
; It also contains buffer cleaners, error checks on inputs, and an easter egg secret (inputting c four times).
extern read
extern display
extern squareRoot
extern freeMem
extern printf
extern scanf
extern getchar
extern shift
extern easterEgg
extern jump
	section .data
TOTAL_MESSAGES_STDIN:	dd	0
EASTER_SECRET:	dd	4

menu_options:   db	10,"Encryption menu options:",10,"d - display current messages",10,"r - read new messages",10,"s - shift encrypt",10,"j - jump encrypt",10,"q - quit program",10,"enter option letter -> ",0

string_i:	db	"Enter string location: ", 0

menu_error:	db	"Please type an appropriate value. ", 0

s_error:	db	"Please choose an appropriate index (0 - 9).", 0

exit_msg:	db	"Goodbye!", 10, 0

print_fmt:      db	"%s", 0          ; printf format for str
num_fmt:	db	"%d", 0
input_fmt:      db	"%c", 0          ; scanf format for char

init_message:	dd	"This is the original message.", 0

msg_array:	dq	init_message, init_message, init_message, init_message, init_message, init_message, init_message, init_message, init_message, init_message, init_message


	section .bss
string_ind:	resb	2	; String index input variable	
input:		resb    2	; Menu input variable
	section .text
	global main
main:
	push    rbp
menu:
	mov     rdi,    print_fmt   ; first param for printf
	mov     rsi,    menu_options; second param
	call    printf
 	mov     rdi,    input_fmt   ; first param for scanf
 	mov     rsi,    input       ; second param
	call    scanf
_menu_fix:
	call	getchar
	cmp	rax, 10
	jne	_menu_fix

	cmp     byte [input],    'd'	
	je      _display
	cmp     byte [input],    'r'
 	je      _read
 	cmp     byte [input],    's'
	je      _shift
	cmp     byte [input],    'j'
	je      _jump
	cmp     byte [input],    'q'
	je      _quit
 	cmp	byte [input],	 'c'
	je	_easter_egg
	
	jmp     _menu_error                ; Calls an error if none of the characters are called

_menu_error:
	mov	rdi, print_fmt
	mov	rsi, menu_error
	call	printf

	jmp	_clear_buff	; Clears input buffer before returning to menu
_display:
	mov     rdi, msg_array	; Inputs message array as a parameter
	call    display
	jmp     menu
_read:
	mov	rdi, msg_array	; Inputs message array as a parameter
	mov	rsi, TOTAL_MESSAGES_STDIN	; Inputs TOTAL_MESSAGES_STDIN as a second parameter
	call    read
	jmp     menu

_shift:	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, string_i
	mov	rdx, 23
	syscall

	mov	rax, 0
	mov	rdi, 0
	mov	rsi, string_ind
	mov	rdx, 2
	syscall
	; Checks if index is valid
	mov	bx, 0
	movzx	bx, byte [string_ind + 1]
	cmp	bx, 10
	jne	_index_error	
	
	; Adjusts index to match address jumping
        movzx   ax, byte [string_ind]
	sub	ax, 48
        mov     r9, 8
        mul     r9
        movzx   r10, ax
	
	mov	rdi, [msg_array + r10]	; Moves message address to RDI
	call	shift
	
    	jmp     menu

_jump:
	mov     rax, 1
        mov     rdi, 1
        mov     rsi, string_i
        mov     rdx, 23
        syscall

        mov     rax, 0
        mov     rdi, 0
        mov     rsi, string_ind
        mov     rdx, 2
        syscall
	; Checks if index is valid
        mov     bx, 0
        movzx   bx, byte [string_ind + 1]
        cmp     bx, 10
        jne     _index_error

        ; Adjusts index to match address jumping
        movzx   ax, byte [string_ind]
        sub     ax, 48
        mov     r9, 8
        mul     r9
        movzx   r10, ax

	mov	rdi, [msg_array + r10]	; Moves message address to RDI
	call	jump
	
	jmp menu
_index_error:
	mov	rdi, print_fmt
	mov	rsi, s_error
	call	printf
	; Clear buffer for repeated use
	jmp	_clear_buff
_easter_egg:
	dec	byte [EASTER_SECRET] ; Decrements easter egg counter
	jnz	_menu_error	
	call	easterEgg
_clear_buff:
	; Clears message index input buffer
        mov     r8, 0
        mov     [string_ind], r8
        mov     [string_ind + 1], r8
	; Clears menu input buffer
        mov     [input], r8
        mov     [input + 1], r8
	jmp	menu
_quit:
	mov	rdi, print_fmt
	mov	rsi, exit_msg
	call	printf

	mov	rdi, msg_array	; Puts the message array as a parameter
	mov	rsi, TOTAL_MESSAGES_STDIN ; Puts TOTAL_MESSAGE_STDIN as a second parameter
    	call	freeMem	; Frees up the dynamically allocated memory
    	pop     rbp 
    	mov     rax, 0
    	ret
