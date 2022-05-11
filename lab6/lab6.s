// Author: Cameron Wolff
// Lab 6
// Purpose: Create 4 labes for quad vaues (A, B, C, D) using the correct 
//          hungarian notation. Print the fomula, then use the external function
//          to display the results
// Date: 02/20/2021

// assemble with:
// as -g -o lab6.o lab6.s
// ld -o lab6 ./lab6.o ./obj/*.o

    .data
szA:     .asciz "100" 
szB:     .asciz "10000"
szC:     .asciz "10000000"
szD:     .asciz "10000000000"
szSum:   .asciz " "
sBuff:   .skip 7  // to make room for sum

iA:      .quad 0
iB:      .quad 0
iC:      .quad 0
iD:      .quad 0
iSum:    .quad 0

cLF:     .byte 10    // line feed, "\n"
cBlank:  .byte 0x20  // " "
cPlus:   .ascii "+"
cEquals: .ascii "="
// 84 bytes


    .global _start
    .text
_start: 
    /******************************OUTPUT FORMULA******************************/
    // Display A
    LDR X0,=szA
    BL putstring  // Branch & link to call function then return afterwards
    
    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display " + "
    LDR X0,=cPlus
    BL putch

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display B
    LDR X0,=szB
    BL putstring

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display " + "
    LDR X0,=cPlus
    BL putch

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display C
    LDR X0,=szC
    BL putstring

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display " + "
    LDR X0,=cPlus
    BL putch

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display D
    LDR X0,=szD
    BL putstring

    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display "="
    LDR X0,=cEquals
    BL putstring

    // Display " "
    LDR X0,=cBlank
    BL putch

    /*************************CONVERT ASCII TO BINARY *************************/
    // convert szA from asciz to int64
    LDR X0,=szA
    BL ascint64
    // store the result of ascint64 to iA
    LDR X1,=iA
    STR X0,[X1]

    // convert szB from asciz to int64
    LDR X0,=szB
    BL ascint64
    // store the result of ascint64 to iB
    LDR X1,=iB
    STR X0,[X1]

    // convert szC from asciz to int64
    LDR X0,=szC
    BL ascint64
    // store the result of ascint64 to iC
    LDR X1,=iC
    STR X0,[X1]

    // convert szD from asciz to int64
    LDR X0,=szD
    BL ascint64
    // store the result of ascint64 to iD
    LDR X1,=iD
    STR X0,[X1]

    /********************LOAD FROM RAM AND PERFORM ADDITION********************/
    // load A,B,C,D to GP registers for addition
    LDR X2,=iA
    LDR X2,[X2]

    LDR X3,=iB
    LDR X3,[X3]

    LDR X4,=iC
    LDR X4,[X4]

    LDR X5,=iD
    LDR X5,[X5]

    // perform addition for problem
    ADDS X6,X2,X3
    ADCS x6,X6,X4
    ADC  X6,X6,X5
    // correct answer: 10,010,010,100

    // store addition for output
    LDR X0,=iSum
    STR X6,[X0]

    /************************OUTPUT RESULT OF ADDITION ************************/
    // convert sum from int to asciz
    LDR X0,[X0]
    LDR X1,=szSum
    BL int64asc
    
    // output result
    LDR X0,=szSum
    BL putstring
    
    // print newline
    LDR X0,=cLF
    BL putch

    // end program
    MOV X0, x9
    MOV X8, #93
    SVC 0
    .end
