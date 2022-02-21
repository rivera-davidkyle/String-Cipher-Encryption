; shift.asm
; This file contains the code for shift encryption. It asks the user the shift value, and shifts the ASCII values
; of the string correspondingly. It also contains an error check on the shift value, as well as buffer cleanears
; for repeated use.
extern printf
extern scanf
extern getchar
	section .data
shift_val:      db      "Enter shift value: ", 0

error_prompt:   db      "Please enter a shift value from 0 - 25", 0

curr_msg:	db      "Current message: ", 0

shift_enc:      db      10, "Shift encryption: ", 0

input_fmt:      db      "%d",0
float_fmt:      db      "%f",0
print_fmt:      db      "%s", 0

        section .bss
msg_buf         resb    1000
shift_buf       resb    1000
input		resb	3
        section .text
        global shift
shift:
        push    rbp
        mov     r15, 0  ; Using R15 as an incrementing index
move_buf:
        ; Stores message to buffer recursively
        movzx   bx, byte [rdi + r15]
        cmp     bx, 0
        je      user_input
        mov     [msg_buf + r15], bx
        inc     r15
        jmp     move_buf
user_input:
 	mov     rdi, print_fmt
        mov     rsi, shift_val
        call	printf

        mov	rdi, input_fmt
        mov     rsi, input
	call	scanf
	call	getchar
	; Stores first bit in ax jist in case a two digit number is inputted
        xor     r9, r9
        mov     ax, 0
        movzx   ax, byte [input]
        movzx   r9w, byte [input + 1]
        cmp     r9w, 0		; Checks if the number is only one digit
        je      shift_init
	; If not, makes the stored value a two digit number
        mov     r12, 10
        mul     r12
        add     ax, r9w
	mov	ax, 6
shift_init:
	; Initializing the required values for recursion
	; Checks if user shift input is correct
	cmp     ax, 25
        ja      shift_error
	mov	r15, 0	; Message/shift buffer index
shift_line:
	movzx	bx, byte [msg_buf + r15]
	cmp	bx, 0	; Base case for recursion
	je	shift_exit
	cmp	bx, 122 ; Moves recursion to small letter or to ignore (non-alphabet)
	jb	shift_small
	ja	shift_loop
shift_small:
        cmp     bx, 97	; Moves recursion to big letter
        jb      shift_big
        add     bx, ax	; Shifts small letter ASCII value
        cmp     bx, 122	; If ASCII value exceeds alphabet interval, then shift_fix is called
        ja      shift_fix
        mov     [shift_buf + r15], bx
        jmp     shift_loop
shift_big:
        cmp     bx, 90 ; Moves recursion to ignore non-alphabet characters
       	ja      shift_loop
        cmp     bx, 65 ; Moves recursion to ignore non-alphabet characters
        jb      shift_loop
        add     bx, ax ; Shifts big letter ASCII value
        cmp     bx, 90
        ja      shift_fix ; If ASCII value exceeds alphabet interval, then shift_fix is called
        mov     [shift_buf + r15], bx
        jmp     shift_loop
shift_fix:
        sub     bx, 26	; Reduces shifted value by 26 to remain within the range
        mov     [shift_buf + r15], bx
        jmp     shift_loop
shift_loop:
        mov     [shift_buf + r15], bx ; Moves non-alphabet characters in shifter buffer
        inc     r15	; Increment index
        jmp     shift_line
shift_error:
	; Prints user error prompt
	mov	rdi, print_fmt
	mov	rsi, error_prompt
	call	printf

	; clear_buffer preparation
        mov     r14, 0  ; Storing 0 to R14 as an incrementing index
        mov     r13, 0  ; Storing 0 to R13 as the null value
        jmp     clear_buffer
	
shift_exit:
	; Prints original and shifted message
	mov	rdi, print_fmt
	mov	rsi, curr_msg
	call	printf

 	mov     rdi, print_fmt
        mov     rsi, msg_buf
        call    printf

 	mov     rdi, print_fmt
        mov     rsi, shift_enc
        call    printf

 	mov     rdi, print_fmt
        mov     rsi, shift_buf
	call	printf

        ; clear_buffer preparation
        mov     r14, 0  ; Storing 0 to R14 as an incrementing index
        mov     r13, 0  ; Storing 0 to R13 as the null value
        jmp     clear_buffer	
clear_buffer:
	; Clears message and shift buffer for repeated use
	mov	[msg_buf + r14], r13
	mov	[shift_buf + r14], r13
	inc	r14
	cmp	[msg_buf + r14], r13
	jne	clear_buffer
clear_input:
        ; Clears input buffer for repeated use
        mov     r13, 0
        mov     [input], r13
        mov     [input + 1], r13
        mov     [input + 2], r13
back:
	pop	rbp
	ret


