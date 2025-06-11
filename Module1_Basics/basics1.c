#include <stdio.h>


/**
 * There is an error here, so it will not compile. Fix it.
 */

int getEquationA(int b, int c) {
  b *= 2;
  c += 10;

  return c + b;
}

int main() {
  int a = 2;
  int b = 5;
  int c = 10;

  int resA = getEquationA(b, c);
  long resB = getEquationB(a, resA, c);


  printf("%ld\n", resB);

  return 0;  
}

long getEquationB(int a, int b, int c) {
  int temp = a + b;
  temp++;

  return temp * c;
}