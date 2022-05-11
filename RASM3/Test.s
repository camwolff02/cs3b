    .data
szHello:    .asciz "Hello Wello\n"
szFind:     .asciz "ell"
szNL:       .asciz "\n"
szIndex:    .skip 16

    .global _start
    .text

// given an int in X0, convert to string and print
int_print:
    STR LR,[SP,#-16]!       // PUSH return address
    LDR X1,=szIndex         // load address to store index string
    BL  int64asc            // convert integer to string
    LDR X0,=szIndex         // load address to print integer
    BL  putstring           // output string
    LDR X0,=szNL            // load newline
    BL  putstring           // output string
    LDR LR,[SP],#16         // POP return address
    RET                     // return to caller

_start:
    // CONTROL
    LDR X0,=szHello         // load address of string to print
    BL putstring            // output string
    LDR X0,=szFind          // load address of find string to print
    BL  putstring           // output string
    LDR X0,=szNL            // load address of newline string to print
    BL  putstring           // output string

    // TEST indexOf_1
    LDR X0,=szHello         // load address of string to search
    MOV X1,#'W'             // load character to find
    BL  String_indexOf_1    // find index
    BL  int_print           // print index
    
    // TEST indexOf_2
    LDR X0,=szHello         // load address of string to search
    MOV X1,#'o'             // load character to find
    MOV X2,#4               // load index to search from
    BL  String_indexOf_2    // find index
    BL  int_print           // print index

    // TEST indexOf_3
    LDR X0,=szHello         // load address of string to search
    LDR X1,=szFind          // load address of string to find
    BL  String_indexOf_3    // find index
    BL  int_print           // print index
    
    
    // TEST lastIndexOf_1
    LDR X0,=szHello             // load address of string to search
    MOV X1,#'l'                 // load character to find
    BL  String_lastIndexOf_1    // find index
    BL  int_print               // print index

    // TEST lastIndexOf_2
    LDR X0,=szHello             // load address of string to search
    MOV X1,#'l'                 // load character to find
    MOV X2,#8                   // load index to search from
    BL  String_lastIndexOf_2    // find index
    BL  int_print               // print index
    
    // TEST lastIndexOf_3
    LDR X0,=szHello             // load address of string to search
    LDR X1,=szFind              // load address of string to find
    BL  String_lastIndexOf_3    // find index
    BL  int_print               // print index

    //TEST concat
    LDR X0,=szFind          // load address of first string
    LDR X1,=szHello         // load address of second string
    BL  String_concat       // concatenate 2 strings 
    STR X0,[SP,#-16]!       // store address
    BL putstring            // output string
    LDR X0,[SP],#16         // load address
    BL  free                // free address

    // TEST replace
    LDR X0,=szHello         // load address of string to replace
    MOV X1,#'e'             // load char to be replaced
    MOV X2,#'a'             // load char to replace with
    BL String_replace       // replace characters in string
    STR X0,[SP,#-16]!       // store address
    BL  putstring           // output address
    LDR X0,[SP],#16         // load address
    BL  free                // free address    

    // TEST toUpperCase
    LDR X0,=szHello         // load address of string to convert
    BL  String_toUpperCase  // convert string, store result address in X0
    STR X0,[SP,#-16]!       // store address
    BL  putstring           // output string
    LDR X0,[SP],#16         // load address
    BL  free                // free address
    
    // TEST toLowerCase
    LDR X0,=szHello         // load address of string to convert
    BL  String_toLowerCase  // convert string, store result address in X0
    STR X0,[SP,#-16]!       // store address
    BL  putstring           // output string
    LDR X0,[SP],#16         // load address
    BL  free                // free address
    
end:
    MOV X0,#0
    MOV X8,#93
    SVC 0
    .end
