#include <stdio.h>


/**
 * There are multiple errors here. It will not compile.
 */

#define ARR0_LEN 4

int[] arr0 = [2, 4, 6, 8];

int main(void) {
  int arr1Len = 4;
  int arr2Len = 6;

  int[] arr1[len];

  int arr2[6] = {0};

  arr1[2] = arr2[2] = 6;

  int arrT[ARR0_LEN + arr1Len + arr2Len];

  int tLast = arrT[13];
  printf("%d\n", tLast);

  printf("%d, %d\n", arr0[2], arr1[2] + arr2[2]);

  return 0;
}