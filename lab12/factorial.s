// Author: Cameron Wolff
// Lab: 12
// Purpose: Write this C++ program in ARM64
// using namespace std;
// int fact(int n) { 
//    if (n==0))
//       return 1; 
//    else
//       return n*fact(n-1);
// }
// Date: 04/06/2021

    .global fact
    .text

// recursive solution (from class example)
// int factorial(int n) - returns n!
fact:  
    // Base Case
    STP LR,X19,[SP,#-16]!   // push LR and n to stack 
    CMP X0,#0               // if (n > 0)
    B.GT generalCase        // continue to general case
    MOV X0,#1               // else return 1
    B finished              // branch to end

generalCase:
    MOV X19,X0              // save n to a register, pushed by AAPCS to stack
    SUB X0,X0,#1            // n = n - 1
    BL fact                 // call fact, then return to mult w/ result
    MUL X0,X0,X19           // n = n * fact(n-1)

finished:
    LDP LR,X19,[SP],#16     // pop LR and n from stack
    RET                     // return to calling function

// NOTE: CODE BELOW IS SCRATCH WORK, NO NEED TO READ IF SHORT ON TIME

/*
// Original solution (similar to iterative)
// int factorial(int n) - returns n!
fact:
    MOV X1,X0           // move n value to X1
    MOV X0,#1           // seed return with value 1
factorial: 
    STR LR,[SP,#-16]!   // push LR to the stack 
    CMP X1,#1           // if (n <= 1)
    B.LE return         // return answer
    
    MUL X0,X0,X1        // return = n+1 * n
    SUB X1,X1,1         // n = n-1
    BL factorial        // repeat
return:
    LDR LR,[SP],#16     // pop LR from stack
    RET                 // return to calling function
*/
