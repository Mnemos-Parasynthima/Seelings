#include <stdio.h>


/**
 * There is an error. It will compile and run but the output is not as expected.
 */

union Data {
  char byte;
  short hword;
  int word;
};

typedef enum {
  BYTE,
  HWORD,
  WORD
} data_t;

void setData(union Data* dataU, data_t type, void* data) {
  switch (type) {
    case BYTE:
      dataU->byte = (char) data;
      break;
    case HWORD:
      dataU->hword = (short) data;
      break;
    case WORD:
      dataU->word = (int) data;
      break;
  }
}

int main(void) {
  union Data data;

  setData(&data, WORD, (void*) 0x0ffefafe); // DO NOT REMOVE
  printf("Data word is 0x%x\n", data.word);

  setData(&data, BYTE, (void*) 0x20); // DO NOT REMOVE
  printf("Data byte is 0x%x\n", data.byte);

  return 0;
}