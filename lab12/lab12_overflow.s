// Author: Cameron Wolff
// Lab: 12
// Purpose: Write this C++ program in ARM64
// #include <iostream>
// #include "factorial.h"
// using namespace std;
// int main() {
//    int n = 1;
//    while (true)
//      cout<<"Factorial of "<<n<<" is "<<fact(n++);
//    return 0;
// }
// Date: 04/06/2021

    .data
szMsg1: .asciz "factorial of "
szMsg2: .asciz " is "
szFact: .skip 8
szN:    .skip 8
cNL:    .ascii "\n"
iN:     .quad 0

    .global _start
    .text
_start:
    // initialize n = 1
    MOV X0,#1           // move initial value 1 into X0
    LDR X1,=iN          // load integer variable n to store initial value
    STR X0,[X1]         // store initial value in n

    loop:  // do
        // convert n to string 
        LDR X0,=iN      // load X0 with iN address
        LDR X0,[X0]     // load X0 with iN value
        LDR X1,=szN     // load X1 with spot to store n string 
        BL  int64asc    // call integer to ascii conversion function

        // output solution message
        LDR X0,=szMsg1  // load in string for first half of message
        BL  putstring   // call string output function
        LDR X0,=szN     // load string n
        BL  putstring   // call string output function
        LDR X0,=szMsg2  // load in string for second half of message
        BL  putstring   // call string output function

        // call Factorial for value n
        LDR X0,=iN      // load address of integer n for funtion
        LDR X0,[X0]     // load value of integer n for function
        BL  fact        // call factorial function

        // convert Factorial answer to string and print
        LDR X1,=szFact  // load X1 with spot to store fact string (X0 has int ans)
        BL  int64asc    // call integer to ascii conversion function
        LDR X0,=szFact  // load address of Factorial answer to print
        BL  putstring   // call string output function

        // output newline
        LDR X0,=cNL     // load newline character
        BL  putch       // call character output function

        // increment n
        LDR X0,=iN      // load address of n to increment
        LDR X0,[X0]     // load value of n
        ADD X0,X0,#1    // n = n + 1
        LDR X1,=iN      // load address of n to store new n
        STR X0,[X1]     // store new n value
    B loop  // while (true)

end:
    // end program
    MOV X0, 0       // move 0 to X0, program finished correctly
    MOV X8, #93     // have linux call 93 to terminate program
    SVC 0           // call to linux to terminate program
    .end
