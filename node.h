typedef enum {
    NODE_INT,
    NODE_FLOAT,
    NODE_BOOL,
    NODE_IDENT,
    NODE_ADD,
    NODE_SUB,
    NODE_MUL,
    NODE_DIV,
    NODE_MOD,
    NODE_EQ,
    NODE_NEQ,
    NODE_LE,
    NODE_GE,
    NODE_AND,
    NODE_OR,
    NODE_LT,
    NODE_GT,
    NODE_NOT,
    NODE_UMIN,
    NODE_SIN,
    NODE_COS,
    NODE_TAN,

    NODE_DEC_ASSIGN,
    NODE_ASSIGN,
    NODE_PRINT,
    NODE_STMTS,
    NODE_WHILE,
    NODE_IF,
    NODE_IFELSE
} NodeType;

typedef struct Node {
    int kind;

    struct Node* left;
    struct Node* right;

    float val;     // for numbers
    char* name;    // for identifiers
} Node;