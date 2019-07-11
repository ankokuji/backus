
%lex
%%
\s+                                             /* skip whitespace */
[0-9]+(\.[0-9]+)?\b                             return 'NUMBER'
"var"|"const"\b                                 return 'TYPE'
[a-z]\w*\b                                      return 'IDENTIFIER'
"="                                             return 'EQUAL'
"*"                                             return '*'
"/"                                             return '/'
"-"                                             return '-'
"+"                                             return '+'
"("                                             return '('
")"                                             return ')'
","                                             return 'COMMA'
<<EOF>>                                         return 'EOF'

/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/'
%right UNARY
%start statement

%% /* language grammar */

statement
    : decl EOF
        { return $1 }
    ;

expressions
    : identifier
    | NUMBER
        { $$ = yy.createNode("Literal"); $$.value = $1}
    ;

decl 
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
    : identifier EQUAL expressions
        { $$ = yy.createNode("VariableDeclarator"); $$.id = $1; $$.init = $3;}
    ;

identifier
    : IDENTIFIER
        { $$ = yy.createNode("Identifier"); $$.name = $1;}   
    ;
%%