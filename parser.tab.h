/*
 * parser.tab.h - Token definitions for lexer
 * 
 * STUB: This file defines tokens for standalone lexer testing.
 * Will be replaced by Bison-generated version once Aaron completes parser.y
 */

#ifndef PARSER_TAB_H
#define PARSER_TAB_H

typedef union {
    int    ival;   /* INT_LITERAL */
    double fval;   /* FLOAT_LITERAL */
    char  *sval;   /* IDENTIFIER */
} YYSTYPE;

extern YYSTYPE yylval;

typedef enum yytokentype {
    INT_TYPE   = 258, FLOAT_TYPE, BOOL_TYPE,
    IF, ELSE, WHILE,
    PRINT,
    TRUE, FALSE,
    SIN, COS, TAN,
    IDENTIFIER,
    INT_LITERAL, FLOAT_LITERAL,
    ASSIGN,
    EQ, LE, GE, LT, GT,
    NOT, AND, OR,
    PLUS, MINUS, MULT, DIV, MOD,
    LPAREN, RPAREN, LBRACE, RBRACE, SEMICOLON
} yytokentype;

#endif /* PARSER_TAB_H */
