
%lex
%%
[\n\s]+                                         /* skip line spliter */                                              
"<"[a-z].*?\/">"                                return 'SELF_CLOSE_TAG' 
"<"[a-z].*?">"                                  return 'OPEN_TAG'
"<"\/[a-z]\w*?">"                               return 'CLOSE_TAG'
.[^<\n]*                                        return 'TEXT'
<<EOF>>                                         return 'EOF'
.                                               return 'INVALID' 

/lex

%% /* language grammar */

program
    : %empty
    | tag-list EOF
        {return $1}
    ;

tag-list
    : tag-list tag
        { $$ = [...$1, $2]}
    | tag
        { $$ = [$1]}
    ;

tag
    : text-tag
    | normal-tag
    ;

text-tag
    : TEXT
        { $$ = yy.createNode("text"); $$.value = $1;}
    ;

normal-tag
    : SELF_CLOSE_TAG
        { $$ = yy.createNode("tag"); $$.open = $1}
    | OPEN_TAG tag-list CLOSE_TAG
        { $$ = yy.createNode("tag"); $$.open = $1; $$.close = $3; $$.children = $2}
    | OPEN_TAG CLOSE_TAG
        { $$ = yy.createNode("tag"); $$.open = $1; $$.close = $2}
    ;

%%