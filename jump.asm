; jump.asm
; This file contains the code for jump encryption. It asks the user for a jump value between 2
; and the square root of the length of the string. The jump encryption process involves a nested loop.
; Moreover, this program also contains error checks in user input, as well as buffer cleaners for 
; repeated use.
extern printf
extern scanf
extern getchar
extern lenstr
extern squareRoot

    	section .data
prompt:		db  	"Enter a number between 2 and %d: ",0
error_prompt	db	"Please enter a valid number.", 10, 0

curr_msg:       db      "Current message: ", 0

jump_enc:       db      10, "Jump encryption: ", 0

input_fmt:	db	"%d",0
float_fmt:	db 	"%f",0
print_fmt:	db	"%s", 0
    	section .bss
msg_buf:	resb	1000
jump_buf:	resb	1000
input:      	resb    3
	section .text
    	global jump
jump:
	push	rbp
	mov	r15, 0	; Using R15 as an incrementing index
move_buf:
	; Stores message to buffer recursively
	movzx	bx, byte [rdi + r15]
	cmp	bx, 0
	je	square_rt
	mov	[msg_buf + r15], bx
	inc	r15
	jmp	move_buf
square_rt:
	; Square roots the length of string
    	mov     rdi, 0
    	mov     rdi, r15     ; Puts length of message as a parameter
    	call    squareRoot	
user_input:
	mov	r13, rax	; Moves the square root value to R13 for future comparison
    	mov     rsi, rax	; Puts square root value as a parameter
    	mov     rdi, prompt
    	call    printf

   	mov     rdi, input_fmt
	mov	rsi, input
	call	scanf
	call	getchar
	
	; Stores first bit in ax just in case a two digit number is inputted
        xor     r9, r9
        mov     ax, 0
        movzx   ax, byte [input]
      	movzx   r9w, byte [input + 1]
        ; Checks if the user input is only one digit
        cmp     r9w, 0 
        je      jump_init
	; If not, makes the stored value a two digit number
        mov     r8, 10
        mul     r8
        add     ax, r9w
jump_init:
	movzx	r9, ax
	cmp	r9, r13
	ja	jump_error
	cmp	r9, 2
	jb	jump_error
	mov	r9, 0 ; jump_buf index
	mov	r14, 0 ; Outer loop index
	mov	r13, 0 ; Inner loop index
	mov	r8, 0 ; Jumped character index
	mov	r12, 0 ; Container for a part of the index
	mov	bx, ax ; Saves jump value for repeated use
	movzx	r11, ax ; Saves jump value for comparison check
	movzx	r10, ax	
	add	r10, r15
	sub	r10, 4 ; R10 contains for loop condition for inner loop
jump_inner_loop:
	; For loop condition for inner loop
	cmp     r13, r10 
        jae      jump_outer_loop
	; Creating index for jump encryption
	mul	r13	
	movzx	r12, ax
	mov	r8, r14
	add	r8, r12
	; Makes sure index is within range
	cmp	r8, r15
	jae	jump_inner_fix
	; Moves jumped character to buffer
	movzx	cx, byte [msg_buf + r8]
	mov	[jump_buf + r9], cx
	; Resets registers
	mov	cx, 0
	mov	ax, bx
	mov	r12, 0
	inc	r13	; Increments the inner loop
	inc	r9	; Increments the jump index
	jmp	jump_inner_loop
jump_inner_fix:
	; Resets the registers
	mov	cx, 0
	mov	ax, bx
	mov	r12, 0
	inc	r13	; Increments the inner loop
	jmp	jump_inner_loop
jump_outer_loop:
	; Resets the registers
	mov	cx, 0
	mov	ax, bx
	mov	r12, 0
	mov	r13, 0
	inc	r14	; Incremenets the outer loop
	; For loop condition for outer loop
	cmp	r14, r11
	jae	print_j
	jmp	jump_inner_loop
jump_error:
	; Prints error input message
	mov	rdi, print_fmt
	mov	rsi, error_prompt
	call	printf
 	
	; clear_buffer preparation
	mov     r14, 0	; Storing 0 to R14 as an incrementing index
        mov     r13, 0	; Storing 0 to R13 as the null value 
	jmp	clear_buffer
print_j:
	mov	rdi, print_fmt
	mov	rsi, curr_msg
	call 	printf

	mov	rdi, print_fmt
	mov	rsi, msg_buf
	call	printf

        mov     rdi, print_fmt
        mov     rsi, jump_enc
        call    printf

	mov     rdi, print_fmt
        mov     rsi, jump_buf
        call    printf
        
	; clear_buffer preparation
        mov     r14, 0  ; Storing 0 to R14 as an incrementing index
        mov     r13, 0  ; Storing 0 to R13 as the null value
clear_buffer:
	; Clears buffer for both message and jump buffers for repeated use
        mov     [msg_buf + r14], r13
        mov     [jump_buf + r14], r13
        inc     r14
        cmp     [msg_buf + r14], r13
        JNE     clear_buffer
clear_input:
	; Clears input buffer for repeated use
	mov     r13, 0
        mov     [input], r13
        mov     [input + 1], r13
        mov     [input + 2], r13
back:
    	pop     rbp	; Aligns stack
    	ret
