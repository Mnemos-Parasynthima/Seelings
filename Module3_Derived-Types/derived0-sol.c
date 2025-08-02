#include <stdio.h>


/**
 * TODO!
 * Define the symbol table entry (symb_entry_t) and symbol table (SymbolTable), making a global table.
 * An entry is to have:
 * name;
 * value;
 * The table is to have:
 * 5 entries;
 * size;
 */
typedef struct SymbolEntry {
  char* name;
  int value;
} symb_entry_t;

typedef struct SymbolTable {
  symb_entry_t entries[5];
  int size;
} SymbolTable;

SymbolTable symbolTable;

void addEntry(char* name, int value) {
  /**
   * TODO!
   * Properly set an entry and update the symbol table.
   */
  symb_entry_t* entry = &(symbolTable.entries[symbolTable.size]);
  entry->name = name;
  entry->value = value;
  symbolTable.size++;
}

int main(void) {
  addEntry("obj", 0xfe20);
  addEntry("len", 15);
  addEntry("_sy", 0xa0);
  addEntry("buffer", 0xfe40);
  addEntry("_init", 0xfe50);

  printf("Symbols:\n");
  for (int i = 0; i < symbolTable.size; i++) {
    symb_entry_t entry = symbolTable.entries[i];

    printf("Name (%s): Value (0x%x)\n", entry.name, entry.value);
  }
  
  return 0;
}