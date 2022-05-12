// Structure of node in linked list:
// -------------------------------
// | &data (quad) | &next (quad) |
// -------------------------------

    .global List_push
    .global List_erase
    .global List_replace
    .global List_size
    .global List_empty
    .global List_print
    .global List_clear
    .text

/******************************************************************************/
// push data to the front of the List
//
// input:
// X0 - pointer to data to add to List
List_push:
    STR LR,[SP,#-16]!   // PUSH link register

    // Create the new node
    STR  X0,[SP,#-16]!   // PUSH data
    MOV  X0,#16          // load 16 bytes (length of 2 pointers, or 1 node)
    BL   malloc          // allocate memory for node
    
    // Store the address of data in the new node along with 
    // setting the next element to null
    LDR  X1,[SP],#16    // POP data from the stack
    MOV  X3,X0          // save new node address 
    STR  X1,[X0],#8     // store passed data to node data, increment to &next
    MOV  X1,#0          // move null value into X1
    STR  X1,[X0]        // store null character in &next to indicate end of List
    MOV  X0,X3          // load new node address 

    // Insert the newNode into the linked List
    LDR  X1,=tailPtr    // load double pointer to end node of linked List
    LDR  X2,[X1]        // load pointer to end node of linked List
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
    // increment size, node has been added
    LDR X0,=iSize       // load size address
    LDR X1,[X0]         // load size integer
    ADD X1,X1,#1        // increment 1 (node added)
    STR X1,[X0]         // store new size
    LDR LR,[SP],#16     // POP link register
    RET                 // return to calling function

/******************************************************************************/
// erase element from the list at a given index
//
// input:
// X0 - index to erase
List_erase:
    STR LR,[SP,#-16]!   // PUSH return address
    MOV X3,X0           // move target index to X3
    MOV X2,#0           // set current index to 0
    LDR X0,=headPtr     // load address to head node
    LDR X0,[X0]         // load head node

erase_find:
    CMP  X0,#0           // if current pointer is a nullptr
    B.EQ erase_end       // nothing to erase
    CMP  X2,X3           // if current index == target index to erase
    B.EQ erase_link      // link surrounding nodes so we can safely erase
    
    // else, increment to next node
    ADD X2,X2,#1        // increment index
    ADD X0,X0,#8        // move to &next
    MOV X1,X0           // save previous node pointer (&next, don't need &data)   
    LDR X0,[X0]         // load next node pointer
    B   erase_find      // keep searching for correct index

erase_link:
    // at this point, X0 contains the node to delete, and X1 contains the 
    // previous node. 
    // make X1->next = X0->next, then Delete and free the node in X0 
    ADD  X2,X0,#8       // store X0->next in X2
    LDR  X2,[X2]        // load X0->next
    CMP  X2,#0          // if next node is a nullptr (end of list)
    B.EQ erase_tail     // erase tail
    CMP  X3,#0          // if target index is the first index
    B.EQ erase_head     // erase head
    STR  X2,[X1]        // else, store X0->next in previous node
    B    erase_free     // free current node
erase_head:
    LDR X3,=headPtr     // load pointer to head
    STR X2,[X3]         // store X0->next in head
    B   erase_free      // free current node
erase_tail:
    LDR X3,=tailPtr     // load tail pointer
    SUB X2,X1,#8        // move previous node to start node address (&data) 
    STR X2,[X3]         // store previous node address in tail as new tail

erase_free:
    // now that surrounding nodes are linked, free memory and delete node
    STR X0,[SP,#-16]!   // PUSH current node address to free later
    LDR X0,[X0]         // load string address at current node
    BL  free            // free string at current node
    LDR X0,[SP],#16     // POP current node address to free
    BL  free            // free current node
    // erase successful, so decrease size
    LDR X0,=iSize       // load address to size
    LDR X1,[X0]         // load integer size
    SUB X1,X1,#1        // node removed, decrease size
    STR X1,[X0]         // store new size

erase_end:    
    LDR LR,[SP],#16     // POP return address
    RET                 // return to calling function



/******************************************************************************/
// replace an element in the list
//
// input:
// X0 - index to replace
// X1 - data address to replace it with
List_replace:
    STR LR,[SP,#-16]!   // PUSH return address
    
    STP X0,X1,[SP,#-16]!
    LDP X0,X1,[SP],#16

    MOV X3,X0           // move target index to X3
    MOV X2,#0           // set current index to 0
    LDR X0,=headPtr     // load head address
    LDR X0,[X0]         // load head node

replace_find:
    CMP  X0,#0          // if current pointer is a nullptr
    B.EQ replace_end    // nothing to replace
    CMP  X2,X3          // if current index == target index to erase
    B.EQ replace_node   // replace current node

    // else, increment to next node
    ADD X2,X2,#1        // increment index
    ADD X0,X0,#8        // move to &next
    LDR X0,[X0]         // load next node pointer
    B   replace_find    // keep searching for correct index

replace_node:
    // at this point, X0 = current node, X1 = data to replace with
    STP X0,X1,[SP,#-16]!    // PUSH current node and new data
    LDR X0,[X0]             // load data at current node
    BL  free                // free current node's data
    LDP X0,X1,[SP],#16      // POP curren node and new data
    STR X1,[X0]             // store new data into current node


replace_end:    
    LDR LR,[SP],#16     // POP return address
    RET                 // return to calling function



/******************************************************************************/
// String search. Regardless of case, return all strings that match the substring given.
// Search
List_search:
    STR LR,[SP,#-16]!   // PUSH return address

find_end:
    LDR LR,[SP],#16     // POP return address
    RET                 // return to calling function

/******************************************************************************/
// return the current size of the list
List_size:
    LDR X0,=iSize       // load pointer to size
    LDR X0,[X0]         // load size value
    RET                 // return size



/******************************************************************************/
// return 1 if the list is empty, and 0 otherwise
List_empty:
    LDR X0,=headPtr     // load address of head
    LDR X0,[X0]         // load head node
    CMP X0,#0           // if the head is a nullptr
    B.EQ empty_true     // the list is empty
    // else, the list is not empty
    MOV X0,#0           // return 0, false, list is not empty
    RET                 // return to calling function
empty_true:
    MOV X0,#1           // return 1, true, list is empty
    RET                 // return to calling function



/******************************************************************************/
// print all data in the List
List_print:
    STR LR,[SP,#-16]!   // PUSH link register
    LDR X0,=headPtr     // load double pointer to start node of List
    LDR X0,[X0]         // load pointer to start node of List

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
    LDR LR,[SP],#16     // POP link register
    RET                 // return to calling function



/******************************************************************************/
// traverse the List and free everything.
List_clear:             
    STR LR,[SP,#-16]!       // PUSH link register
    LDR X0,=headPtr         // load double pointer to start node of List
    LDR X0,[X0]             // load pointer to start node of List

free_loop:
    CMP X0,#0               // if we are pointing to a nullptr
    B.EQ end_free_loop      // end loop

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
    // reset member variables
    MOV X1,#0               // load 0 for resetting
    LDR X0,=headPtr         // load head
    STR X1,[X0]             // reset head
    LDR X0,=tailPtr         // load tail
    STR X1,[X0]             // reset tail
    LDR X0,=iSize           // load size
    STR X1,[X0]             // reset size
    LDR LR,[SP],#16         // POP link register
    RET                     // return to calling function
    


    .data
headPtr:    .quad  0    // pointer to start node of linkedList
tailPtr:    .quad  0    // pointer to end node of linkedList
iSize:      .quad  0    // size of the List
    .end
