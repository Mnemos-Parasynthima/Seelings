#include <stdio.h>
#include <stdlib.h>


typedef struct SymbolEntry {
  char* name;
  union {
    char* expr;
    int value;
  };
  int flags;
  // 0x01 for expression address, 0x10 for value address, 0x11 for expression value, 0x00 for value value
} symb_entry_t;

typedef struct SymbolTable {
  symb_entry_t* entries[10];
  int size;
} SymbolTable;

symb_entry_t* initEntry(char* name, char* expr, int value, int flags) {
  /**
   * TODO!
   * Write the "constructor" for the entry struct in accordance to its definition.
   * Note the union of `expr` and `value`.
   */
}

SymbolTable* initSymbTable() {
  /**
   * TODO!
   * Write the "constructor" for the symbol table struct in accordance to its definition.
   */
}

void addEntry(SymbolTable* symbTable, symb_entry_t* entry) {
  symbTable->entries[symbTable->size] = entry;

  symbTable->size++;
}

int main(void) {
  SymbolTable* symbTable = NULL;

  /**
   * The first entry is to contain:
   * name: "_sy"
   * value: 0x20
   * not an expression
   * value
   */
  symb_entry_t* entry0 = initEntry();
  addEntry(symbTable, entry0);

  /**
   * The second entry is to contain:
   * name: "_lab"
   * value: 0xfee0
   * not an expression
   * address
   */
  symb_entry_t* entry1 = initEntry();
  addEntry(symbTable, entry1);

  printf("Symbol table size of %d:\n", symbTable->size);
  printf("Entry 0:\n");
  printf("\tname: %s\n", entry0->name);
  printf("\tvalue: %d\n", entry0->value);
  printf("\tflags: 0x%x\n", entry0->flags);
  printf("Entry 1:\n");
  printf("\tname: %s\n", entry1->name);
  printf("\tvalue: 0x%x\n", entry1->value);
  printf("\tflags: 0x%x\n", entry1->flags);

  // Fix for memory

  return 0;
}