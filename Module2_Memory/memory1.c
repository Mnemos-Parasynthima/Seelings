#include <stdio.h>


/**
 * There is an error. It will compile and work but something is wrong, it is not printing as expected.
 */


int* someFunc() {
  int a = 20;
  int b = 5;

  int c = a + b;
  int* cPtr = &c;

  return cPtr;
}

int* useStack() {
  int a,b,c;
  a = b = c = 3;
  int* ptr = &c;

  return ptr;
}

int main(void) {
  int* someLoc = someFunc();

  useStack();

  printf("%d\n", *someLoc);
}