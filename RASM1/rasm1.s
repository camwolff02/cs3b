// Author: Cameron Wolff
// Lab: RASM 1
// Purpose: Write a well-documented program which will perform the below 
// calculations after inputting 4 variables. 
// X = (A + B) – (C + D) where A, B, C, D are all quads that are input by the 
// user at run time. 
// Date: 03/01/2021

    .data
// data for printable strings and characters, 134bytes
szHeader: .asciz " Name: Cameron Wolff\nClass: CS 3B\n  Lab: RASM1\n Date: 3/1/2022\n\n" // Header 65
szPrompt: .asciz "Enter a whole number: "  // String prompt for input 23
szAddPro: .asciz "The addresses of the 4 ints:\n"  // String message for 30
szPlus:   .asciz " + " // for outputting +, 4
szMinus:  .asciz " - " // for outputting -, 4
szEq:     .asciz " = " // for outputting =, 4
cBl:      .ascii " "  // for outputting " "
cOP:      .ascii "("  // for outputting "("
cCP:      .ascii ")"  // for outputting ")"
cLF:      .ascii "\n"  // for outputting newline

// DATA FOR VARIABLES A, B, C, D = ANS
// printable strings of variables, 80bytes
szA:      .skip 16  // string version of A variable
szB:      .skip 16  // string version of B variable
szC:      .skip 16  // string version of C variable
szD:      .skip 16  // string version of D variable
szAns:    .skip 16  // string version of Answer variable

// memory addresses of variables, 64bytes
szAddA:   .skip 8  // string version of A variable address
szAddB:   .skip 8  // string version of B variable address  
szAddC:   .skip 8  // string version of C variable address
szAddD:   .skip 8  // string version of D variable address
iAddA:    .quad 8  // integer version of A variable address
iAddB:    .quad 8  // integer version of B variable address
iAddC:    .quad 8  // integer version of C variable address
iAddD:    .quad 8  // integer version of D variable address

// integer values of variables, 40bytes
iA:       .quad 0  // integer version of A variable
iB:       .quad 0  // integer version of B variable
iC:       .quad 0  // integer version of C variable
iD:       .quad 0  // integer version of D variable
iAns:     .quad 0  // integer version of Answer variable
// 318 byte data segment

    .global _start
    .text
_start:
    // print header
    LDR X0,=szHeader  // load header address to register 
    BL putstring      // branch and link to string output function

    // collect input for A, B, C, and D
    .irpc char ABCD  // repeat the following commands for each char in ABCD
        // prompt for input 
        LDR X0,=szPrompt    // load prompt address for putstring function
        BL putstring        // branch and link to string output function
        // collect input 
        LDR X0,=sz\char     // load string address for string input function
        MOV X1, #16         // load string length for string input function
        BL getstring        // call string input function
        // convert input to integer
        LDR X0,=sz\char     // load string address for conversion
        BL ascint64         // call conversion function
        LDR X1,=i\char      // load address to hold integer value of input
        STR X0,[X1]         // store integer value of input
    .endr
    // irpc is a builtin macro that will take a block of code, and 
    // expand the code into N copies, where N is the length of the string 
    // parameter in the macro. Each copy has \param-name replaced with the
    // corresponding letter in the param-string

    // output part of equation (A + B) - (C + D) = ANS
    LDR X0,=cLF     // load address of \n
    BL putch        // branch and link to char output function
    LDR X0,=cOP     // load address of (
    BL putch        // branch and link to char output function
    LDR X0,=szA     // load address of A
    BL putstring    // branch and link to string output function
    LDR X0,=szPlus  // load address of +
    BL putstring    // branch and link to string output function
    LDR X0,=szB     // load address of B
    BL putstring    // branch and link to string output function
    LDR X0,=cCP     // load address of )
    BL putch        // branch and link to char output function
    LDR X0,=szMinus // load address of -
    BL putstring    // branch and link to string output function
    LDR X0,=cOP     // load address of (
    BL putch        // branch and link to char output function
    LDR X0,=szC     // load address of C
    BL putstring    // branch and link to string output function
    LDR X0,=szPlus  // load address of +
    BL putstring    // branch and link to string output function
    LDR X0,=szD     // load address of D
    BL putstring    // branch and link to string output function
    LDR X0,=cCP     // load address of )
    BL putch        // branch and link to char output function
    LDR X0,=szEq    // load address of =
    BL putstring    // branch and link to string output function

    // load answers into registers for calculation
    LDR X2,=iA      // load integer register for A
    LDR X2,[X2]     // move A value into X2
    LDR X3,=iB      // load integer register for B
    LDR X3,[X3]     // move B value into X3
    LDR X4,=iC      // load integer register for C
    LDR X4,[X4]     // move C value into x4 
    LDR X5,=iD      // load integer register for D
    LDR X5,[X5]     // move c value into x5

    // Calculate ans (X0)
    ADD X0,X2,X3  // perform (A + B)
    ADD X6,X4,X5  // perform (C + D)
    SUB X0,X0,X6  // perform (A+B) - (C+D)

    // Store answer
    LDR X1,=iAns    // load address to store answer
    STR X0,[X1]     // store answer

    // Convert answer to string
    LDR X1,=szAns   // load address to save string answer
    BL int64asc     // convert int ans to string, courtesy of John

    // Print the answer
    LDR X0,=szAns   // load address for string answer
    BL putstring    // branch and link to string output function
    LDR X0,=cLF     // load address of character newline
    BL putch        // call function to print newline character
    LDR X0,=cLF     // load address of character newline
    BL putch        // call function to print newline character

    // print address line intro string
    LDR X0,=szAddPro    // load address of address info message
    BL putstring        // branch and link to string output function

    // convert all addresses to printable strings
    .irpc char ABCD
        LDR X1,=i\char      // load variable we need address
        LDR X0,=iAdd\char   // load place to put address
        STR X1,[X0]         // move pointer to memory address
        LDR X1,=szAdd\char  // load address to move ascii value into
        BL int64asc         // convert address to ascii

        // print address
        LDR X0,=szAdd\char  // address as string
        BL putstring        // branch and link to string output function
        LDR X0,=cBl         // blank to space addresses
        BL putch            // branch and link to char output function
    .endr

    // print newline
    LDR X0,=cLF  // load line feed address for function call
    BL putch     // branch and link to char output function

    // end program
    MOV X0, 0       // move 0 to X0, program finished correctly
    MOV X8, #93     // have linux call 93 to terminate program
    SVC 0           // call to linux to terminate program
    .end
