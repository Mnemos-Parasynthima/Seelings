#include <stdio.h>
#include <stdlib.h>


#define ALLOC_SIZE 11 // DO NOT CHANGE THIS

long ugetline(char** lineptr, long* n, FILE* stream) {
  /**
   * TODO!
   * ugetline reads a line from a stream. That is, it reads up until a newline character.
   * This allocate memory depending on the length. Make it so it properly allocates, updates,
   * and marking it as a string.
   */


  char chr;
  char* temp = NULL;
  int length = 0;


  chr = getc(stream);

  *lineptr = malloc(ALLOC_SIZE);
  *n = ALLOC_SIZE;

  while (chr != EOF) {
    if (length + 1 >= *n) {
      long newsize = *n + (*n >> 2);
      if (newsize < ALLOC_SIZE) newsize = ALLOC_SIZE;

    }

    ((unsigned char*) *lineptr)[length++] = chr;

    if (chr == '\n') break;

    chr = getc(stream);
  }

  return (long) length;
}

int main(void) {
  char* name = NULL;
  char* quote = NULL;
  long n0 = 0;
  long n1 = 0;

  /**
   * TODO!
   * Name: Chi
   * Quote: And then there were none
   */

  long namelen = ugetline(&name, &n0, stdin);

  long quotelen = ugetline(&quote, &n1, stdin);

  printf("Name is: %s\n", name);
  printf("Their quote is: \"%s\"\n", quote);
  printf("Allocated %ld for name and %ld for quote\n", n0, n1);

  return 0;
}