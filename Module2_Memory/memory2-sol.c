#include <stdio.h>
#include <stdbool.h>


/**
 * There is an error. It does compile and work but the output is not correct.
 */

int eval(int expr, bool* evaled) {
  if (expr > 5) {
    expr++;
    expr *= 50;

    *evaled = true;

    return expr;
  }

  *evaled = false;

  return -1;
}


int main(void) {
  bool evaled = true;

  int res = eval(2, &evaled);

  printf("Res is %d; evaled: %d\n", res, evaled);
}