// Author: Cameron Wolff
// Lab 9
// Purpose: Write a program that prompts the user for two (2) 64 bit signed
//          numbers and displays the largest of the two.
// Date: 02/28/2021

    .data
szX:     .skip 8
szY:     .skip 8

iX: .quad 0
iY: .quad 0

szEnter: .asciz "Enter "
szEq:    .asciz " == "
szGT:    .asciz " > "
szCol:   .asciz ": "
cX:      .ascii "x"
cY:      .ascii "y"
cLF:     .ascii "\n"
// 54

    .global _start
    .text
_start:
    /******************************GET USER INPUT******************************/
    // cout << "Enter x:"
    LDR X0,=szEnter
    BL putstring
    LDR X0,=cX
    BL putch
    LDR X0,=szCol
    BL putstring

    // cin >> szX
    LDR X0,=szX
    MOV X1, #8
    BL getstring
    // cout << "Enter y:"
    LDR X0,=szEnter
    BL putstring
    LDR X0,=cY
    BL putch
    LDR X0,=szCol
    BL putstring

    // cin >> szY
    LDR X0,=szY
    MOV X1, #8
    BL getstring

    /*************************CONVERT ASCII TO BINARY *************************/
    // load x into RAM
    LDR X0,=szX
    BL ascint64
    LDR X1,=iX
    STR X0,[X1]

    // load y into RAM
    LDR X0,=szY
    BL ascint64
    LDR X1,=iY
    STR X0,[X1]

    /***********************OUTPUT RESULT OF COMPARISON ***********************/
    // Load X and Y into GP registers
    LDR X0,=iX
    LDR X0,[X0]
    LDR X1,=iY
    LDR X1,[X1]
    
    // if statement on comparing X to Y
    CMP X0, X1
    B.LE elseif // if x > y
        LDR X11,=szGT  // store > as comparison symbol
        B same  // some actions are same for x > y and x == y

    elseif:  // else if y > x
    B.GE else 
        LDR X9,=cY  // store Y as first symbol
        LDR X10,=cX  // store X as second symbol
        LDR X11,=szGT  // store > as comparison symbol
        LDR X12,=szY  // store string Y as first number 
        LDR X13,=szX  // store string X as second number
        B endif

    else:  // else x == y
        LDR X11,=szEq  // store == as comparison symbol
        same:  // shared actions
        LDR X9,=cX  // store X as first symbol
        LDR X10,=cY  // store Y as second symbol
        LDR X12,=szX  // store string X as first number
        LDR X13,=szY  // store string Y as second number

    endif: // end if statement

    // print (LHC) (SYMBOL) (RHC): (LHS) (SYMBOL) (RHS)
    MOV X0,X9  // LHC
    BL putch
    MOV X0,X11   // SYMBOL
    BL putstring
    MOV X0,X10  // RHC
    BL putch
    LDR X0,=szCol  // ": "
    BL putstring
    MOV X0,X12  // LHS
    BL putstring
    MOV X0,X11  // Symbol
    BL putstring  
    MOV X0,X13  // RHS
    BL putstring

    // print newline
    LDR X0,=cLF
    BL putch

    // end program
    MOV X0, 0
    MOV X8, #93
    SVC 0
    .end
