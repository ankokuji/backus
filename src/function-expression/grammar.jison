
%lex
%%
\s+                                             /* skip whitespace */
[0-9]+(\.[0-9]+)?\b                             return 'NUMBER'
"var"|"const"|"let"\b                           return 'TYPE'
"function"                                      return 'FUNCTION'
"="                                             return 'EQUAL'
"<"                                             return 'LT'
">"                                             return 'GT'
"=="                                            return 'DOUBLE_EQ'
"*"                                             return 'TIMES'
"/"                                             return 'OVER'
"-"                                             return 'MINUS'
"+"                                             return 'PLUS'
"{"                                             return 'LBRACE'
"}"                                             return 'RBRACE'
"("                                             return 'LPAREN'
")"                                             return 'RPAREN'
","                                             return 'COMMA'
";"|\n                                          return 'LINE_SEP'
[a-z]\w*                                        return 'IDENTIFIER'
<<EOF>>                                         return 'EOF'
.                                               return 'INVALID'

/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/'
%right UNARY
%start program

%glr-parser

%% /* language grammar */

program
    : %empty
    | program stmt EOF
    ;

stmt
    : expr
    | func-decl 
    ;

expr
    : expr-head PLUS expr-sequence
    | expr-head
    ;

expr-sequence
    : expr-sequence PLUS expr
    | expr
    ;

expr
    : func-expr
    ;

expr-head
    : func-expr-start
    ;

func-decl
    : FUNCTION IDENTIFIER
    ;

func-expr-start
    : LPAREN FUNCTION IDENTIFIER RPAREN
    ;

func-expr
    : FUNCTION IDENTIFIER
    ;

%%