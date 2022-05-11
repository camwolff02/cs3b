// Author: Cameron Wolff
// Lab 2
// Purpose: Add two 192-bit (24 byte) numbers using ADC{S}
// Date: 02/03/2021

    // program starting address for linker
    .global _start  

    .text
_start:     
    // Set up first 192-bit number (-1)
    MOV X3, #0xFFFFFFFFFFFFFFFF
    MOV X4, #0xFFFFFFFFFFFFFFFF
    MOV X5, #0xFFFFFFFFFFFFFFFF

    // Set up second 192-bit number (-1)
    MOV X6, #0xFFFFFFFFFFFFFFFF
    MOV X7, #0xFFFFFFFFFFFFFFFF
    MOV X8, #0xFFFFFFFFFFFFFFFF

    //  X3 X4 X5          -1
    //+ X6 X7 X8        + -1
    //___________       _______  
    //  x0 x1 x2          -2
    ADDS X2, X5, X8  // Lower order 64-bits
    ADCS X1, X4, X7  // Middle order 64-bits
    ADC X0, X3, X6  // Higer order 64-bits

    // Setup the parameters to exit the program
    // and then call Linux to do it.
    MOV X0, #0 // Use 0 return code
    MOV X8, #93 // Service code 93 terminates
    SVC 0 // Call Linux to terminate

    .end
    