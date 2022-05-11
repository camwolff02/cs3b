// Author: Cameron Wolff
// Lab: Exam 1
// Purpose: Write an assembly language program that reads in 2 integers (x,y) 
// from the keyboard and outputs the result of the following formula.....
// 2 * (x + 2y)
// You must do the multiplication(s) without using the multiply instruction 
// (get creative).
// Date: 03/09/2021

    .data
// helper strings for output
szHeader:   .asciz "Author: Cam Wolff\nDate: 03/09/2022\nProgram: Exam 1\n\n"  // header
szPrompt:   .asciz "Enter "     // string prompt for input
szCol:      .asciz ": "         // string colon for input
szMult:     .asciz " * "        // string asterisk for output equation
szPlus:     .asciz " + "        // string plus sign for output equation
szEq:       .asciz " = "        // string equals sign for output equation

// helper chars for output
cLF:    .ascii "\n"     // char newline for output
cTwo:   .ascii "2"      // char 2 for output equation
cOP:    .ascii "("      // char ( for output equation
cCP:    .ascii ")"      // cahr ) for output equation

// x, y, and ans in char, int, and string
cX:     .ascii "x"      // char x for input
cY:     .ascii "y"      // char y for input
iX:     .quad 0         // int x to store input
iY:     .quad 0         // int y to store input
iAns:   .quad 0         // int ans to store calculation result
szX:    .skip 8         // string x for output equation
szY:    .skip 8         // string y for output equation
szAns:  .skip 8         // string answer for output answer

    .global _start
    .text
_start:
    // print header 
    LDR X0,=szHeader  // load header address to register 
    BL putstring      // branch and link to string output function

    // collect input for X and Y
    .irpc ch XY
        // prompt for input 
        LDR X0,=szPrompt    // load prompt address for putstring function
        BL putstring        // branch and link to string output function
        LDR X0,=c\ch        // load address of character
        BL putch            // branch and link to char output funciton
        LDR X0,=szCol        // load address of :
        BL putstring            // branch and link to string output funciton

        // collect input 
        LDR X0,=sz\ch       // load string address for string input function
        MOV X1, #16         // load string length for string input function
        BL getstring        // call string input function

        // convert input to integer
        LDR X0,=sz\ch       // load string address for conversion
        BL ascint64         // call conversion function
        LDR X1,=i\ch        // load address to hold integer value of input
        STR X0,[X1]         // store integer value of input
    .endr  // end macro

    // output equation 2 * (X + 2 * Y) = 
    LDR X0,=cLF     // load address of \n
    BL putch        // branch and link to char output function
    LDR X0,=cTwo    // load address of 2
    BL putch        // branch and link to char output function
    LDR X0,=szMult  // load address of *
    BL putstring    // branch and link to string output function
    LDR X0,=cOP     // load address of (
    BL putch        // branch and link to char output funciton
    LDR X0,=szX     // load address of x
    BL putstring    // branch and link to string output function
    LDR X0,=szPlus  // load address of +
    BL putstring    // branch and link to string output funciton
    LDR X0,=cTwo    // load address of 2
    BL putch        // branch and link to char output function
    LDR X0,=szMult  // load address of *
    BL putstring    // branch and link to string output function
    LDR X0,=szY     // load address of Y
    BL putstring    // branch and link to string output function
    LDR X0,=cCP     // load address of )
    BL putch        // branch and link to char output function
    LDR X0,=szEq    // load address of =
    BL putstring    // branch and link to char output function

    // load answers into registers for calculation 2 * (X + 2 * Y) = ans
    LDR X2,=iX      // load integer register for X
    LDR X2,[X2]     // move X value into X2
    LDR X3,=iY      // load integer register for Y
    LDR X3,[X3]     // move Y value into X3

    // calculate ans (X0)
    ADD X0,X3,X3    // ans = y + y or ans = 2y
    ADD X0,X2,X0    // ans = x + ans or ans = x + 2y
    ADD X0,X0,X0    // ans = ans + ans or ans *= 2 or ans = 2 * (x + 2y)

    // store answer (not necessary, but nice if code is expanded)
    LDR X1,=iAns    // load address to store answer
    STR X0,[X1]     // store answer (X0) into address of X1 (iAns)

    // convert answer to string
    LDR X1,=szAns   // load address to save string answer
    BL int64asc     // convert int ans to string, using John's function

    // print the answer
    LDR X0,=szAns   // load the address for string answer
    BL putstring    // branch and link to string output function

    // print newline
    LDR X0,=cLF     // load address of newline
    BL putch        // branch and link to char output function

    // end program
    MOV X0, 0       // move 0 to X0, program finished correctly
    MOV X8, #93     // have linux call 93 to terminate program
    SVC 0           // call to linux to terminate program
    .end
