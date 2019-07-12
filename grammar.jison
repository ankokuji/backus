
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

%% /* language grammar */

program  
    : stmt-seq
        { let pg = yy.createNode("Program"); pg.body = $1; return pg;}
    ;

stmt-seq
    : stmt-seq stmt
    | stmt
    ;
    
stmt
    : decl-stmt stmt-sep
        { $$ = $1 }
    | expr stmt-sep
    | block
    ;

expr
    : simp-expr COMPARISON simp-expr 
        { $$ = yy.createNode("BinaryExpression"); $$.operatorToken = "COMPARISON"; $$.left = $1; $$.right = $3;}
    | simp-expr
    ;

simp-expr
    : simp-expr PLUS term
        { $$ = yy.createNode("BinaryExpression"); $$.operatorToken = "+"; $$.left = $1; $$.right = $3}
    | simp-expr MINUS term
    | term 
    ;

term
    : term TIMES factor 
        { $$ = yy.createNode("BinaryExpression"); $$.operatorToken = "*"; $$.left = $1; $$.right = $3;}
    | factor
        { $$ = $1 }
    ;

factor
    : identifier
    | NUMBER
        { $$ = yy.createNode("Literal"); $$.value = $1}
    | LPAREN expr RPAREN
        { $$ = $1 }
    | call-expr
    | func-expr-stmt-start
    ;

func-expr-stmt-start
    : LPAREN FUNCTION identifier func-params block RPAREN
        { $$ = yy.createNode("FunctionExpression"); $$.id = $2; $$.params = $3; $$.body = $4; }
    | LPAREN FUNCTION func-params block RPAREN
        { $$ = yy.createNode("FunctionExpression"); $$.params = $2; $$.body = $3; }
    ;

func-params
    : LPAREN param-list RPAREN
        { $$ = $2; }
    | LPAREN RPAREN
        { $$ = []; }
    ;

call-expr
    : factor LPAREN arg-list RPAREN
        { $$ = yy.createNode("CallExpression"); $$.callee = $1; $$.arguments = $3;}
    ;

arg-list
    : arg-list COMMA expr
        { $$ = [...$1, $3]}
    | expr
        { $$ = [$1]}
    ; 

param-list
    : param-list COMMA identifier
        { $$ = [...$1, $3]}
    | identifier
        { $$ = [$1];}
    | error
        { $$ = [];}
    ;

block
    : LBRACE stmt-seq RBRACE
        { $$ = yy.createNode("Block"); $$.body = $2}
    | LBRACE RBRACE
        { $$ = yy.createNode("Block"); $$.body = []}
    ;

decl-stmt 
    : TYPE var-list
        { $$ = yy.createNode("VariableDeclaration"); $$.kind = $1; $$.declaration = $2;}
    ;

var-list
    : var-list COMMA var-item
        { $$ = [...$1, $3]}
    | var-item
        { $$ = [$1] }
    ;

var-item
    : var-decl-assign
    | identifier
        { $$ = yy.createNode("VariableDeclarator"); $$.id = $1;}
    ;

var-decl-assign
    : identifier EQUAL expr
        { $$ = yy.createNode("VariableDeclarator"); $$.id = $1; $$.init = $3;}
    ;

identifier
    : IDENTIFIER
        { $$ = yy.createNode("Identifier"); $$.name = $1;}   
    ;

stmt-sep
    : LINE_SEP
    | EOF
    ;
%%