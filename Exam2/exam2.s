//***************************************************************************** 
//Name: Cameron Wolff
//Program:  exam2.s 
//Class: CS 3B 
//Lab:  exam 2 
//Date: April 20, 2022 at 6:00 PM
//Purpose: 
//  Demonstrate proper knowledge of function calls and dynamic memory allocation
//  Ask the user for 2 strings, and store them in a buffer. Dynamically allocate
//  memory for the two strings, then move the strings from the buffer to the new 
//  memory. Display the strings, call the toUpperCase function to convert them 
//  to all uppercase, and display the uppercase versions of the strings.
//*****************************************************************************     
    
    .data
// DATA MEMBERS
szBuff:     .skip 20    // buffer to hold user input
strPtr1:    .quad 0     // pointer to hold first string input
strPtr2:    .quad 0     // pointer to hold second string input
// STRING LITERALS
szPrompt:   .asciz "Enter string #"
szDisp:     .asciz "\nDisplaying string #"
szConvert:  .ascii "\n\nConverting to Upper Case..."
sz1:        .asciz "1: "
sz2:        .asciz "2: "
szNL:       .asciz "\n"

    .global _start
    .text
_start:
    .irpc num 12  // repeat process for string 1 and 2
        // Display Prompt
        LDR X0,=szPrompt    // load prompt to enter string 
        BL  putstring       // call string output function
        LDR X0,=sz\num      // load prompt to output number
        BL  putstring       // call string output function
        
        // Collect input, allocate memory, and store address
        LDR X0,=szBuff      // load buffer to store input
        BL  getstring       // call string output function
        LDR X0,=szBuff      // load string to find length
        BL  strlength       // call function to find string length
        ADD X0,X0,#1        // add 1 to account for null terminator
        BL  malloc          // allocate memory to store string
        LDR X1,=strPtr\num  // load pointer to hold value
        STR X0,[X1]         // store allocated memory in pointer

        // Copy buffer to allocated memory (X0 contains pointer to string)
        LDR X1,=szBuff      // load buffer to copy
        1:  // loop until we hit null character
            LDRB W2,[X1],#1     // load current character and increase ptr
            CMP W2,#0           // if current character is null character
            B.EQ 2f             // end loop
            STRB W2,[X0],#1     // else, store character in and increase ptr
            B 1b                // continue loop
        2:  // end loop
    .endr

    .irpc num 12  // repeat process for string 1 and 2
        // display output message
        LDR X0,=szDisp      // load display string
        BL  putstring       // call string output function
        LDR X0,=sz\num      // load number string we are outputting
        BL  putstring       // call string output function

        // display string
        LDR X0,=strPtr\num  // load address of string pointer
        LDR X0,[X0]         // load address of string
        BL putstring        // call string output function
    .endr

    LDR X0,=szConvert       // load string to tell user we are now converting
    BL  putstring           // call string output function

    .irpc num 12  // repeat process for string 1 and 2
        // display ouptut message
        LDR X0,=szDisp      // load display string
        BL  putstring       // call string output function
        LDR X0,=sz\num      // load number string we are outputting
        BL  putstring       // call string output function

        // convert string to uppercase, store, and print
        LDR X0,=strPtr\num      // load pointer to string we want to convert
        LDR X0,[X0]             // load address of string we want to convert
        BL  String_toUpperCase  // call uppercase conversion function
        // NOTE: toUpperCase returns a pointer because strings are treated
        // as immutable objects
        STR X0,[SP,#-16]!       // PUSH converted string address to stack
        LDR X0,=strPtr\num      // load pointer to old string
        LDR X0,[X0]             // load address of old string
        BL  free                // deallocate memory of old string
        LDR X0,[SP],#16         // POP converted string from stack
        LDR X1,=strPtr\num      // load pointer to store new converted string
        STR X0,[X1]             // store new string address in ptr
        BL  putstring           // display new string
    .endr

    .irpc num 12  // repeat process for string 1 and 2
        // free allocated memory for converted strings
        LDR X0,=strPtr\num      // load pointer to string we are freeing
        LDR X0,[X0]             // load address of string we are freeing
        BL  free                // free allocated memory for string
    .endr

end:
    LDR X0,=szNL    // load newline character for clean output
    BL  putstring   // call string output function
    MOV X0,#0       // exit code 0, exited successfully
    MOV X8,#93      // code to exit program
    SVC 0           // call linux to exit program
    .end
