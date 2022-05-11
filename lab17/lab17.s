// ld -o lab17 /usr/lib/aarch64-linux-gnu/libc.so ./lab17.o ./string.a ./prof_b.a -dynamic-linker /lib/ld-linux-aarch64.so.1
// Programmer: Cameron Wolff
// Lab: Lab 17
// Purpose: Create a Singly Linked List
// Date: May 2, 2022

    .data
// String Literals
str1:       .asciz "The Cat in the Hat\n"
str2:       .asciz "\n"
str3:       .asciz  "By Dr. Seuss\n"
str4:       .asciz  "\n"
str5:       .asciz "The sun did not shine.\n"
// Variables
headPtr:    .quad  0    // pointer to start node of linkedlist
tailPtr:    .quad  0    // pointer to end node of linkedlist

    .global _start
    .text
_start:
    // -------------------------------
    // | &data (quad) | &next (quad) |
    // -------------------------------
    // So the first data element (&data) is the address from the heap where our string is stored.
    // The second data element (&next) is the address from the head where the next node in the linked list is stored.
    // Now these are actually data labels in our .data segment, but rather used to facilitate transitioning from the
    // logical implementation of Linked List to is actual implementation as it is built.
    // The normal process would go something like this:

.irpc num, 12345
    // Step 1. malloc/copy the static string (one at time).
    // Step 1a. Get the length of the string (+1 to account for the null at the end)
    // Step 1b. Pass the length to malloc, and copy the string into the new malloc'd string. You have to remember where this is
    //         is so its probably best to store in a label or temp register.
    LDR  X0,=str\num    // load string to copy
    BL   String_copy    // call function to copy string
    STR  X0,[SP,#-16]!  // PUSH new string address

    // Step 2. Create the new node.
    // Step 2a. Malloc 16 bytes (8 bytes for the &data element and 8 bytes for the &next element) for the newNode.
    MOV  X0,#16         // load 16 bytes (length of 2 pointers, or 1 node)
    BL   malloc         // allocate memory for node

    // Step 2b. Store the address of previously malloc'd string in the newNode along with setting the next element to null.
    LDR  X1,[SP],#16    // POP copied string from the stack
    MOV  X3,X0          // save new node address 
    STR  X1,[X0],#8     // store address of malloced string to the node data, increment to &next
    MOV  X1,#0          // move null value into X1
    STR  X1,[X0]        // store null character in &next to indicate end of linked list
    MOV  X0,X3          // load new node address 

    // Step 2c. Insert the newNode into the linked list.
    LDR  X1,=tailPtr    // load double pointer to end node of linked list
    LDR  X2,[X1]        // load pointer to end node of linked list
    STR  X0,[X1]        // store new node address in tailPtr, new node is new end
    LDR  X1,=headPtr    // load double pointer to head
    LDR  X1,[X1]        // load pointer to head
    CMP  X1,#0          // if we don't currently have a head (head == null)
    B.EQ 1f             // make new node head

    // else, if head node is already initialized
    STR  X0,[X2,#8]     // store new node as old last node's next
    B    2f             // node has been added

1:  // no head, add node as head
    LDR  X1,=headPtr    // load address of head pointer
    STR  X0,[X1]        // point head to new node
2:  // node added successfully
.endr

    // Step 3. After you have stored all 5 strings in this manner, traverse the linked list and print its strings. Ensure that 
    //         you put a carriage return/new line at the end of each string.
    LDR X0,=headPtr     // load double pointer to start node of list
    LDR X0,[X0]         // load pointer to start node of list

loop:
    CMP X0,#0           // if we are pointing to a nullptr
    B.EQ end_loop       // end loop

    STR X0,[SP,#-16]!   // PUSH current node ptr 
    LDR X0,[X0]         // load address of string at this node
    BL  putstring       // call string output function
    LDR X0,[SP],#16     // POP current node ptr
    LDR X0,[X0,#8]      // load next node ptr
    B loop              // continue loop
end_loop:

    // Step 4. (optional) Traverse your list a free everything.
    LDR X0,=headPtr     // load double pointer to start node of list
    LDR X0,[X0]         // load pointer to start node of list

free_loop:
    CMP X0,#0           // if we are pointing to a nullptr
    B.EQ end_free_loop  // end loop

    LDR X1,[X0]             // load string at current node
    LDR X2,[X0,#8]          // load next node ptr
    STP X1,X2,[SP,#-16]!    // PUSH string ptr and next node ptr 
    BL  free                // free current node
    LDP X0,X1,[SP],#16      // POP string ptr and next node ptr
    STR X1,[SP,#-16]!       // PUSH next node ptr 
    BL  free                // free current string
    LDR X0,[SP],#16         // POP next node ptr
    B   free_loop           // continue looping and freeing
end_free_loop:

end:
    MOV X0,#0       // load 0, program exited correctly
    MOV X8,#93      // load code to terminate program
    SVC 0           // call to linux to terminate
    .end
