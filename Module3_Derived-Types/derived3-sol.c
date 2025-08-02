#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/**
 * The code compiles and works but being limited to only 100 entries is not good. Fix it to make it vary.
 * Make sure to free.
 */

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
  union {
    char* str;
    char* bytes;
    short* hwords;
    int* words;
    float* floats;
    void* _t;
  } data;
  
} data_entry_t;

typedef struct DataTable {
	data_entry_t** entries;
	int size;
  int capacity;
} DataTable;


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

void showTable(DataTable* dataTable) {
  printf("Data Table (%d entries):\n", dataTable->size);
  
  for (int i = 0; i < dataTable->size; i++) {
    data_entry_t* entry = dataTable->entries[i];
    showEntry(entry);
  }
}

void attachData(data_entry_t* entry, void* data, data_type_t type) {
  switch (type) {
    case STRING:
      char* strData = (char*) malloc(sizeof(char) * entry->size);
      entry->data.str = strData;
      strcpy(entry->data.str, (char*) data);
      break;
    case BYTES:
      char* byteData = (char*) malloc(sizeof(char) * entry->size);
      entry->data.bytes = byteData;
      memcpy(entry->data.bytes, data, sizeof(char) * entry->size);
      break;
    case HALFWORDS:
      short* hwordData = (short*) malloc(sizeof(short) * entry->size);
      entry->data.hwords = hwordData;
      memcpy(entry->data.hwords, data, sizeof(short) * entry->size);
      break;
    case WORDS:
      int* wordData = (int*) malloc(sizeof(int) * entry->size);
      entry->data.words = wordData;
      memcpy(entry->data.words, data, sizeof(int) * entry->size);
      break;
    case FLOATS:
      float* floatData = (float*) malloc(sizeof(float) * entry->size);
      entry->data.floats = floatData;
      memcpy(entry->data.floats, data, sizeof(float) * entry->size);
      break;
    default: break;
  }
}

void addEntry(data_entry_t* entry, DataTable* dataTable) {
  int size = dataTable->size;

  if (size == dataTable->capacity) {
    dataTable->capacity *= 2;

    data_entry_t** temp = realloc(dataTable->entries, sizeof(data_entry_t*) * dataTable->capacity);

    dataTable->entries = temp;
  }

  int idx = size;
  dataTable->entries[idx] = entry;
  dataTable->size++;
}

data_entry_t* createEntry(data_type_t type, int addr, int size) {
  data_entry_t* entry = malloc(sizeof(data_entry_t));

  entry->type = type;
  entry->addr = addr;
  entry->size = size;
  entry->data._t = NULL;
  entry->source = "";

  return entry;
}

int main(void) {
  data_entry_t** entries = malloc(sizeof(data_entry_t) * 10);

	DataTable dataTable = {
    .entries = entries,
		.size = 0,
    .capacity = 10
	};


  data_entry_t* entry0 = createEntry(STRING, 0xee00, 5);
  char* strData = "Hai?";
  attachData(entry0, &strData, STRING);
  addEntry(entry0, &dataTable);

  data_entry_t* entry1 = createEntry(BYTES, 0xff00, 8);
  char byteData[] = {0xaa, 0xb1, 0xa2, 0x2b, 0x3a, 0x4b, 0xef, 0xed};
  attachData(entry1, &byteData, BYTES);
  addEntry(entry1, &dataTable);

  data_entry_t* entry2 = createEntry(HALFWORDS, 0xff10, 2);
  short hwordData[] = {0x1a00, 0xdace};
  attachData(entry2, &hwordData, HALFWORDS);
  addEntry(entry2, &dataTable);

  showTable(&dataTable);

	free(entry0->data._t);
  free(entry0);
	free(entry1->data._t);
  free(entry1);
	free(entry2->data._t);
  free(entry2);

  free(entries);

  return 0;
}
// FIXME: Note to self, need to add a way to test if it was made as a **, not *[]