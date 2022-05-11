// Author: Cameron Wolff
// Lab 8
// Purpose: Construct a DO/WHILE statement
// Date: 02/28/2021

    .data
szHello: .asciz "Hello World\n"

    .global _start
    .text
_start:
    // Print "Hello World" 10 times
    MOV X3, #0
    loop:
        LDR X0,=szHello
        BL putstring

        // X3 += 1
        ADD X3, X3, #1
    CMP X3, #10
    B.LT loop

    // end program
    MOV X0, 0
    MOV X8, #93
    SVC 0
    .end
