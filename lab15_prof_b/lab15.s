// Programmer: Cameron Wolff
// Lab: Lab 15
// Purpose: File I/O Read
// Date: May 8, 2022

// create your own or use unistd.h
// file modes
    .equ R,     00      // read only
    .equ W,     01      // write only
    .equ RW,    02      // read write
    .equ T_R,   01002   // truncate read write
    .equ C_W,   02002   // create file if does not exist

 // file permissions
 // Owner Group Other
 // RWE   RWE   RWE
    .equ RW_RW____,0644 
    .equ RW_______,0600
    .equ AT_FDCWD,-100

    .data
szFile: .asciz  "./lab15.txt"   // file to read from
fileBuf: .skip 512              // buffer for file input

    .global _start
    .text
_start:
    // open file
    MOV X0,#AT_FDCWD    // load directory
    MOV X8,#56          // OpenAt
    LDR X1,=szFile      // file name
    MOV X2,#R           // flags
    MOV X3, #RW_______  // file permissions
    SVC 0               // service call
    
    // X0 now contains file descriptor (fd)

    STR X0,[SP,#-16]!   // PUSH fd 
    LDR X1,=fileBuf     // load buffer to store file input
    BL  getline         // collect character from file 
    LDR X0,=fileBuf     // load buffer to print file input
    BL  putstring       // print file

    LDR X0,[SP],#16     // POP fd to X0
    MOV X8,#57          // close file
    SVC 0               // service call

end:
    MOV X0,#0           // load 0, program exited correctly
    MOV X8,#93          // load code to terminate program
    SVC 0               // call to linux to terminate
   
getchar:
    MOV X2, #1          // get a single character

    // ssize_t read(int fd, void* buf, size_t count);
    //      x0 read(X0, X1, X2)
    MOV X8, #63         // read
    SVC 0               // service call
    RET

getline:
    STR LR,[SP,#-16]!   // PUSH link register for return
loop:
    STR  X0,[SP,#-16]!  // PUSH fd 
    BL   getchar        // collect character input
    MOV  X3,X0          // move getchar return 
    ADD  X1,X1,#1       // move to next character in buffer
    LDR  X0,[SP],#16    // POP fd
    CMP  X3,#0          // if getchar returns a 0, we are at end of file 
    B.NE loop           // while (not EOF) continue to loop
    
    LDR LR,[SP],#16     // POP link register for return
    RET

    .end

/*
Linux file commands:
57 - CLose file

General linux commands:
00 - read only 
01 - write only
02 - read write
0100 Create file if it does not exist
01000 - truncate to existing file
02000 - append to existing file

ex. 01002 - truncate read write
ex. 01101 - write, create, truncate

93 - terminate program
// ex. 02102
*/

