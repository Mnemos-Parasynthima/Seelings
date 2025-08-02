#include <stdio.h>


char setFlags(char flags, char bits) {
  /**
   * TODO!
   * Set the given bits on flags
   */

	return flags | bits;
}

char clearFlags(char flags, char bits) {
  /**
   * TODO!
   * Clear the given bits on flags
   */

	 return flags ^ bits;
}

int encodeAddImm(int xs, int xd, int imm) {
  /**
   * TODO!
   * Encode the add imm instruction given the source register xs, destination register xd, and immediate imm
   */

	return (0b10010000 << 24) | (imm << 10) | (xs << 5) | (xd << 0);
}

int extractOpcode(int insnbits) {
  /**
   * TODO!
   * Extract the opcode from the instruction bits
   */

	return (insnbits >> 25) & 0b1111111;
}

int main(void) {
  /**
   * CONZ flags layout
   * | 7-4 | 3 | 2 | 1 | 0 |
   * |  x  | C | O | N | Z |
   * C: Carry; O: Overflow; N: Negative; Z: Zero
   */
  
  char CONZ = 0b0101;

  // Set the carry and negative flags
  CONZ = setFlags(CONZ, 0b1010);

  // Clear the overflow and zero flags
  CONZ = clearFlags(CONZ, 0b101);

  printf("CONZ flags: 0x%x\n", CONZ);

  // Encode a subtract instruction with an immediate of 20, destination register as x2, and source register as x5
  // `2` is the representation of x2, `5` is the representation of x5
  // An add instruction is in the form of:
  // | opcode    | 0 | immediate (14) | source (5) | destination (5) | 
  // | 0b1001000 | 0 | xxxxxxxxxxxxxx |   xxxxx    |       xxxxx     |
  int insnbits = encodeAddImm(5, 2, 20);

  printf("Encoded instruction is: 0x%x\n", insnbits);

  // Get the opcode
  int opcode = extractOpcode(insnbits);

  printf("Opcode is: 0x%x\n", opcode);

  return 0;
}