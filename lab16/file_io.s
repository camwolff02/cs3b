
    .global getchar
    .global getline
    .text

// Assembler program to get single character input from file
// string
//
// input:
// X0 - address of string to search
// X1 - character to find
// output:
// X0 - integer index 
getchar:
    MOV X2, #1          // get a single character

    // ssize_t read(int fd, void* buf, size_t count);
    //      x0 read(X0, X1, X2)
    MOV X8, #63         // read
    SVC 0               // service call
    RET

// Assembler program to get entire file contents
// string
//
// input:
// X0 - address of string to search
// X1 - character to find
// output:
// X0 - integer index 
getfile:
    STR LR,[SP,#-16]!   // PUSH link register for return
    MOV X4,#1           // start with length of 1
loop:
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