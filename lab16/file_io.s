
    .global getchar
    .global getline
    .global getfile
    .text

/******************************************************************************/
// Assembler program to get single character input from file
// string
//
// input:
// X0 - file director

// output:
// X0 - number of bytes successfully read (1 if success, 0 if fail)
getchar:
    MOV X2, #1          // get a single character

    // ssize_t read(int fd, void* buf, size_t count);
    //      x0 read(X0, X1, X2)
    MOV X8, #63         // read
    SVC 0               // service call
    RET



/******************************************************************************/
// Assembler program to get single line from file
//
// input:
// X0 - file director
// X1 - buffer to read to
// output:
// X0 - 1 if eof, 0 if more to read
getline:
    STR LR,[SP,#-16]!   // PUSH link register for return
    MOV X4,#0           // start with length of 1
loop:
    STR  X0,[SP,#-16]!  // PUSH fd 
    BL   getchar        // collect character input
    LDRB W2,[X1]        // load current character

    MOV  X3,X0          // move getchar return 
    ADD  X1,X1,#1       // move to next character in buffer
    LDR  X0,[SP],#16    // POP fd
    CMP  X2,#'\n        // if character is a newline
    B.EQ end_loop       // end function
    CMP  X3,#0          // if getchar returns a 0, we are at end of file 
    B.NE loop           // while (not EOF) continue to loop
    MOV X4,#1

end_loop:
    MOV  X5,#0          // move null terminator into X5
    STRB W5,[X1,#-1]        // replace whitespace character with null
    MOV  X0,X4          // move string length to return register
    LDR  LR,[SP],#16    // POP link register for return
    RET



/******************************************************************************/
// Assembler program to get entire file contents
// string
//
// input:
// X0 - address of string to search
// X1 - character to find
getfile:
    STR LR,[SP,#-16]!   // PUSH link register for return
    MOV X4,#-1           // start with length of 1
get_loop:
    STR  X0,[SP,#-16]!  // PUSH fd 
    BL   getchar        // collect character input
    MOV  X3,X0          // move getchar return 
    ADD  X1,X1,#1       // move to next character in buffer
    ADD  X4,X4,#1       // length of file has increased by 1
    LDR  X0,[SP],#16    // POP fd
    CMP  X3,#0          // if getchar returns a 0, we are at end of file 
    B.NE loop           // while (not EOF) continue to loop
    
    MOV X0,X4           // move string length to return register
    LDR LR,[SP],#16     // POP link register for return
    RET
    .end
