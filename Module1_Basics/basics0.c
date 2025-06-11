#include <stdio.h>
#include <stdlib.h>


// DO NOT SIMPLY USE PRINTF


void printString0(const char* str) {
  /**
  * TODO!
  * Print the entire string without using its length.
  */

  printf("\n");
}

void printString1(const char* str, size_t len) {
  /**
  * TODO!
  * Print the entire string.
  */

  printf("\n");
}


int main() {
  const char str[] = "Print me!";

  printString0(str);
  printString1(str, 9);

  return 0;
}