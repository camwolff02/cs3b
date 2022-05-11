// strlength
// Subrouting strlength returns an int which represents the num
// of characters (length) in a given string, including white spaces.
// X0: Points to the first byte of a CString
// LR: Contains the return address

// Returned register contents:
// All AAPCS registers are preserved.
//	X0, X1, X2, and X7 are modified and not preserved

	.data

	.global strlength	// Provide program starting address

	.text
strlength:
	// AAPCS REGISTERS ARE PRESERVED BECAUSE THEY WERE NOT USED

	MOV 	X7, X0		// point to first digit (leftmost)
	MOV 	X2, #0		// counter

topLoop:
	LDRB 	W1,[X7],#1	// Indirect addressing X1 = 'X0
	CMP	W1,#0		// if (W1 == NULL character)
	BEQ	botLoop		// jump to bottom of subroutine
	ADD	X2,X2,#1	// increment counter by 1
	B	topLoop		// branch to top of loop

botLoop:
	MOV	X0,X2		// X0 = length of the CString

	// we would pop in reverse order here if we had pushed any

	RET	LR	// return to caller
	.end

substring1:
        STP     X0,X1, [SP,#-16]!       // PUSH input string and beginning value
        SUB     X0,X2,X1                // find length of new string
        STP     X2,X0, [SP,#-16]!       // push ending value and length of new string
        BL      malloc                  // allocate string with length in X5
        LDP     X2,X5, [SP],#16         // POP ending value and new length
        LDP     X4,X1, [SP],#16         // POP input string and starting value
        STR     X0, [SP,#-16]!          // PUSH output string initial address to stack
		ADD 	X4,X4,X1  				// increment starting address to correct index	
end:
        CMP     X5,#0           // test if reached the end of the substring
        BEQ     return          // if so, branch to end
        LDRB    W6,[X4],#1      // load character and incr ptr
        STRB    W6,[X0],#1      // store character and inc ptr
        SUB     X5,X5,#1        // X5 = X5 - 1
        B       end             // branch to top of loop

return:
        LDR     X0,[SP],#16             // POP output string from stack
        RET     LR      // return to caller
        .end