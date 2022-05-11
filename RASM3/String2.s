    .global String_toLowerCase
    .global String_toUpperCase
    .global String_indexOf_1
    .global String_indexOf_2
    .global String_indexOf_3
    .global String_lastIndexOf_1
    .global String_lastIndexOf_2
    .global String_lastIndexOf_3
    .global String_concat
    .global String_replace
    .text

// Assembler program to find the index of a specified character in a given 
// string
//
// input:
// X0 - address of string to search
// X1 - character to find
// output:
// X0 - integer index 
String_indexOf_1:
    STR LR,[SP,#-16]!       // PUSH return address
    MOV X2,#-1              // start string search at beginning
    BL  String_indexOf_2    // perform index search
    LDR LR,[SP],#16         // POP return address
    RET                     // return to calling function



// Assembler program to find the index of a specified character in a given 
// string after the specified index
//
// input:
// X0 - address of string to search
// X1 - character to find
// X2 - index to start search
// output:
// X0 - integer index
String_indexOf_2:
    STR X0,[SP,#-16]!       // PUSH init string address for index calculation
    ADD X0,X0,X2            // move pointer to search starting index
    ADD X0,X0,#1            // skip index we are given
loop_indexOf_2:
    LDRB W2,[X0],#1         // load current character and increment string ptr
    CMP  W2,#0              // if current char == null terminator
    B.EQ err_indexOf_2      // error, reached end with char not found
    CMP  W2,W1              // if current char == input char
    B.EQ found_indexOf_2    // we found the correct index
    B    loop_indexOf_2     // else, continue loop
found_indexOf_2:
    LDR X1,[SP],#16         // POP init string address
    SUB X0,X0,X1            // return initAddress - charAddress (index)
    SUB X0,X0,#1            // subtract 1 to account for starting index of 0
    RET                     // return to calling function 
err_indexOf_2:
    ADD SP,SP,#16           // POP init string address (preserve SP)
    MOV X0,#-1              // return -1, no instance of character found
    RET                     // return to calling function



// Assembler program to find the index of a specified string in a given string
//
// input:
// X0 - address of string to search
// X1 - address of string to find
// output:
// X0 - integer index
String_indexOf_3:
    STR  X0,[SP,#-16]!      // PUSH init string address for index calculation
    LDRB W3,[X1],#1         // load first character of find str and inc ptr
loop_indexOf_3:
    LDRB W2,[X0],#1         // load current character and increment string ptr
    CMP  W2,#0              // if current char == null terminator
    B.EQ err2_indexOf_3     // error, reached end with char not found
    CMP  W2,W3              // if current char == first char of find str
    B.EQ foundCh_indexOf_3  // we found the correct index
    B    loop_indexOf_3     // else, continue loop

// Found first char, loop to find whole string
foundCh_indexOf_3:
    STP  X0,X1,[SP,#-16]!   // PUSH current index ptr and find string address
loopf_indexOf_3:
    LDRB W2,[X0],#1         // load character of search str and increment ptr
    LDRB W4,[X1],#1         // load character of find str and increment ptr
    CMP  W4,#0              // if we are at end of find str
    B.EQ foundStr_indexOf_3 // we have found the correct index
    CMP  W2,#0              // else if we are at end of search str
    B.EQ err1_indexOf_3     // error, reached end of string with no solution
    CMP  W2,W4              // if both current characters are the same
    B.EQ loopf_indexOf_3    // continue searching substring
    // else if both characters are different
    LDP X0,X1,[SP],#16      // POP to restore index ptr and find string address
    B   loop_indexOf_3     // continue looping through search string

// found whole string, return
foundStr_indexOf_3:
    LDP X0,X1,[SP],#16      // POP index ptr and (garbage) find string address
    LDR X1,[SP],#16         // POP init string address
    SUB X0,X0,X1            // return initAddress - charAddress (index)
    SUB X0,X0,#1            // subtract 1 to account for starting index of 0
    RET                     // return to calling function 

// no string found, return
err1_indexOf_3:
    ADD SP,SP,#16           // POP index ptr and string address (preserve SP)
err2_indexOf_3:
    ADD SP,SP,#16           // POP init string address (preserve SP)
    MOV X0,#-1              // return -1, no instance of character found
    RET                     // return to calling function



// Assembler program to find the last index of a specified character in a given 
// string
//
// input:
// X0 - address of string to search
// X1 - character to find
// output:
// X0 - integer index
String_lastIndexOf_1:
    STR LR,[SP,#-16]!           // PUSH return address
    STP X0,X1,[SP,#-16]!        // PUSH parameters
    BL  strlength               // find string length
    MOV X2,X0                   // move length to an unused register
    LDP X0,X1,[SP],#16          // POP parameters
    BL String_lastIndexOf_2     // find last index from end of string
    LDR LR,[SP],#16             // POP return address
    RET                         // return to calling function



// Assembler program to find the last index of a specified character in a given
// string looking backwards from a specified index
//
// input:
// X0 - address of string to search
// X1 - character to find
// X2 - index to start search
// output:
// X0 - integer index
String_lastIndexOf_2:
    ADD X2,X2,X0                // change last index to pointer
    SUB X2,X2,#1                // subtract 1 to skip char at given index
loop_lastIndexOf_2:
    CMP  X2,X0                  // if string ptr < string[0]
    B.LT err_lastIndexOf_2      // error, reached beginning with char not found  
    LDRB W3,[X2],#-1            // load current char and decrement string ptr  
    CMP  W3,W1                  // if current char == input char
    B.EQ found_lastIndexOf_2    // we found the correct index
    B    loop_lastIndexOf_2     // else, continue loop
found_lastIndexOf_2:
    ADD X2,X2,#1                // add 1 to account for decremented pointer
    SUB X0,X2,X0                // index = string[0] - string[char address]
    RET                         // return to calling function
err_lastIndexOf_2:
    MOV X0,#-1                  // return -1, no instance of char found
    RET                         // return to calling function



// Assembler program to find the last index of a specified string in a given 
// string
//
// input:
// X0 - address of string to search
// X1 - address of string to find
// local:
// X2 - last address of string to search
// X3 - last address of string to find
// X4 - last char of string to find
// X5 - current char we are exploring
// output:
// X0 - integer index
String_lastIndexOf_3:
    // find last char of search string
    STR LR,[SP,#-16]!           // PUSH return address
    STP X0,X1,[SP,#-16]!        // PUSH parameters
    BL  strlength               // find searchstring length
    MOV X2,X0                   // move length to an unused register
    SUB X2,X2,#1                // change length to last index
    LDP X1,X0,[SP],#16          // POP parameters
    ADD X2,X2,X1                // change last index to pointer to last index
    LDR LR,[SP],#16             // POP return address
    // find last char of find string
    STP LR,X2,[SP,#-16]!        // PUSH return address and last address
    STP X1,X0,[SP,#-16]!        // PUSH parameters
    BL  strlength               // find find string length
    MOV X3,X0                   // move length to an unused register
    SUB X3,X3,#1                // change length to last index
    LDP X0,X1,[SP],#16          // POP parameters
    ADD X3,X3,X1                // change last index to pointer to last index
    LDP LR,X2,[SP],#16          // POP return address
    LDRB W4,[X3],#-1            // load last character of find str and dec ptr
loop_lastIndexOf_3:
    CMP  X2,X0                  // if string ptr < string[0]
    B.LT err2_lastIndexOf_3     // error, reached beginning with char not found    
    LDRB W5,[X2],#-1            // load current char and decrement string ptr
    CMP  W4,W5                  // if current char == last char of find str
    B.EQ foundCh_lastIndexOf_3  // we found the correct index
    B    loop_lastIndexOf_3     // else, continue loop
foundCh_lastIndexOf_3:
    STP X2,X3,[SP,#-16]!        // PUSH search indecis of the two strings
loopf_lastIndexOf_3:
    CMP  X3,X1                  // if current find index < start index
    B.LT foundStr_lastIndexOf_3 // we have found the entire string
    CMP  X2,X0                  // if current search index < start index
    B.LT err1_lastIndexOf_3     // error, string not found. Exit function
    // else, continue searching
    LDRB W5,[X2],#-1            // load current search char and decrement ptr           
    LDRB W6,[X3],#-1            // load current find char and decrement ptr
    CMP  W5,W6                  // if search and find characters are the same
    B.EQ loopf_lastIndexOf_3    // keep looping and searching
    // else, if they are different
    LDP X2,X3,[SP],#16          // POP search indecis of the two strings
    B loop_lastIndexOf_3        // keep searching whole string 
foundStr_lastIndexOf_3:
    ADD SP,SP,#16               // POP search index of two strings (preserve SP)
    ADD X2,X2,#1                // add 1 to account for decremented pointer
    SUB X0,X2,X0                // index = string[0] - string[char address]
    RET                         // return to calling function
err1_lastIndexOf_3:
    ADD SP,SP,#16               // POP search index of two strings (preserve SP)
err2_lastIndexOf_3:
    MOV X0,#-1                  // return -1, no instance of char found
    RET                         // return to calling function

// find string is only 1 character long
char_lastIndexOf_3:
    MOV W1,W4                   // move last character into argument 
    STR LR,[SP,#-16]!           // PUSH return address
    BL  String_lastIndexOf_1    // find last index of character
    LDR LR,[SP],#16             // POP return address
    RET                         // return to calling function


// Assembler program to append the specified string at the end of the given 
// string and returns the combined string
//
// input:
// X0 - address of given string (str0)
// X1 - address of specified string (str1)
// output:
// X0 - address of new concatenated string
String_concat:
    // allocate memory for new string
    STP LR,X0,[SP,#-16]!    // PUSH return address and str0 
    STR X1,[SP,#-16]!       // PUSH str1
    BL  strlength           // get length of str0 in X0
    MOV X1,X0               // move str0.length to X1
    LDR X0,[SP],#16         // POP str1 
    LDP X0,X1,[SP,#-16]!    // PUSH str1 and str0.length to stack
    BL  strlength           // get length of str1 in X0
    LDP X1,X2,[SP],#16      // POP str1 and str0.length from stack
    ADD X0,X0,X2            // add string lengths together
    ADD X0,X0,#1            // add 1 for null terminator
    STR X1,[SP,#-16]!       // PUSH str1 
    BL  malloc              // allocate memory for new string
    LDR X2,[SP],#16         // POP str1
    LDP LR,X1,[SP],#16      // POP return address and str0
    STP LR,X0,[SP,#-16]!    // PUSH new string for return
// write str0 to new string
str0_concat:   
    LDRB W3,[X1],#1         // load character of str0 and inc ptr
    CMP  W3,#0              // if current char == null terminator
    B.EQ str1_concat        // start writing str1, we are done with str0
    // else, if we are not at end of str0
    STRB W3,[X0],#1         // store character of str0 to new string and inc ptr
    B    str0_concat        // continue loop
// write str1 to new string
str1_concat:
    LDRB W3,[X2],#1         // load character of str1 and inc ptr
    CMP  W3,#0              // if current char == null terminator
    B.EQ end_concat         // end function, we have added both
    // else, if we are not at end of str1
    STRB W3,[X0],#1         // store character of str1 to new string and inc ptr
    B    str1_concat        // continue loop
end_concat:
    LDP LR,X0,[SP],#16      // POP new string address
    RET                     // return to calling function



// Assembler program to replace all occurrences of a specified character in a
// given string with another specified character and returns the new string
//
// input:
// X0 - address of string to modify
// X1 - old character
// X2 - new character
// output:
// X0 - address of new replaced string
String_replace:
    STP LR,X0,[SP,#-16]!    // PUSH return address and modify string
    STP X1,X2,[SP,#-16]!    // PUSH old and new character
    BL  strlength           // find length of input string
    ADD X0,X0,#1            // add 1 to length to account for null terminator
    BL  malloc              // allocate memory for new string
    LDP X2,X3,[SP],#16      // POP old and new character
    LDP LR,X1,[SP],#16      // POP return address and modify string
    STP LR,X0,[SP,#-16]!    // PUSH address of new replaced string
loop_replace:
    LDRB W4,[X1],#1         // load current character and increment string ptr
    CMP  W4,#0              // if current char == null terminator
    B.EQ end_replace        // we are at end of string, end function
    CMP  W4,W2              // if current char == char to replace
    B.EQ swap_replace       // swap old char for new char
    // else, if current char is not the char we're looking for
    STRB W4,[X0],#1         // store current char to new string and inc ptr
    B loop_replace          // continue loop
swap_replace:
    STRB W3,[X0],#1         // store new char to string and inc ptr
    B loop_replace          // continue loop
end_replace:
    LDP LR,X0,[SP],#16      // POP return address and return string address
    RET                     // return to calling function



// Assembler program to convert a string to all lower case.
//
// input:
// X0 - address of input string
// output:
// X0 - address of output string
String_toLowerCase:
    STP LR,X0,[SP,#-16]!    // PUSH input string to stack
    BL  strlength           // get length of string in X0
    ADD X0,X0,#1            // add 1 to string to make room for null terminator
    BL  malloc              // allocate string with same length
    LDP LR,X1,[SP],#16      // pop input string from stack
    STP LR,X0,[SP,#-16]!    // PUSH output string init address to stack

loop_toLowerCase:
    LDRB W5,[X1],#1         // load character and increase ptr
    CMP  W5,#'Z'            // if letter > 'Z'
    B.GT cont_toLowerCase   // skip iteration
    CMP  W5,#'A'            // if letter < 'A'
    B.LT cont_toLowerCase   // skip iteration
    // if we are here, letter is Lowercase
    ADD W5,W5,#('a'-'A')    // convert upper to lower
cont_toLowerCase:
    STRB W5,[X0],#1         // store character to output str
    CMP  W5,#0              // if we did not hit a null character
    B.NE loop_toLowerCase   // continue loop
    
    LDP LR,X0,[SP],#16      // load output string address and link register
    RET                     // return to calling function



// Assembler program to convert a string to all upper case.
//
// input:
// X0 - address of input string
// X1 - address of output string
// output:
// X0 - length of new string
String_toUpperCase:
    STP LR,X0,[SP,#-16]!    // PUSH input string to stack
    BL  strlength           // get length of string in X0
    ADD X0,X0,#1            // add 1 to string to make room for null terminator
    BL  malloc              // allocate string with same length
    LDP LR,X1,[SP],#16      // pop input string from stack
    STP LR,X0,[SP,#-16]!    // PUSH output string init address to stack

loop_toUpperCase:
    LDRB W5,[X1],#1         // load character and increase ptr
    CMP  W5,#'z'            // if letter > 'z'
    B.GT cont_toUpperCase   // skip iteration
    CMP  W5,#'a'            // if letter < 'a'
    B.LT cont_toUpperCase   // skip iteration
    // if we are here, letter is lowercase
    SUB W5,W5,#('a'-'A')    // convert lower to upper
cont_toUpperCase:
    STRB W5,[X0],#1         // store character to output str
    CMP  W5,#0              // if we did not hit a null character
    B.NE loop_toUpperCase   // continue loop
    
    LDP LR,X0,[SP],#16      // load output string address and link register
    RET                     // return to calling function
    
    .end
