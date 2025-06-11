#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(void) {
  /**
   * TODO!
   * The stack string needs to be "I'm in the stack!" while the heap string needs to be "I'm in the heap!"
   */
  
  char stackStr[];
  char* heapStr = NULL;

  printf("Stack string: %s\nHeap string: %s", stackStr, heapStr);

  // Remember to free heap allocated!!

  return 0; 
}