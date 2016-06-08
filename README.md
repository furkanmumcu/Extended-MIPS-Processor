# Extended-MIPS-Processor

Adding New Instructions to MIPS Single-Cycle Processor Hardware

This project implements original 10 mips instructions and adds 5 more new instructions.

The Original10 instructions are add, sub, and, or, slt, lw, sw, beq, addi and j.

subi: this I-type instruction subtracts, using a sign-extended immediate value.

sw+: this I-type instruction does the normal store, as expected, plus an increment (by 4, since it is a word transfer) 
of the base address in RF[rs]. 

ll: ll is like other loads, except that it is atomically linked with sc. 

sc: is like other stores, except that it is conditional, and doesn't store to memory address if it has been changed since the ll instruction.

jm: this I-type instruction is a jump, to the address stored in the memory location.

```
"sc":
		IM[PC]
if (ATOMIC_TEST = = DM[RF[rs] + SignExt(Imm)])
			DM[RF[rs] + SignExt(Imm)] <- RF[rt], 
			RF[rt] <- 1
		else 	
RF[rt] <- 0
		PC <- PC + 4

		
		
		
"ll":
		IM[PC]	
RF[rt] <- DM[R[rs] + SignExt(Imm)]
		ATOMIC_TEST <- DM[RF[rs] + SignExt(Imm)]
		PC <- PC + 4

		
		

"sw+":
		IM[PC]
		DM[RF[rs]+SignExt(Imm16)]  RF[rt]
		RF[rs] <- RF[rs]+4
		PC <- PC + 4
```
