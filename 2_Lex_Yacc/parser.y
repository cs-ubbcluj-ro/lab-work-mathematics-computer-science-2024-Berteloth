%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE* yyin;
void yyerror(const char *s);
extern int yyparse();
extern int yylineno;


void log_production(int prod_number);


%}
%token INCLUDE
%token IDENTIFIER CONSTANT_T FOR BREAK
%token PLUS MINUS MUL DIV MOD ASSIGN CIN COUT IF ELSE WHILE INT MAIN RETURN SEMICOLON
%token LBRACE RBRACE LPAREN RPAREN GT LT GTE LTE EQ NEQ
%token BOOL CHAR STRING DOUBLE
%token RSHIFT LSHIFT
%token STRING_LITERAL
%left PLUS MINUS
%left MUL DIV MOD
%nonassoc LT LTE GT GTE EQ NEQ ELSE
%start Program

%%

Program
    : INCLUDE LT IDENTIFIER GT INT MAIN LPAREN RPAREN LBRACE statement_list RBRACE
        { printf("Program syntactic correct\n"); log_production(1); }
    ;


statement_list
    : /* empty */
        { log_production(2); }
    | statement_list statement
        { log_production(3); }
    ;

statement
    : declare
        { log_production(4); }
    | expr
        { log_production(5); }
    | input_output_statement
        { log_production(6); }
    | compound_statement
        { log_production(7); }
    | if_statement
        { log_production(8); }
    | while_statement
        { log_production(9); }
    | for_statement
        { log_production(10); }
    | return_statement
        { log_production(11); }
    | break
        { log_production(12); }
    ;

declare
    : type IDENTIFIER init SEMICOLON
        { log_production(13); }
    ;

init
    : ASSIGN expr
        { log_production(14); }
    | /* empty */
        { log_production(15); }
    ;

type
    : INT
        { log_production(16); }
    | DOUBLE
        { log_production(17); }
    | CHAR
        { log_production(18); }
    | BOOL
        { log_production(19); }
    ;

expr_statement
    : expr SEMICOLON
        { log_production(20); }
    ;

expr
    : term tail1
        { log_production(21); }
    ;

tail1
    : PLUS term
        { log_production(22); }
    | MINUS term
        { log_production(23); }
    | /* empty */
        { log_production(24); }
    ;

term
    : factor tail2
        { log_production(25); }
    ;

tail2
    : MUL factor tail2
        { log_production(26); }
    | DIV factor tail2
        { log_production(27); }
    | MOD factor tail2
        { log_production(28); }
    | /* empty */
        { log_production(29); }
    ;

factor
    : IDENTIFIER
        { log_production(30); }
    | CONSTANT_T
        { log_production(31); }
    | LPAREN expr RPAREN
        { log_production(32); }
    ;

input_output_statement
    : CIN RSHIFT IDENTIFIER SEMICOLON
        { log_production(33); }
    | COUT LSHIFT IDENTIFIER SEMICOLON
        { log_production(34); }
    ;

compound_statement
    : LBRACE statement_list RBRACE
        { log_production(35); }
    ;

condition
    : expr
        { log_production(36); }
    | expr relation expr
        { log_production(37); }
    ;

relation
    : LT
        { log_production(38); }
    | LTE
        { log_production(39); }
    | GT
        { log_production(40); }
    | GTE
        { log_production(41); }
    | EQ
        { log_production(42); }
    | NEQ
        { log_production(43); }
    ;

if_statement

    : IF LPAREN condition RPAREN statement %prec ELSE

        { log_production(44); }

    | IF LPAREN condition RPAREN statement ELSE statement

        { log_production(45); }

    ;

while_statement
    : WHILE LPAREN expr RPAREN statement
        { log_production(48); }
    ;

for_statement
    : FOR LPAREN expr_statement expr_statement expr RPAREN statement
        { log_production(49); }
    ;

return_statement
    : RETURN value SEMICOLON
        { log_production(50); }
    ;

value
    : expr
        { log_production(51); }
    | /* empty */
        { log_production(52); }
    ;

break
    : BREAK SEMICOLON
        { log_production(53); }
    ;

%%


void log_production(int prod_number) {
    printf("Production used: %d\n", prod_number);
}

void yyerror(const char *s) {
    printf("Error: %s\n", s);
	printf("Erorr  %d", yylineno);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s input file\n", argv[0]);
        return 1;
    }	
	
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }
	printf("parsing %d", yyparse());
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
	
    return 0;
}
