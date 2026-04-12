%{
    /* definition */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "types.h"
#include "node.h"
#define MAX_SYMBOLS 100

Node* root;


typedef struct
{
    char* name;
    Type type;
    float val;

} Symbol;

typedef struct
{
    float val;
    Type type;
}Value;

Type type_result(Type a, Type b);
void insert(char* name, Type type, float val);
Symbol lookup(char* name);
void update(char* name, float val);

int yylex(void);
void yyerror(const char *s);

Value eval_expr(Node* n);
void eval_stmt(Node* n);

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

Node* make_node(int kind, Node* left, Node* right)
{
    Node* n = malloc(sizeof(Node));
    n->kind = kind;
    n->left = left;
    n->right = right;
    n->val = 0;
    n->name = NULL;
    return n;
};

Node* make_int_node(float val)
{
    Node* n = malloc(sizeof(Node));
    n->kind = NODE_INT;
    n->val = val;
    n->left = NULL;
    n->right = NULL;
    n->name = NULL;
    return n;
};

Node* make_float_node(float val)
{
    Node* n = malloc(sizeof(Node));
    n->kind = NODE_FLOAT;
    n->val = val;
    n->left = NULL;
    n->right = NULL;
    n->name = NULL;
    return n;
};



Node* make_ident_node(char* name)
{
    Node* n = malloc(sizeof(Node));
    n->kind = NODE_IDENT;
    n->name = strdup(name);
    n->left =  NULL;
    n->right = NULL;
    return n;
};


Node* make_dec_assign_node(int type, char* name, Node* expr)
{
    Node* n = malloc(sizeof(Node));
    n->kind = NODE_DEC_ASSIGN;
    n->name = strdup(name);
    n->right = expr;
    n->left = NULL;
    n->val = type;
    return n;
}

Node* make_assign_node(char* name, Node* expr)
{
    Node* n = malloc(sizeof(Node));
    n->kind = NODE_ASSIGN;
    n->name = strdup(name);
    n->right = expr;
    n->left = NULL;
    return n;
};



Value eval_expr(Node* n)
{
    switch(n->kind)
    {
        case NODE_INT:
            return (Value){n->val, TYPE_INT};

        case NODE_FLOAT:
            return (Value){n->val, TYPE_FLOAT};

        case NODE_BOOL:
            return (Value){n->val, TYPE_BOOL};

        case NODE_IDENT:
        {
            Symbol s = lookup(n->name);
            return (Value){s.val, s.type};
        }

        case NODE_ADD:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);
        
            return (Value){a.val + b.val , type_result(a.type, b.type)};
        }

        case NODE_SUB:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  - b.val , type_result(a.type, b.type)};
        }
        case NODE_MUL:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  * b.val , type_result(a.type, b.type)};
        }

        case NODE_DIV:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  / b.val , type_result(a.type, b.type)};
        }

        case NODE_MOD:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){(int)a.val  % (int)b.val , type_result(a.type, b.type)};
        }   

        case NODE_EQ:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  == b.val , type_result(a.type, b.type)};
        }

        case NODE_NEQ:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  != b.val , type_result(a.type, b.type)};
        }

        case NODE_LE:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  <= b.val , type_result(a.type, b.type)};
        }

        case NODE_GE:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  <= b.val , type_result(a.type, b.type)};
        }

        case NODE_AND:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  && b.val , type_result(a.type, b.type)};
        }

        case NODE_OR:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  || b.val , type_result(a.type, b.type)};
        }

        case NODE_LT:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  < b.val , type_result(a.type, b.type)};
        }

        case NODE_GT:
        {
            Value a = eval_expr(n->left);
            Value b = eval_expr(n->right);

            return (Value){a.val  > b.val , type_result(a.type, b.type)};
        }

        case NODE_UMIN:
        {
            Value a = eval_expr(n->left);

            return (Value){-a.val , a.type};
        }

        case NODE_NOT:
        {
            Value a = eval_expr(n->left);
            
            return (Value){!a.val , a.type};
        }

        case NODE_SIN:
        {
            Value a = eval_expr(n->left);

            return (Value){sin(a.val), TYPE_FLOAT};
        }

        case NODE_COS:
        {
            Value a = eval_expr(n->left);

            return (Value){cos(a.val), TYPE_FLOAT};
        }
        case NODE_TAN:
        {
            Value a = eval_expr(n->left);

            return (Value){tan(a.val), TYPE_FLOAT};
        }
    }
    return (Value){0, TYPE_FLOAT};
};

void eval_stmt(Node* n)
{

    switch(n->kind)
    {
        case NODE_STMTS:
        {
            if(n->left) eval_stmt(n->left);
            if(n->right) eval_stmt(n->right);
            break;
        }

        case NODE_DEC_ASSIGN:
        {
            Value a = eval_expr(n->right);
            float val = a.val;
            insert(n->name, n->val, val);
            break;
        }
        case NODE_ASSIGN:
        {
            Value a = eval_expr(n->right);
            float val = a.val;
            update(n->name, val);
            break;
        }

        case NODE_PRINT:
        {
            Value a = eval_expr(n->left);
            if(a.type == TYPE_BOOL)
                printf("%s\n", a.val ? "true" : "false");
            else if (a.type == TYPE_INT)
                printf("%d\n", (int)a.val);
            else
                printf("%f\n", a.val);  
            break;
        }

        case NODE_WHILE:
        {
            Value a = eval_expr(n->left);
            while(a.val)
            {
                eval_stmt(n->right);
            }
            break;
        }

        case NODE_IF:
        {
            Value a = eval_expr(n->left);
            if(a.val)
            {
                eval_stmt(n->right);
            }
            break;
        }

        case NODE_IFELSE:
        {
            Value a = eval_expr(n->left);
            if(a.val)
            {
                eval_stmt(n->left->right);
            }
            else
            {
                eval_stmt(n->right);
            }
            break;
        }
    }
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

    Node* node;
}

%type <ival> type
%type <node> expr stmt stmts


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
        {
            $$ = $1;
            root = $$;
        }      
        | stmts stmt   
        {
            $$ = make_node(NODE_STMTS, $1, $2);
            root = $$;
        }   

stmt:
      type IDENTIFIER ASSIGN expr SEMICOLON
      {
            $$ = make_dec_assign_node($1, $2, $4);
      }
    | IDENTIFIER ASSIGN expr SEMICOLON
    {
        Symbol s = lookup($1);

        $$ = make_assign_node($1, $3);
    }
    | IF LPAREN expr RPAREN LBRACE stmts RBRACE ELSE LBRACE stmts RBRACE
    {
        
        $$ = make_node(NODE_IFELSE, make_node(NODE_IF, $3, $6), $10);
    }
    | IF LPAREN expr RPAREN LBRACE stmts RBRACE
    {
        $$ = make_node(NODE_IF, $3, $6);
    }
    | WHILE LPAREN expr RPAREN LBRACE stmts RBRACE
    {
        $$ = make_node(NODE_WHILE, $3, $6);
    }
    | PRINT LPAREN expr RPAREN SEMICOLON
    {
        $$ = make_node(NODE_PRINT, $3, NULL);
    }
;

expr:
    expr PLUS expr        
    {
        $$ = make_node(NODE_ADD, $1, $3);
    }
    | expr MINUS expr       
    {
        $$ = make_node(NODE_SUB, $1, $3);
    }
    | MINUS expr
    {
        $$ = make_node(NODE_UMIN, $2, NULL);
    }
    | expr MULT expr        
    {
        $$ = make_node(NODE_MUL, $1, $3);

    }
    | expr DIV expr         
    {
        $$ = make_node(NODE_DIV, $1, $3);

    }
    | expr MOD expr         
    {
        $$ = make_node(NODE_MOD, $1, $3);
    }
    | expr EQ expr          
    {
        $$ = make_node(NODE_EQ, $1, $3);
    }
    | expr NEQ expr         
    {
        $$ = make_node(NODE_NEQ, $1, $3);
    }
    | expr LE expr          
    {
        $$ = make_node(NODE_LE, $1, $3);
    }
    | expr GE expr          
    {
        $$ = make_node(NODE_GE, $1, $3);
    }
    | expr AND expr         
    {
        $$ = make_node(NODE_AND, $1, $3);
    }
    | expr OR expr          
    {
        $$ = make_node(NODE_OR, $1, $3);
    }
    | expr LT expr          
    {
        $$ = make_node(NODE_LT, $1, $3);
    }
    | expr GT expr          
    {
        $$ = make_node(NODE_GT, $1, $3);
    }
    | NOT expr              
    {
        $$ = make_node(NODE_NOT, $2, NULL);
    }
    | LPAREN expr RPAREN    
    {
        $$ = $2;
    }
    | INT_LITERAL           
    {
       $$ = make_int_node($1);
    }
    | FLOAT_LITERAL         
    {
       $$ = make_float_node($1);
    }
    | TRUE
    {
        $$ = make_node(NODE_BOOL, NULL, NULL);
        $$->val = 1;
    }
    | FALSE
    {
        $$ = make_node(NODE_BOOL, NULL, NULL);
        $$->val = 0;
    }
    | IDENTIFIER            
    {
        $$ = make_ident_node($1);
    }
    | SIN LPAREN expr RPAREN
    {
        $$ = make_node(NODE_SIN, $3, NULL);

    }
    | COS LPAREN expr RPAREN
    {
        $$ = make_node(NODE_COS, $3, NULL);
    }
    | TAN LPAREN expr RPAREN
    {
        $$ = make_node(NODE_TAN, $3, NULL);
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
    eval_stmt(root);

    return 0;
}


void yyerror(const char *s)
{
    printf("Error: %s\n", s);
}
