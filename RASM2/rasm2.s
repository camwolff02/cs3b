//***************************************************************************** 
//Name: Cameron Wolff
//Program:  RASM2.s 
//Class: CS 3B 
//Lab:  RASM2 
//Date: April 10, 2022 at 11:59 PM
//Purpose: 
// Input numeric information from the keyboard, perform addition, subtraction,  
//  multiplication, and division. Check for overflow upon all operations. 
//***************************************************************************** 

    .data
// STRING INPUT BUFFER
iLimitNum: .word 21  // the limit for entering numeric strings 
// HEADER STRING
szHeader:         .asciz "\tName: Cameron Wolff\n\tProgram: rasm2.asm\n\tClass: CS 3b\n\tDate: April 10, 2022\n\n"
// ERROR STRINGS
szDivByZero:      .asciz "\nYou cannot divide by 0. Thus, there is NO quotient or remainder" 
szOverflowAdd:    .asciz "OVERFLOW occurred when ADDING" 
szOverflowSub:    .asciz "\nOVERFLOW occurred when SUBTRACTING" 
szErrorMul:       .asciz "\nRESULT OUTSIDE ALLOWABLE 64 BIT SIGNED INTEGER RANGE WHEN MULTIPLYING" 
szErrorInput:     .asciz "NUMBER OUTSIDE ALLOWABLE 64 BIT SIGNED INTEGER RE-ENTER VALUE:\n"
szInvalidString:  .asciz "INVALID character in numeric string RE-ENTER VALUE:\n" 
// PROMPT STRINGS
szPromptX:  .asciz "Enter your first number:  "
szPromptY:  .asciz "Enter your second number: "
szSumMsg:   .asciz "The sum is "
szDiffMsg:  .asciz "\nThe difference is "
szProdMsg:  .asciz "\nThe product is "
szQuotMsg:  .asciz "\nThe quotient is "
szRemMsg:   .asciz "\nThe remainder is "
szNewline:  .asciz "\n\n"
szEnd:      .asciz "\nThank you for using my program!! Good Day!\n"

// DATA STRINGS
szSum:      .skip 21  // string for sum value
szDiff:     .skip 21  // string for difference value
szProd:     .skip 21  // string for product value
szQuot:     .skip 21  // string for quotient value
szRemain:   .skip 21  // string for remainder value
// DATA INTEGERS
iX:         .quad 0   // integer for first number (X)
iY:         .quad 0   // integer for second number (Y)
iQuot:      .quad 0   // integer for quotient of two numbers (X / Y)

    .global _start
    .text
_start:
    // Display header
    LDR X0,=szHeader            // load address of header string
    BL  putstring               // call string output function

loop:
    // Collect X and Y, then convert both to integers
    .irpc var XY
        B 3f                    // skip error message
    1:
        LDR X0,=szInvalidString // load error message string
        BL  putstring           // call string output function
        B   3f                  // skip following error messages
    2:  
        LDR X0,=szErrorInput    // load error message string
        BL  putstring           // call string output function
    3:
        LDR X0,=szPrompt\var    // load prompt to collect input var
        BL  putstring           // call string output function
        LDR X0,=iLimitNum       // load address to store input var
        BL  getstring           // call string input function
        LDR X0,=iLimitNum       // load string var to convert
        LDRB W1,[X0]            // load first byte of string for comparison
        CMP W1,0                // make sure input is not null character
        B.EQ end                // if input is null, end program
        BL ascint64             // call string to integer conversion function
        B.HI 1b                 // if input has bad character, retry input
        B.VS 2b                 // if input is too big, retry input
        LDR X1,=i\var           // load address to store int var
        STR X0,[X1]             // store result of converting szVar to iVar
    .endr

    // Calculate and output sum
    LDR X1,=iX                  // load address of first number to add
    LDR X1,[X1]                 // load value of first number to add
    LDR X2,=iY                  // load address of second number to add
    LDR X2,[X2]                 // load value of second number to add
    ADDS X0,X1,X2               // X0 = X + Y
    B.VS addOverflow            // if overflow ocurred, print error instead
    LDR X1,=szSum               // load address to store string sum
    BL  int64asc                // convert int sum to string sum
    LDR X0,=szSumMsg            // load sum output message
    BL  putstring               // call string output function
    LDR X0,=szSum               // load string sum
    BL  putstring               // call string output function
    B   addNormal               // skip error message
// add overflow error handler
addOverflow:
    LDR X0,=szOverflowAdd       // load addition error message
    BL  putstring               // call string output function
addNormal:

    // Calculate and output difference
    LDR X1,=iX                  // load address of first number to add
    LDR X1,[X1]                 // load value of first number to add
    LDR X2,=iY                  // load address of second number to add
    LDR X2,[X2]                 // load value of second number to add
    SUBS X0,X1,X2               // X0 = X - Y   
    B.VS subOverflow            // if overflow occurred, print error instead
    LDR X1,=szDiff              // load address to store string difference
    BL  int64asc                // convert int difference to string difference
    LDR X0,=szDiffMsg           // load difference output message
    BL  putstring               // call string output function
    LDR X0,=szDiff              // load string difference
    BL  putstring               // call string output function
    B   subNormal               // skip error message
// sub overflow error handler
subOverflow:
    LDR X0,=szOverflowSub       // load subtraction error message
    BL  putstring               // call string output function
subNormal:

    // Calculate and output product
    LDR X1,=iX                  // load address of first number to add
    LDR X1,[X1]                 // load value of first number to add
    LDR X2,=iY                  // load address of second number to add
    LDR X2,[X2]                 // load value of second number to add
    MUL X0,X1,X2                // X0 = X * Y
    SDIV X1,X0,X1               // X1 = X0 / X
    CMP X1,X2                   // if X0 / X != Y
    B.NE mulOverflow            // Multiplication overflowed, call error handler
    LDR X1,=szProd              // load address to store string product
    BL  int64asc                // convert int product to string product
    LDR X0,=szProdMsg           // load product output message
    BL  putstring               // call string output function
    LDR X0,=szProd              // load string product
    BL  putstring               // call string output function
    B   mulNormal               // skip error message
// multiply overflow error handler
mulOverflow:
    LDR X0,=szErrorMul          // load multiply error message
    BL  putstring               // call string output function
mulNormal:

    // Calculate and output quotient
    LDR X0,=iX                  // load address of first number to add
    LDR X0,[X0]                 // load value of first number to add
    LDR X1,=iY                  // load address of second number to add
    LDR X1,[X1]                 // load value of second number to add
    CMP X1,#0                   // if our denominator is 0
    B.EQ divByZero              // output error message and skip division
    SDIV X0,X0,X1               // X0 = X / Y
    LDR X1,=iQuot               // load address to store int quotient
    STR X0,[X1]                 // store quotient in integer variable
    LDR X1,=szQuot              // load address to store string quotient
    BL  int64asc                // load int to string conversion function
    LDR X0,=szQuotMsg           // load address of quotient output message
    BL  putstring               // call string output function
    LDR X0,=szQuot              // load address of quotient
    BL  putstring               // call string output function

    // Calculate and output remainder 
    // remainder = numerator - (quotient * denominator)
    LDR X0,=iY                  // load address of denominator
    LDR X0,[X0]                 // load value of denominator
    LDR X1,=iQuot               // load address of quotient
    LDR X1,[X1]                 // load value of quotient
    MUL X0,X0,X1                // X0 = quotient * denominator
    LDR X1,=iX                  // load address of numerator
    LDR X1,[X1]                 // load value of numerator
    SUB X0,X1,X0                // X0 = numerator - (quotient * denominator)
    LDR X1,=szRemain            // load address to store string remainder
    BL  int64asc                // call int to string conversion function
    LDR X0,=szRemMsg            // load remainder message address
    BL  putstring               // call string output function
    LDR X0,=szRemain            // load remainder string to print
    BL  putstring               // call string output function
    B   divNormal               // skip error message if division executed
// Divide error handler
divByZero:
    LDR X0,=szDivByZero         // load error message string
    BL  putstring               // call string output function
divNormal:

    // Output newlines
    LDR X0,=szNewline           // load address of new lines to output
    BL  putstring               // call string output function
    B   loop                    // while (input != null)                

end:
    LDR X0,=szEnd   // load end message string address
    BL  putstring   // call string output function
    MOV X0, 0       // move 0 to X0, program finished correctly
    MOV X8, #93     // have linux call 93 to terminate program
    SVC 0           // call to linux to terminate program
    .end
