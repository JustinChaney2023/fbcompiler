/*
 * main_test.c - Test driver for lexer
 * 
 * Standalone test harness to verify lexer tokenizes correctly.
 * Build: flex lexer.l && gcc lex.yy.c main_test.c -o lexer_test
 * Run: echo "int x = 5;" | ./lexer_test   OR   ./lexer_test < file.txt
 */

#include <stdio.h>
#include "parser.tab.h"

extern int   yylineno;
extern char *yytext;
YYSTYPE yylval;
int yylex(void);

/* Map token to readable name */
static const char *token_name(int tok) {
    switch (tok) {
        case INT_TYPE:      return "INT_TYPE";
        case FLOAT_TYPE:    return "FLOAT_TYPE";
        case BOOL_TYPE:     return "BOOL_TYPE";
        case IF:            return "IF";
        case ELSE:          return "ELSE";
        case WHILE:         return "WHILE";
        case PRINT:         return "PRINT";
        case TRUE:          return "TRUE";
        case FALSE:         return "FALSE";
        case SIN:           return "SIN";
        case COS:           return "COS";
        case TAN:           return "TAN";
        case IDENTIFIER:    return "IDENTIFIER";
        case INT_LITERAL:   return "INT_LITERAL";
        case FLOAT_LITERAL: return "FLOAT_LITERAL";
        case ASSIGN:        return "ASSIGN";
        case EQ:            return "EQ";
        case LE:            return "LE";
        case GE:            return "GE";
        case LT:            return "LT";
        case GT:            return "GT";
        case NOT:           return "NOT";
        case AND:           return "AND";
        case OR:            return "OR";
        case PLUS:          return "PLUS";
        case MINUS:         return "MINUS";
        case MULT:          return "MULT";
        case DIV:           return "DIV";
        case MOD:           return "MOD";
        case LPAREN:        return "LPAREN";
        case RPAREN:        return "RPAREN";
        case LBRACE:        return "LBRACE";
        case RBRACE:        return "RBRACE";
        case SEMICOLON:     return "SEMICOLON";
        default:            return "UNKNOWN";
    }
}

int main(void) {
    int tok;
    while ((tok = yylex()) != 0) {
        printf("line %2d | %-14s | %s", yylineno, token_name(tok), yytext);
        if (tok == INT_LITERAL)   printf("  => %d",  yylval.ival);
        if (tok == FLOAT_LITERAL) printf("  => %g",  yylval.fval);
        if (tok == IDENTIFIER)    printf("  => %s",  yylval.sval);
        printf("\n");
    }
    return 0;
}
