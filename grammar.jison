
%lex
%%
\s+                                             /* skip whitespace */
[0-9]+(\.[0-9]+)?\b                             return 'NUMBER'
"var"|"const"|"let"\b                           return 'TYPE'
[a-z]\w*                                        return 'IDENTIFIER'
"="                                             return 'EQUAL'
"<"                                             return 'LT'
">"                                             return 'GT'
"=="                                            return 'DOUBLE_EQ'
"*"                                             return 'TIMES'
"/"                                             return 'OVER'
"-"                                             return 'MINUS'
"+"                                             return 'PLUS'
"("                                             return 'LPAREN'
")"                                             return 'RPAREN'
","                                             return 'COMMA'
";"|\n                                          return 'LINE_SEP'
"function"                                      return 'FUNCTION'
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
    : stmt-seq statement
        { $$ = [...$1, $2] }
    | statement
        { $$ = [$1] } 
    ;

statement
    : decl-stmt stmt-sep
        { $$ = $1 }
    | expr stmt-sep
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
    ;

// func-expr
//     : FUNCTION 
//     ;

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