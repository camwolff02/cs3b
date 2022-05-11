// Author: Cameron Wolff
// Lab 4
// Purpose: Using the material from Chapters 1 and 2, you are to write an 
//          assembly program that prints two (2) strings with a carriage return 
//          after each string to the terminal.
// Date: 02/06/2021

        .data  // desegnates data segment of program
szMsg1: .asciz "The sun did not shine."  // length 23 
szMsg2: .asciz "It was too wet to play."  // length 24
chCr:   .byte 10 
// data segment: 23 bytes + 24 bytes + 1 byte = 48 bytes

	.global _start  // Provide program starting address to linker

	.text  // desegnates code segment of program
// Setup the parameters to print strings
// and then call Linux to do it.
_start: mov	X0, #1  // 1 = StdOut
	ldr	X1, =szMsg1  // string to print
	mov	X2, #23  // length of our string
    mov	X8, #64  // linux write system call
	svc	0  // Call linux to output the string

    mov	X0, #1  // 1 = StdOut
	ldr	X1, =chCr  // string to print
	mov	X2, #1  // length of our string
    mov	X8, #64   // linux write system call
	svc	0  // Call linux to output the string

    mov	X0, #1  // 1 = StdOut
    ldr	X1, =szMsg2  // string to print
	mov	X2, #24  // length of our string
    mov	X8, #64  // linux write system call
	svc	0  // Call linux to output the string

    mov	X0, #1  // 1 = StdOut
    ldr	X1, =chCr  // string to print
	mov	X2, #1  // length of our string
	mov	X8, #64  // linux write system call
	svc	0  // Call linux to output the string

// Setup the parameters to exit the program
// and then call Linux to do it.
	mov     X0, #0      // Use 0 return code
    mov     X8, #93      // Service command code 93 terminates this program
    svc     0           // Call linux to terminate the program
