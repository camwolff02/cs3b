// Author: Cameron Wolff
// Lab 5
// Purpose: Convert 2 numbers from ascii to binary and add
// Date: 02/18/2021

    .data
szX:     .asciz "10"
szY:     .asciz "15"
dbX:     .quad 0
dbY:     .quad 0
dbSum:   .quad 0

cLF:     .byte 10    // line feed, "\n"
cBlank:  .byte 0x20  // " "
cSum:    .ascii ""   // for sum string
//sBuff:   .skip 7     // to make room for sum
cPlus:   .ascii "+"
cEquals: .ascii "="
// NOTE: don't touch X0->X10 other than for function calls, not preserved

    .global _start
    .text
_start:
    /*******************************OUTPUT INTRO*******************************/
    // Display "10"
    LDR X0,=szX
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

    // Display "10"
    LDR X0,=szY
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
    // convert szX to ascint64
    LDR X0,=szX  // x0->szX
    BL ascint64  // funct call

    // store the result (X0) into dbX
    LDR X1,=dbX  // X1->dbX
    STR X0,[X1]  // store data in X0 into where X1 points
    // STR is opposite of LDR, loads ram

    // convert szY to ascint64
    LDR X0,=szY
    BL ascint64

    // Store the result (X0) int o dbY
    LDR X1,=dbY
    STR X0,[X1]  

    /********************LOAD FROM RAM AND PERFORM ADDITION********************/
    // retrieve from RAM dbX into some GP register (X2)
    LDR X2,=dbX  // x2->dbX
    LDR X2,[X2]  // x2 = *dbX

    // retrieve from RAM dbY into some GP register (X3)
    LDR X3,=dbY  // x3->dbY
    LDR X3,[X3]  // x3 = *dbY

    // perform actual addition
    ADD X9,X2,X3  // X9 = X2 + X3

    // store the result (X9) into dbSum
    LDR X1,=dbSum
    STR X9,[X1]
     
    /************************OUTPUT RESULT OF ADDITION ************************/
    // convert dbSum into int64asc
    LDR X0,=dbSum
    LDR X0,[X0]
    LDR X1,=cSum
    BL int64asc

    // call putstr
    LDR X0,=cSum
    BL putstring

    // print line feed
    LDR X0,=cLF
    BL putch

    // end program
    B return1  // branch to return label

return1:
    MOV X0, x9
    MOV X8, #93
    SVC 0

    .end

    // use -g -o to add debug
    // run gdb -q lab5
    // use debug-break in gdb to run code in debug
