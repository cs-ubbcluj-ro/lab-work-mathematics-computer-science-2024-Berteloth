%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

typedef struct {
    char name[32];
    char type[16];
    int scope;
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;


char lastType[16] = "unknown";  // Initialize to "unknown"
int X = 0;  // Counter for separators


void addSymbol(char *name, char *type, int scope) {
    if (symbolCount < MAX_SYMBOLS) {
        strcpy(symbolTable[symbolCount].name, name);
        strcpy(symbolTable[symbolCount].type, type);
        symbolTable[symbolCount].scope = scope;
        symbolCount++;
    } else {
        printf("Symbol table full!\n");
    }
}

%}


%%
"#[a-zA-Z_][a-zA-Z0-9_]*" {
    printf("PREPROCESSOR DIRECTIVE: %s\n", yytext);
}
[ \t\n]+ ;  // Ignore whitespace


"if"|"else"|"while"|"for"|"break"|"return"|"int"|"double"|"char"|"bool"|"using"|"namespace"|"cout"|"cin"|"main" {
    printf("RESERVED WORD: %s\n", yytext);
    // Add to symbol table if it's a variable declaration
    if (strcmp(yytext, "int") == 0 || strcmp(yytext, "double") == 0 ||
        strcmp(yytext, "char") == 0 || strcmp(yytext, "bool") == 0) {
        strcpy(lastType, yytext); // Remember the last declared type
    }
}


[0-9]+ {
    printf("CONSTANT: %s\n", yytext);
}


[A-Za-z_][A-Za-z0-9_]* {
    printf("IDENTIFIER: %s\n", yytext);
    addSymbol(yytext, lastType, 0);  // Add identifier to symbol table with the last known type
}


"==" { printf("OPERATOR: %s\n", yytext); }
"!=" { printf("OPERATOR: %s\n", yytext); }
"<=" { printf("OPERATOR: %s\n", yytext); }
">=" { printf("OPERATOR: %s\n", yytext); }
"<"  { printf("OPERATOR: %s\n", yytext); }
">"  { printf("OPERATOR: %s\n", yytext); }
"+"  { printf("OPERATOR: %s\n", yytext); }
"-"  { printf("OPERATOR: %s\n", yytext); }
"*"  { printf("OPERATOR: %s\n", yytext); }
"/"  { printf("OPERATOR: %s\n", yytext); }
"%"  { printf("OPERATOR: %s\n", yytext); }
"="  { printf("OPERATOR: %s\n", yytext); }
"<<" { printf("OPERATOR: %s\n", yytext); }
">>" { printf("OPERATOR: %s\n", yytext); }


"{"  { printf("SEPARATOR: %s\n", yytext); X++; }
"}"  { printf("SEPARATOR: %s\n", yytext); X++; }
"("  { printf("SEPARATOR: %s\n", yytext); X++; }
")"  { printf("SEPARATOR: %s\n", yytext); X++; }
"["  { printf("SEPARATOR: %s\n", yytext); X++; }
"]"  { printf("SEPARATOR: %s\n", yytext); X++; }
";"  { printf("SEPARATOR: %s\n", yytext); X++; }
":"  { printf("SEPARATOR: %s\n", yytext); X++; }
","  { printf("SEPARATOR: %s\n", yytext); X++; }
"?"  { printf("SEPARATOR: %s\n", yytext); X++; }

%%


int main(void) {
    yyin = fopen("mycode.txt", "r");  
    if (!yyin) {
        perror("Failed to open input file");
        return 1;
    }
    yylex();  

    printf("\nTotal separators found: %d\n", X);  

    
    printf("\nSymbol Table:\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("Name: %s, Type: %s, Scope: %d\n", symbolTable[i].name, symbolTable[i].type, symbolTable[i].scope);
    }

    return 0;
}

int yywrap() {
    return 1;
}
