#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef enum {
  STRING,
  BYTES,
  HALFWORDS,
  WORDS,
  FLOATS
} data_type_t;

typedef struct DataEntry {
  data_type_t type;
  int addr;
  int size;
  char* source;
  /**
   * TODO!
   * Make it so that only one of the following can exist at a time:
   * string str
   * char array bytes
   * short array hwords
   * int array words
   * float array floats
   * void array _t
   */
    
} data_entry_t;


void showEntry(data_entry_t* dataEntry) {
  printf("Data entry:\n");

  char* typeStr = NULL;
  char* strData = NULL;

  char type = dataEntry->type;
  switch (type) {
    case STRING:
      typeStr = "string";
      strData = dataEntry->data.str;
      break;
    case BYTES:
      typeStr = "bytes";
      break;
    case HALFWORDS:
      typeStr = "halfwords";
      break;
    case WORDS:
      typeStr = "words";
      break;
    case FLOATS:
      typeStr = "floats";
      break;
    default: break;
  }

  printf("\tType: %s\n", typeStr);
  printf("\tAddr: 0x%x\n", dataEntry->addr);
  printf("\tSize: 0x%x\n", dataEntry->size);
  printf("\tSource: %s\n", dataEntry->source);
}

void attachData(data_entry_t* entry, void* data, data_type_t type) {
  /**
   * TODO!
   * Make sure the data gets transferred properly.
   */

  switch (type) {
    case STRING:
      char* strData = (char*) malloc(sizeof(char) * entry->size);
      strcpy(entry->data.str, (char*) data);
      break;
    case BYTES:
      char* byteData = (char*) malloc(sizeof(char) * entry->size);
      memcpy(entry->data.bytes, data, sizeof(char) * entry->size);
      break;
    case HALFWORDS:
      short* hwordData = (short*) malloc(sizeof(short) * entry->size);
      memcpy(entry->data.hwords, data, sizeof(short) * entry->size);
      break;
    case WORDS:
      int* wordData = (int*) malloc(sizeof(int) * entry->size);
      memcpy(entry->data.words, data, sizeof(int) * entry->size);
      break;
    case FLOATS:
      float* floatData = (float*) malloc(sizeof(float) * entry->size);
      memcpy(entry->data.floats, data, sizeof(float) * entry->size);
      break;
    default: break;
  }
}

int main(void) {
  data_entry_t entry0 = {
    .type = STRING,
    .addr = 0xff00,
    .size = 5,
    .source = "",
    .data._t = NULL
  };
  char* strData = "Hi!!";
  attachData(&entry0, &strData, STRING);
  showEntry(&entry0);

  data_entry_t entry1 = {
    .type = BYTES,
    .addr = 0xfe00,
    .size = 8,
    .source = "",
    .data._t = NULL
  }; 
  char byteData[] = {0xa0, 0xa1, 0xa2, 0xa3, 0x3a, 0x45, 0xef, 0xde};
  attachData(&entry1, &byteData, BYTES);
  showEntry(&entry1);

  data_entry_t entry2 = {
    .type = HALFWORDS,
    .addr = 0xfe10,
    .size = 2,
    .source = "",
    .data._t = NULL
  };
  short hwordData[] = {0x1a0a, 0xedfe};
  attachData(&entry2, &hwordData, HALFWORDS);
  showEntry(&entry2);



  return 0;
}