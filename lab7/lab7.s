// Author: Cameron Wolff
// Lab 7
// Purpose: 
// 1. Prompt the user to enter the numeric values of A, B, C, and D. Store 
//    these values as strings. Ensure that each label has sufficient storage to 
//    hold the largest/smallest 64-bit signed integer to include the +/- sign.
// 2. Use the getstring external function to store these values into their 
//    corresponding labels.
// 3. Using a combination of ascint64, int64asc, putstring, putch, compute and 
//    display the result of A - B + C - D.
// Date: 02/27/2021

    .data
szA:    .skip 14  // 100
szB:    .skip 14  // -10,000
szC:    .skip 14  // 10,000,000
szD:    .skip 14  //-10,000,000,000
szSum:  .skip 14 

iA:     .quad 0  
iB:     .quad 0  
iC:     .quad 0  
iD:     .quad 0  
iSum:   .quad 0  

szMsg:  .asciz "Enter a whole number: " //23

cLF:     .byte 10    // line feed, "\n" 
cBlank:  .byte 0x20  // " " 
cPlus:   .ascii "+"  
cMinus:  .ascii "-"  
cEquals: .ascii "="  
// Data Segment: 138 bytes

    .global _start
    .text
_start: 
    /******************************GET USER INPUT******************************/
    // Display prompt
    LDR X0,=szMsg
    BL putstring
    // Collect input for A
    LDR X0,=szA
    MOV X1, #14  // give enough room to enter prompt
    BL getstring

    // Display prompt
    LDR X0,=szMsg
    BL putstring
    // Collect input for B
    LDR X0,=szB
    MOV X1, #14  
    BL getstring

    // Display prompt
    LDR X0,=szMsg
    BL putstring
    // Collect input for C
    LDR X0,=szC
    MOV X1, #14  
    BL getstring

    // Display prompt
    LDR X0,=szMsg
    BL putstring
    // Collect input for D
    LDR X0,=szD
    MOV X1, #14  
    BL getstring

    // display newline
    LDR X0,=cLF
    BL putch
    
    /******************************OUTPUT FORMULA******************************/
    // Display A
    LDR X0,=szA
    BL putstring  // Branch & link to call function then return afterwards
    // Display " "
    LDR X0,=cBlank
    BL putch

    // Display " - "
    LDR X0,=cMinus
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

    // Display " - "
    LDR X0,=cMinus
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

    // 100 - -10000 + 10000000 - -10000000000 = 10,010,010,100
    SUB X6,X2,X3
    SUB X6,X6,X5
    ADD x6,X6,X4
    
    // store addition for output
    LDR X0,=iSum
    STR X6,[X0]

    /************************OUTPUT RESULT OF ADDITION ************************/
    // convert sum from int to asciz
    LDR X0,=iSum
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
    MOV X0, X9
    MOV X8, #93
    SVC 0
    .end
