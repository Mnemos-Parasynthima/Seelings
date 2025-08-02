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

  symb_entry_t* entry = malloc(sizeof(symb_entry_t));

  entry->name = name;
  if ((flags & 0x1) == 0x1) entry->expr = expr;
  else entry->value = value;

  entry->flags = flags;

  return entry;
}

SymbolTable* initSymbTable() {
  /**
   * TODO!
   * Write the "constructor" for the symbol table struct in accordance to its definition.
   */

  SymbolTable* symbTable = malloc(sizeof(SymbolTable));

  symbTable->size = 0;

  return symbTable;
}

void addEntry(SymbolTable* symbTable, symb_entry_t* entry) {
  symbTable->entries[symbTable->size] = entry;

  symbTable->size++;
}

int main(void) {
  SymbolTable* symbTable = initSymbTable();

  /**
   * The first entry is to contain:
   * name: "_sy"
   * value: 0x20
   * not an expression
   * value
   */
  symb_entry_t* entry0 = initEntry("_sy", NULL, 0x20, 0x00);
  addEntry(symbTable, entry0);

  /**
   * The second entry is to contain:
   * name: "_lab"
   * value: 0xfee0
   * not an expression
   * address
   */
  symb_entry_t* entry1 = initEntry("_lab", NULL, 0xfee0, 0x10);
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