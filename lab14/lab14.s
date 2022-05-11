// Programmer: Cameron Wolff
// Lab: Lab 14
// Purpose: File I/O Write
// Date: May 4, 2022

// file modes
    .equ READONLY,00
    .equ WRITEONLY,01
    .equ READWRITE,02
    .equ CREATEWO,0101  // create file if does not exist
 // file permissions
 // Owner Group Other
 // RWE   RWE   RWE
    .equ RW_R__R__,0644  

    .data
// String Literals
szMsg1:     .asciz "Cat in the hat."
szFile:     .asciz "/home/pi/cs3b/lab14/lab14.txt"
fileBuf:    .skip 20

    .global _start
    .text
_start:
    // open file
    MOV X8,#56          // OpenAt
    LDR X1,=szFile      // file name
    MOV X2,#CREATEWO    // flags
    MOV X3,#RW_R__R__   // mode
    SVC 0               // service call
    // returns file handle in X0

    // write to file
    MOV X8,#64          // Write
    LDR X1,=szMsg1      // file name
    MOV X2,#15          // length of string to write
    SVC 0               // service call

    // X0 needs to have file handle in it
    MOV X8,#57          // close file
    SVC 0               // service call

end:
    MOV X0,#0       // load 0, program exited correctly
    MOV X8,#93      // load code to terminate program
    SVC 0           // call to linux to terminate
    .end
