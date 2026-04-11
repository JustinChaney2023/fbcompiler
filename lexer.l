%{
/*
 * lexer.l - Flex lexer for RFB compiler
 * 
 * Tokenizes source code for the mini language.
 * Supports: int, float, bool types, arithmetic/boolean ops,
 * if/else/while control flow, sin/cos/tan functions, print statements.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"
#include "parser.tab.h"

%}

%option yylineno
%option noyywrap

/* Pattern definitions */
DIGIT      [0-9]
LETTER     [a-zA-Z]

/* Float requires digits on both sides of dot - rejects .5 and 5. */
FLOAT_LIT  {DIGIT}+"."{DIGIT}+
INT_LIT    {DIGIT}+

/* Identifier: letter or underscore followed by letters/digits/underscores */
IDENT      ({LETTER}|[_])({LETTER}|{DIGIT}|[_])*

/* Whitespace (discarded) */
WS         [ \t\r\n]+

%%

    /* Keywords */
"int"           { return INT_TYPE;   }
"float"         { return FLOAT_TYPE; }
"bool"          { return BOOL_TYPE;  }
"if"            { return IF;    }
"else"          { return ELSE;  }
"while"         { return WHILE; }
"sin"           { return SIN; }
"cos"           { return COS; }
"tan"           { return TAN; }
"print"         { return PRINT; }
"true"          { return TRUE;  }
"false"         { return FALSE; }

    /* Identifiers */
{IDENT}         { yylval.sval = strdup(yytext); return IDENTIFIER; }

    /* Numeric literals - float before int for correct matching */
{FLOAT_LIT}     { yylval.fval = atof(yytext); return FLOAT_LITERAL; }
{INT_LIT}       { yylval.ival = atoi(yytext); return INT_LITERAL;   }

    /* Multi-char operators (before single-char versions) */
"=="            { return EQ;  }
"<="            { return LE;  }
">="            { return GE;  }
"&&"            { return AND; }
"||"            { return OR;  }
"!="            { return NEQ; }

    /* Single-char operators */
"="             { return ASSIGN; }
"<"             { return LT;     }
">"             { return GT;     }
"!"             { return NOT;    }
"+"             { return PLUS;   }
"-"             { return MINUS;  }
"*"             { return MULT;   }
"/"             { return DIV;    }
"%"             { return MOD;    }

    /* Punctuation */
"("             { return LPAREN;    }
")"             { return RPAREN;    }
"{"             { return LBRACE;    }
"}"             { return RBRACE;    }
";"             { return SEMICOLON; }

    /* Comments and whitespace (discarded) */
"//"[^\n]*      { /* single-line comment */ }
{WS}            { /* whitespace - yylineno auto-updates for newlines */ }

    /* Error fallback */
.               { fprintf(stderr, "Lexical error: unexpected character '%s' on line %d\n", 
                          yytext, yylineno); }

%%
