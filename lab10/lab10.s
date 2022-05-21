// Author: Cameron Wolff
// Lab: 10
// Purpose: 
// Date: 03/16/2021

    .data
iArr:   .word 0,0,0,0,0,0,0,0,0,0   // len(iArr) = 10
szNum:  .skip 21                    // string buffer for number input
szMsg:  .asciz "enter an integer: " // for prompting user input
cSpace: .ascii " "                  // for output space between numbers
szEq:   .asciz "= "                 // for output equals
cLF:    .ascii "\n"                 // for output newline

    .global _start
    .text
_start:
    /****************************COLLECT USER INPUT****************************/
    LDR X11,=iArr   // X11 holds pointer to int array
    MOV X12,#0      // X12 is our LCV, initialize to 0   
    MOV X13,#0      // X13 is our sum, initialize to 0

    loop:  // for LCV in range(10)
        // output prompt
        LDR X0,=szMsg  // load string message to X0 for output
        BL putstring   // call putstring function to output string

        // collect input from user
        LDR X0,=szNum   // load address to write input to
        MOV X1,#21      // load size of input
        BL getstring    // call function to collect user input
        
        // load element [i] in iArr
        LDR X0,=szNum   // point X0 to temporary cstring
        BL  ascint64    // now that registers are saved, convert ascii to int
        ADD X13,X13,X0  // Add new int to sum
        STR X0,[X11]    // store new int to iArr 
        ADD X11,X11,#4  // increment &iArr by 4 bytes or sizeof(word)

    // end for
    ADD X12,X12,#1  // LCV += 1
    CMP X12,#10     // compare LCV to 10
    B.LT loop       // loop while LCV < 10

    /****************************OUTPUT USER INPUT*****************************/
    LDR X11,=iArr  // X11 holds pointer to string array
    MOV X12,#0     // X12 is our LCV, initialize to 0   

    print_loop:  // for x in iArr
        LDR W0,[X11],#1 // load iArr[i] to W0 (4 bytes) and increment to next
        LDR X1,=szNum   // load string to store converted number 
        BL int64asc     // call function to convert int to ascii
        LDR X0,=szNum   // load string number for output
        BL putstring    // call function to output string number
        LDR X0,=cSpace  // load " " for output
        BL putch        // call char output function

    // end for
    ADD X12,X12,#1      // LCV += 1
    CMP X12,#10         // compare LCV to 10
    B.LT print_loop     // loop while LCV < 10

    /*******************************OUTPUT SUM*********************************/
    LDR X0,=szEq    // load string equals for output
    BL putstring    // call string output function
    MOV X0,X13      // move sum to X0 for funciton call
    LDR X1,=szNum   // load sum string to X1 for function call
    BL int64asc     // call int to ascii conversion function
    LDR X0,=szNum   // load address of sum string for output
    BL putstring    // call string output function
    LDR X0,=cLF     // load newline for output
    BL putch        // call char output function

    // end program
    MOV X0, 0       // move 0 to X0, program finished correctly
    MOV X8, #93     // have linux call 93 to terminate program
    SVC 0           // call to linux to terminate program
    .end
