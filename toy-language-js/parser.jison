/* Lexical grammar */
%lex

/* Tokens */
%%
\s+                             ;
"if"                            return 'T_IF';
"else"                          return 'T_ELSE';
"local"                         return 'T_VAR';
"function"                      return 'T_FUNCTION';
"end"                           return 'T_END';

[a-zA-Z_]+([0-9a-zA-Z_])*       return 'T_ID';
[0-9]+                          return 'T_INTEGER';
[0-9]+\.[0-9]*                  return 'T_FLOAT';
\".*\"                          return 'T_STRING';
\'.*\'                          return 'T_STRING';

"="                             return '=';
"*"                             return '*';
"/"                             return '/';
"-"                             return '-';
"+"                             return '+';

"{"                             return '{';
"}"                             return '}';
"("                             return '(';
")"                             return ')';
","                             return ',';
";"                             return ';';
"."                             return '.';

"true"                          return 'T_TRUE';
"false"                         return 'T_FALSE';
"null"                          return 'T_NULL';

<<EOF>>                         return 'T_EOF';

.                               return 'T_ERROR';

/lex

%start program

/* Language grammar */
%%

program
    : statementList T_EOF { return $1; }
    ;

statementList
    : statementList statement {  $$ = $1.concat($2); }
    | /* empty */ { $$ = []; }
    ;

statement
    : variableStatement { $$ = $1; }
    | functionDeclaration
//    | ifStatement
    ;

variableStatement
    : T_VAR T_ID { $$ = new NodeVariableDeclaration(new NodeIdentifier($2)); }
    | T_VAR T_ID '=' expr { $$ = new NodeVariableDeclaration(new NodeIdentifier($2), $4); }
    ;

functionDeclaration
    : T_FUNCTION T_ID '(' parameterList ')' functionBody T_END { $$ = new NodeFunctionDeclaration(); }
    ;

parameterList
    : parameterList ',' T_ID {}
    | T_ID {}
    | /* empty */
    ;

functionBody
    : statementList
    ;

expr
    : primaryExpr { $$ = $1; }
    | primaryExpr '=' expr { $$ = new NodeAssignment($1, $3); }
    ;

primaryExpr
    : literal { $$ = $1; }
    | T_ID { $$ = new NodeIdentifier($1); }
    ;

literal
    : T_NULL    { $$ = new NodeNull($1); }
    | T_TRUE    { $$ = new NodeBoolean($1); }
    | T_FALSE   { $$ = new NodeBoolean($1); }
    | T_INTEGER { $$ = new NodeInteger($1); }
    | T_FLOAT   { $$ = new NodeFloat($1); }
    | T_STRING  { $$ = $1; }
    ;

/*
ifStatement
    :
    T_IF T_LPAREN expr T_RPAREN statement T_ELSE statement
    ;
*/

%%

var NodeVariableDeclaration = function(id, expr) {
    this.type  = 'VAR_STMT';
    this.id   = id;
    this.expr = expr;
};

var NodeIdentifier = function(name) {
    this.type = 'IDENTIFIER';
    this.name = name;
};

var NodeNull = function(value) {
    this.type  = 'NULL';
    this.value = value;
};

var NodeBoolean = function(value) {
    this.type  = 'BOOLEAN';
    this.value = value;
};

var NodeInteger = function(value) {
    this.type  = 'INTEGER';
    this.value = value;
};

var NodeFloat = function(value) {
    this.type  = 'FLOAT';
    this.value = value;
};

var NodeAssignment = function(leftHandSide, rightHandSide) {
    this.type  = 'ASSIGMENT_EXPR';
    this.lhs = leftHandSide;
    this.rhs = rightHandSide;
};
