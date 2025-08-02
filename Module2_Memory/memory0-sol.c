#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(void) {
  /**
   * TODO!
   * The stack string needs to be "I'm in the stack!" while the heap string needs to be "I'm in the heap!"
   */
  
  char stackStr[] = "I'm in the stack!";
  char* heapStr = NULL;

  heapStr = malloc(sizeof(char) * 17);
  strcpy(heapStr, "I'm in the heap!");

  printf("Stack string: %s\nHeap string: %s\n", stackStr, heapStr);

  // Remember to free heap allocated!!
  free(heapStr);

  return 0; 
}