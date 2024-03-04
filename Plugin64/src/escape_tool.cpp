#include "pch.h"
#include "escape_tool.h"

// Using UTF-8 directly actually dont use this file anymore

char* escapedStrToUtf8(ParadoxTextObject* from){
	return (char*)from;
}

char* utf8ToEscapedStr3buffer = NULL;
char* utf8ToEscapedStr3(char* from) {
	// init
	if (utf8ToEscapedStr3buffer != NULL) {
		free(utf8ToEscapedStr3buffer);
	}
	strcpy_s(utf8ToEscapedStr3buffer, 1000, from);
	return utf8ToEscapedStr3buffer;
}