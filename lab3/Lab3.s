// Author: Cameron Wolff
// Lab 3
// Purpose: Subtract two 128-bit (16 byte) numbers 
// Date: 02/06/2021

    // program starting address for linker
    .global _start  

    .text
_start:     
    // Set up first 128-bit number (-2)
    MOV X3, #0xFFFFFFFFFFFFFFFF
    MOV X4, #0xFFFFFFFFFFFFFFFE

    // Set up second 128-bit number (-1)
    MOV X5, #0xFFFFFFFFFFFFFFFF
    MOV X6, #0xFFFFFFFFFFFFFFFF

    //  X3 X4           -2
    //+ X5 X6         -(-1)
    //________       _______  
    //  x1 x2           -1
    SUBS X2, X4, X6  // Lower order 64-bits
    SBC X1, X3, X5  // Higher order 64-bits

    // Setup the parameters to exit the program
    // and then call Linux to do it.
    MOV X0, #0 // Use 0 return code
    MOV X8, #93 // Service code 93 terminates
    SVC 0 // Call Linux to terminate

    .end
