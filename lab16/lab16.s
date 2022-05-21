// Programmer: Cameron Wolff
// Lab: Lab 15
// Purpose: File I/O Read
// Date: May 15, 2022

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
szFile:     .asciz "input.txt"  // file to read from
szNL:       .asciz "\n"         // string newline character
fileBuf:    .skip 512           // buffer for file input
iArr:       .quad 0,0,0,0,0     // integer array with len(iArr) = 5

    .global _start
    .text
_start:
    // open file
    MOV X0,#AT_FDCWD    // load directory
    MOV X8,#56          // OpenAt
    LDR X1,=szFile      // file name
    MOV X2,#R           // flags
    MOV X3,#RW_______   // file permissions
    SVC 0               // service call
    
    // X0 now contains file descriptor (fd)
    MOV X19,X0          // save fd

    MOV X25,#0          // index
    LDR X27,=iArr       // load array
loop:
    // collect current line from file
    MOV X0,X19          // load fd
    LDR X1,=fileBuf     // load buffer to save file input
    BL  getline         // get input from file

    // output current line
    LDR X0,=fileBuf     // load buffer holding file contents
    BL  putstring       // output file contents
    LDR X0,=szNL        // load newline string
    BL  putstring       // output newline

    // now that we have output the character, time to convert and save
    LDR X0,=fileBuf     // load buffer with input
    BL  ascint64        // convert ascii to integer
    STRB W0,[X27],#1    // store integer
    BL  buf_clear       // clear buffer for next input
    
    // loop while index < 5
    ADD  X25,X25,#1      // i = i + 1
    CMP  X25,#5          // if index < 5
    B.LT loop            // continue to loop

loop_end:

    // Close file
    MOV X0,X19          // load saved fd
    MOV X8,#57          // close file
    SVC 0               // service call

end:
    MOV X0,#0           // load 0, program exited correctly
    MOV X8,#93          // load code to terminate program
    SVC 0               // call to linux to terminate


buf_clear:
    LDR X0,=fileBuf     // load buffer to clear
    MOV X2,#0           // load null character to fill buffer with
clear_loop:
    LDRB W1,[X0]        // load current byte from buffer
    STRB W2,[X0],#1     // store null character to current byte and move to next
    CMP  W1,#0          // if we find the null terminator
    B.EQ return         // buffer has been flushed

return:
    RET                 // return to calling function
    .end
