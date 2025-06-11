#include <stdio.h>


/**
 * The code compiles and works but being limited to only 100 entries is not good. Fix it to make it vary.
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
	data_entry_t* entries[100];
	int size;

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

void addEntry(data_entry_t* entry) {}

data_entry_t* createEntry(data_type_t type, int addr, int size) {}

int main(void) {
	DataTable dataTable = {

		.size = 0,

	};

  data_entry_t entry0 = {
    .type = STRING,
    .addr = 0xee00,
    .size = 5,
    .source = "",
    .data._t = NULL
  };
  char* strData = "Hai?";
  attachData(&entry0, &strData, STRING);


  data_entry_t entry1 = {
    .type = BYTES,
    .addr = 0xff00,
    .size = 8,
    .source = "",
    .data._t = NULL
  }; 
  char byteData[] = {0xaa, 0xb1, 0xa2, 0x2b, 0x3a, 0x4b, 0xef, 0xed};
  attachData(&entry1, &byteData, BYTES);


  data_entry_t entry2 = {
    .type = HALFWORDS,
    .addr = 0xff10,
    .size = 2,
    .source = "",
    .data._t = NULL
  };
  short hwordData[] = {0x1a00, 0xdace};
  attachData(&entry2, &hwordData, HALFWORDS);

  showTable(&dataTable);

	free(entry0.data._t);
	free(entry1.data._t);
	free(entry2.data._t);


  return 0;
}
// FIXME: Note to self, need to add a way to test if it was made as a **, not *[]