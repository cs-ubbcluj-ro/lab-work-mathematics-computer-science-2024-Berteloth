%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 1000

typedef struct {
    char name[32];
    char type[16];
    int scope;
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;
int currentScope =0;

char lastType[16] = "unknown";  
int X = 0;  


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


int findSymbol(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

%}


%%
"#[a-zA-Z_][a-zA-Z0-9_]*" {
    printf("PREPROCESSOR DIRECTIVE: %s\n", yytext);
}
[ \t\n]+ ;  


"if"|"else"|"while"|"for"|"break"|"return"|"using"|"namespace"|"cout"|"cin"|"main"|"include"|"iostream"|"std" {
    printf("RESERVED WORD: %s\n", yytext);
}


"int"|"double"|"char"|"bool" {
    printf("RESERVED WORD: %s\n", yytext);
    strcpy(lastType, yytext); 
}


"true" {
    printf("CONSTANT: true\n");
    addSymbol("true", "bool", currentScope); 
}

"false" {
    printf("CONSTANT: false\n");
    addSymbol("false", "bool", currentScope); 
}

"endl" {
    printf("IDENTIFIER: endl\n");
    addSymbol("endl", "unknown", currentScope); 
}


[0-9]+ {
    printf("CONSTANT: %s\n", yytext);
}


[A-Za-z_][A-Za-z0-9_]* {
    printf("IDENTIFIER: %s\n", yytext);
    if (strcmp(lastType, "unknown") != 0) { 
        
        addSymbol(yytext, lastType, currentScope);  
    } else {
        if (findSymbol(yytext) == -1) {
            addSymbol(yytext, "unknown", currentScope); 
        }
    }
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


"{"  { printf("SEPARATOR: %s, scope enterr: %d\n", yytext, currentScope+1); X++; currentScope++; }
"}"  { printf("SEPARATOR: %s, scope exit: %d\n", yytext, currentScope); X++; currentScope--; }
"("  { printf("SEPARATOR: %s\n", yytext); X++; }
")"  { printf("SEPARATOR: %s\n", yytext); X++; }
"["  { printf("SEPARATOR: %s\n", yytext); X++; }
"]"  { printf("SEPARATOR: %s\n", yytext); X++; }
";"  { printf("SEPARATOR: %s\n", yytext); X++; 	strcpy(lastType, "unknown"); }
":"  { printf("SEPARATOR: %s\n", yytext); X++; }
","  { printf("SEPARATOR: %s\n", yytext); X++; }
"?"  { printf("SEPARATOR: %s\n", yytext); X++; }

"//" {printf("COMMENT: %s\n", yytext); X++; }

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
        printf("Position: %d, Name: %s, Type: %s, Scope: %d\n",i+1, symbolTable[i].name, symbolTable[i].type, symbolTable[i].scope);
    }

    return 0;
}

int yywrap() {
    return 1;
}
