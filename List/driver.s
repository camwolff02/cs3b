// ld -o driver /usr/lib/aarch64-linux-gnu/libc.so ./driver.o ./list.o ./string.a ./prof_b.a -dynamic-linker /lib/ld-linux-aarch64.so.1
// Programmer: Cameron Wolff
// Lab: Lab 17
// Purpose: Create a Singly Linked List
// Date: May 2, 2022
    .data
// String Literals
str1:       .asciz "The Cat in the Hat\n"
str2:       .asciz "----------------------\n"
str3:       .asciz "By Dr. Seuss\n"
str4:       .asciz "**********************\n"
str5:       .asciz "The sun did not shine.\n"

    .global _start
    .text
_start:
// fill list
.irpc num, 12345
    LDR  X0,=str\num    // load string to copy
    BL   String_copy    // call function to copy string
    // X0 now contains new string
    BL List_push        // insert the copied string into the linked list
.endr

    MOV X0,#1           // load index of string to delete 
    BL List_erase       // erase string at index 3
    
    LDR X0,=str3            // load address of string
    BL String_toUpperCase   // convert string to uppercase
    MOV X1,X0               // move string to replace with into X1
    MOV X0,#1               // index to replace
    BL List_replace         // replace old string with new string
   
    BL List_print       // print list
    BL List_clear       // clear list

end:
    MOV X0,#0           // load 0, program exited correctly
    MOV X8,#93          // load code to terminate program
    SVC 0               // call to linux to terminate
    .end
