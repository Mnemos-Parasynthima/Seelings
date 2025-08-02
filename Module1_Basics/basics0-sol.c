#include <stdio.h>
#include <stdlib.h>

void printString0(const char* str) {
	char* temp = str;

  for (; *temp != '\0'; temp++) printf("%c", *temp);

  printf("\n");
}

void printString1(const char* str, size_t len) {
  for (int i = 0; i < len; i++) {
		printf("%c", str[i]);
	}

  printf("\n");
}


int main() {
  const char str[] = "Print me!";

  printString0(str);
  printString1(str, 9);

  return 0;
}