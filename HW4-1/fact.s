//  fact
//  Subroutine fact: Provided 'n' in X0, returns the result of 
//							factorial(n) in the X0 register. If the result
//							is larger than 64 unsigned, nothing is handled.
//  X0 must be >= 0
//  fact(n) must be able to fit within 64 bits (unsigned)
//  LR: Must contain the return address
//  All registers except
//      X2, X3, X7, are preserved
//  *******************************
//  X0 - Returns the factorial(n)

	.data
	
	.global	fact		//Provide program starting address to linker
	.text

fact:
	// PRESERVE REGISTERS AS PER AAPCS
	STR 	X19, [SP, #-16]!		// PUSH
	STR 	X30, [SP, #-16]!		// PUSH LR

	//....
	// Base Case
	CMP	X0, #0
	BGT	generalCase
	MOV	X0, #1
	B		finished

generalCase:
	MOV	X19, 	X0				// Save n to one of the Registers that AAPCS pushes onto the stack
	SUB	X0, X0, #1			// n = n - 1
	BL		fact
	MUL	X0, X0, X19

	// General Case
	//....

finished:

	// POPPED IN REVERSE ORDER (LIFO)
	LDR 	X30, [SP], #16			// POP
	LDR 	X19, [SP], #16			// POP

	RET		LR				// Return to caller
	.end
	
