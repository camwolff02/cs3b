// Programmer: Dr. Barnett
// Lab 12: 
// Purpose: Demonstrate understanding of stack operations

// Date: 11 Apr 2022

	.global _start	            // Provide program starting address to linker
	.text
_start:

	MOV	X0, #3			//n
	BL		fact

	// Setup the parameters to exit the program
	// and then call Linux to do it.
	mov	X0, #0      // Use 0 return code
    mov   X8, #93      // Service command code 93 terminates this program
    svc   0           // Call linux to terminate the program

	.end
