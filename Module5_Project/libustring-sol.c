#include <stdlib.h>
#include <stdio.h>


/**
 * Gets the length of the given string, not including the null terminator in the count.
 * @param str A null-terminated string
 * @return Length of the string
 */
size_t ustrlen(const char* str) {
	size_t len = 0;

	char* temp = (char*) str;
	while (*temp != '\0') {
		len++;
		temp++;
	}

	return len;
}

#include <string.h>
/**
 * Compares two string lexicographically until the length of the shortest string.
 * If both are equal, 0 is returned, if str1 is greater, 1 is returned, if str2 is greater, -1 is returned.
 * @param str1 First null-terminated string
 * @param str2 Second null-terminated string
 * @return 0 if equal, 1 if src1 greater, otherwise -1
 */
int ustrcmp(const char* str1, const char* str2) {
	return strcmp(str1, str2);
}


char* ustrcat(char* dst, const char* str) {
	return strcat(dst, str);
}


char* ustrcpy(char* dst, const char* str) {
	return strcpy(dst, str);
}