// Author: Cameron Wolff
// Lab: 13
// Purpose: Demonstrate the ability to modify immutable strings
// Date: 04/06/2021

    .data
szX:        .asciz "Cat "          // first string to concatenate
szY:        .asciz "in the hat\n"  // second string to concatenate
ptrString:  .quad   0              // initialize a null pointer

    .global _start  // provide starting address to linker
    .text
_start:
    // reserve memory
    MOV X0,#15          // assume we need 4-bytes
    BL  malloc          // Call malloc to request 'X0' bytes from the OS
    // X0 now points to the 15-byte block of ram requested from the OS (heap)
    LDR X1,=ptrString   // load address to save allocated memory
    STR X0,[X1]         // save requested pointer for future use

    // loop to copy str1 into new memory
    MOV X2,#4           // i = 4
    LDR X3,=szX         // load address we are copying from
    LDR X1,[X1]         // set X1 to point to new memory
    top1:  // for (int i = 4; i > 0; --i)
        CMP  X2,#0          // compare i to 0
        B.LE bot1           // end loop if i <= 0
        LDRB W4,[X3],#1     // load the current char from szX
        STRB W4,[X1],#1     // store the current char to ptrString
        SUB  X2,X2,#1       // i = i - 1
        b    top1           // continue loop
    bot1:    

    // loop to copy str2 into new memory
    MOV X2,#12              // i = 10
    LDR X3,=szY             // load address we are copying from
    top2:  // for (int i = 10; i > 0; --i)
        CMP  X2,#0          // compare i to 0
        B.LE bot2           // end loop if i <= 0
        LDRB W4,[X3],#1     // load the current char from szY      
        STRB W4,[X1],#1     // store the current char to ptrString
        SUB  X2,X2,#1       // i = i - 1
        b    top2           // continue loop
    bot2:

    // print out using putstring
    LDR X0,=ptrString   // load pointer to string to print
    LDR X0,[X0]         // load address of string to print
    BL putstring        // call string output function

    // return memory to the OS
    LDR X0,=ptrString   // load address of memory to free
    LDR X0,[X0]         // load memory address we are freeing
    BL free             // call free to free requested memory

exit:
    MOV X0,#0   // use return code 0, program exited correctly
    MOV X8,#93  // service command 93 terminates program
    SVC 0       // call linux to terminate program
    .end
