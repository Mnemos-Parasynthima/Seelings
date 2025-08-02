#include <stdio.h>
#include <stdlib.h>


void fillArray(int* arr) {
  for (int i = 0; i < 10; i++) {
    arr[i] = ((i % 2 == 0) ? 5 : 10);
  }
}

void printArray(int* arr) {
  /**
   * TODO!
   * Print the array WITHOUT using index notation ("[]")
   * Output should be in the form of "[x, x, x, x]\n"
   */

  printf("[");

  int* temp = arr;
  for (int i = 0; i < 9; i++) {
    printf("%d, ", *temp);
    temp++;    
  }

  printf("%d]\n", *temp);
}

int main(void) {
  int* intArr = (int*) malloc(sizeof(int) * 10);
  if (!intArr) exit(-1); // make sure to check allocation is done

  fillArray(intArr);
  
  printArray(intArr);

  free(intArr);
}