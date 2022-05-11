// Programmer: Cameron Wolff
// Lab: Lab 15
// Purpose: File I/O Read
// Date: May 8, 2022
    .data
szFile: .asciz "input.txt"      // file to read from
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
    
    // -------------------------------
    MOV X19,X0  // save fd
    // -------------------- 1st string
    LDR X1,=fileBuf
    BL getline
    LDR X0,=fileBuf
    BL  putstring

    // -------------------- 2nd string
    MOV X0,X19  // load fd
    LDR X1,=fileBuf
    BL  getline
    LDR X0,=fileBuf
    BL  putstring

    // -------------------- 3rd string
    MOV X0,X19  // load fd
    LDR X1,=fileBuf
    BL  getline
    LDR X0,=fileBuf
    BL  putstring

    // Close file
    LDR X0,[SP],#16     // POP fd to X0
    MOV X8,#57          // close file
    SVC 0               // service call

end:
    MOV X0,#0           // load 0, program exited correctly
    MOV X8,#93          // load code to terminate program
    SVC 0               // call to linux to terminate


getline:
    STR LR, [SP,#-16]!
loop:
    BL  getchar
    
    LDRB W2,[X1]
    CMP  W2,#0xa
    B.EQ eoline
    CMP X0,#0x0
    B.LT eof
    CMP x0,#0X0
    B.EQ error

    ADD X1,X1,#1
    LDR X0,=iFD
    LDR X0,[X0]
    B loop

eoline:
    ADD X1,X1,#1
    MOV W2,#0
    STRB W2,[X1]
    B skip
    
    .end