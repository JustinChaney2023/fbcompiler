%{
    /* definition */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "types.h"
#define MAX_SYMBOLS 100


typedef struct{
    char* name;
    Type type;
    float val;

} Symbol;

Type type_result(Type a, Type b);
void insert(char* name, Type type, float val);
Symbol lookup(char* name);
void update(char* name, float val);

int yylex(void);
void yyerror(const char *s);

Symbol table[MAX_SYMBOLS];
int symbol_count = 0;

void insert(char* name, Type type, float val)
{
    table[symbol_count].name = strdup(name);
    table[symbol_count].type = type;
    table[symbol_count].val = val;
    symbol_count++;
}

Symbol lookup(char* name)
{
    for(int i=0; i < symbol_count; i++)
    {
        if(strcmp(name, table[i].name) == 0)
            return table[i];
    }

    printf("Error: undefined variable %s \n", name);

    Symbol empty;
    empty.type = TYPE_INT;
    empty.val = 0;
    return empty;
}

void update(char* name, float val)
{
    for(int i=0; i < symbol_count; i++)
    {
        if(strcmp(name, table[i].name) == 0)
            {
            table[i].val = val;
            return;
            }
    }

    printf("Error: undeclared variable assignment %s \n", name);
}



Type type_result(Type a, Type b)
{
    if (a == TYPE_BOOL || b == TYPE_BOOL)
        return TYPE_BOOL;
    if (a == TYPE_FLOAT || b == TYPE_FLOAT)
        return TYPE_FLOAT;
    return TYPE_INT;

};

%}

%token INT_TYPE
%token FLOAT_TYPE 
%token BOOL_TYPE
%token IF
%token ELSE
%token WHILE
%token SIN
%token COS
%token TAN
%token PRINT
%token TRUE
%token FALSE

%union{
    int ival;
    float fval;
    char* sval;

    struct {
        Type type;
        float val;
    }eval;
}

%type <eval> expr
%type <ival> type

%token <sval> IDENTIFIER
%token <fval> FLOAT_LITERAL
%token <ival> INT_LITERAL

%token EQ
%token NEQ
%token LE
%token GE
%token AND
%token OR

%token ASSIGN
%token LT
%token GT
%token NOT
%token PLUS
%token MINUS
%token MULT
%token DIV
%token MOD

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left PLUS MINUS
%left MULT DIV MOD
%right NOT

%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token SEMICOLON





/* rules  */
%%


stmts:
      stmt          
    | stmts stmt    

stmt:
      type IDENTIFIER ASSIGN expr SEMICOLON
      {
        if($1 != $4.type)
            printf("Type error: expression does not match\n");
        else
            insert($2, $1, $4.val);
      }
    | IDENTIFIER ASSIGN expr SEMICOLON
    {
        Symbol s = lookup($1);

        if(s.type != $3.type)
            printf("Type error: expression does not match\n");
        else
            update($1, $3.val);
    }
    | IF LPAREN expr RPAREN LBRACE stmts RBRACE ELSE LBRACE stmts RBRACE
    {
        if($3.val)
        {

        }
        else
        {

        }
    }
    | IF LPAREN expr RPAREN LBRACE stmts RBRACE
    {
        if($3.val)
        {
            //I hate you you fucking nigger bitch ass
        }
    }
    | WHILE LPAREN expr RPAREN LBRACE stmts RBRACE
    {
        while($3.val)
        {
            //fix me boy *in a racist tone*
        }
    }
    | PRINT LPAREN IDENTIFIER RPAREN SEMICOLON
    {
        Symbol s = lookup($3);
        if(s.type == TYPE_FLOAT)
            printf("%f\n", s.val);
        else if(s.type == TYPE_INT)
            printf("%d\n", (int)s.val);
        else if(s.type == TYPE_BOOL)
            printf("%d\n", (int)s.val);
    }
;

expr:
      expr PLUS expr        
      {
        /*if($1.type == TYPE_BOOL || $3.type == TYPE_BOOL)
            printf("Type error: cannot do arithmetic with bool\n");*/

        $$.type = type_result($1.type, $3.type);
        $$.val = $1.val + $3.val;
      }
    | expr MINUS expr       
    {
        /*if($1.type == TYPE_BOOL || $3.type == TYPE_BOOL)
            printf("Type error: cannot do arithmetic with bool\n");*/

        $$.type = type_result($1.type, $3.type);
        $$.val = $1.val - $3.val;
    
    }
    | expr MULT expr        
    {
        /*if($1.type == TYPE_BOOL || $3.type == TYPE_BOOL)
            printf("Type error: cannot do arithmetic with bool\n");*/

        $$.type = type_result($1.type, $3.type);
        $$.val = $1.val * $3.val;
    
    }
    | expr DIV expr         
    {
        /*if($1.type == TYPE_BOOL || $3.type == TYPE_BOOL)
            printf("Type error: cannot do arithmetic with bool\n");*/

        $$.type = type_result($1.type, $3.type);
        $$.val = $1.val / $3.val;
    
    }
    | expr MOD expr         
    {
        /*if($1.type == TYPE_BOOL || $3.type == TYPE_BOOL)
            printf("Type error: cannot do arithmetic with bool\n");*/

        $$.type = type_result($1.type, $3.type);
        $$.val = (int)$1.val % (int)$3.val;
    
    }
    | expr EQ expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val == $3.val);
    }
    | expr NEQ expr         
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val != $3.val);
    }
    | expr LE expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val <= $3.val);
    }
    | expr GE expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val >= $3.val);
    }
    | expr AND expr         
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val && $3.val);
    }
    | expr OR expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val || $3.val);
    }
    | expr LT expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val < $3.val);
    }
    | expr GT expr          
    {
        $$.type = TYPE_BOOL;
        $$.val = ($1.val > $3.val);
    }
    | NOT expr              
    {
        $$.type = TYPE_BOOL;
        $$.val = !($2.val);
    }
    | LPAREN expr RPAREN    
    {
        $$.type = $2.type;
        $$.val = $2.val;
    }
    | INT_LITERAL           
    {
        $$.type = TYPE_INT;
        $$.val = $1;
    }
    | FLOAT_LITERAL         
    {
        $$.type = TYPE_FLOAT;
        $$.val = $1;
    }
    | TRUE
    {
        $$.type = TYPE_BOOL;
        $$.val = 1;
    }
    | FALSE
    {
        $$.type = TYPE_BOOL;
        $$.val = 0;
    }
    | IDENTIFIER            
    {
        Symbol s = lookup($1);

        $$.type = s.type;
        $$.val = s.val;
    }
    | SIN LPAREN expr RPAREN
    {
        $$.type = TYPE_FLOAT;
        $$.val = sin($3.val);
    }
    | COS LPAREN expr RPAREN
    {
        $$.type = TYPE_FLOAT;
        $$.val = cos($3.val);
    }
    | TAN LPAREN expr RPAREN
    {
        $$.type = TYPE_FLOAT;
        $$.val = tan($3.val);
    }
    
;

type: 
      INT_TYPE 
        {$$ = (int)TYPE_INT;}
    | FLOAT_TYPE 
        {$$ = (int)TYPE_FLOAT;}
    | BOOL_TYPE
        {$$ = (int)TYPE_BOOL;}
;


%%

int main()
{

    yyparse();

    return 0;
}


void yyerror(const char *s)
{
    printf("Error: %s\n", s);
}
