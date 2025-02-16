grammar Pinn;

file : defines* ( function | statement )+ EOF ;

defines
  : '#define' ID ID ;

function
  : 'func' ID LPAREN (fvarDecl (',' fvarDecl)*)? RPAREN kind? block ;

block
  : '{' statement* '}' ;

fvarDecl
  : idList THREEDOT? kind ;

typeDecl
  : 'type' ID kind ;

varDecl
  : 'var' idList kind
  | CONST ID '=' expr
  | ID ( ',' ID )* CE exprList
  | LPAREN ID ( ',' ID )* RPAREN CE expr;

kind
  :
  ID
  | (LSQUARE ( MAP | expr)? RSQUARE) kind
  |  AST? LPAREN kindList? RPAREN
  | '{' structurePair (',' structurePair)* '}' ;


simpleStatement
  : lExprList '=' exprList #simpleSet
  | LPAREN lExprList RPAREN '=' expr #destructureSet
  | lExpr ('+' | '-' | '*' | '/' | '%') '=' expr #compoundSet
  | lExpr ('++' | '--') #doubleSet ;

lExpr
  : ID (LSQUARE expr RSQUARE)* ;

structurePair
  : ID ':' kind ;

objectPair
  : (STRING | ID) ':' expr ;

expr
  :
   expr LSQUARE ( first=expr? (AT | COLON) second=expr? | expr) RSQUARE #indexExpr
  | expr '.' INT #dotIndexExpr
  |   THREEDOT? LSQUARE exprList? RSQUARE #arrayLiteral
  | AST? '{' (objectPair ( ',' objectPair )*)? '}' #objectLiteral
  | ('+' | '-' | '!' ) expr #unaryExpr
  | expr ('+' | '-' | AST | '/' | '%' | '<<' | '>>' | '&' | '|' | '^' | 'in' ) expr #intExpr
  | expr ('==' | '!=' | '>' | '<' | '>=' | '<=' ) expr #compExpr
  | expr ('&&' | '||') expr #boolExpr
  |   ID LPAREN exprList? RPAREN #callExpr
  |  LPAREN expr RPAREN #parenExpr
  |  CARET? AST? LPAREN exprList? RPAREN #tupleExpr
  | expr (AT | COLON) expr #rangeExpr
  | expr '?' expr COLON expr #conditionalExpr
  | (ID | FLOAT | INT | BOOL | STRING | NIL ) #literalExpr ;

idList
  : ID (',' ID)* ;
exprList
  : expr (',' expr)* ;
lExprList
  : lExpr (',' lExpr)* ;
kindList
  : kind (',' kind)* ;
returnStatement
  : 'return' expr? ;
ifStatement
  : 'if' expr statement ('else' statement)?;
guardStatement
  : 'guard' expr 'else' block;
whStatement
  : 'while' expr block ;
loopStatement
  : 'loop' block ;
repeatStatement
  : 'repeat' block 'while' expr ;
foStatement
  : 'for' (varDecl | fss=simpleStatement)? ';' expr ';' sss=simpleStatement block
  | 'for' ID ',' ID '=' RANGE expr block |
    'for' ID '=' RANGE expr block ;
caseStatement
  : 'when' exprList COLON statement* ;

switchStatement
  : 'match' expr '{' caseStatement* ('default' COLON statement*)? '}' ;

statement
  :  expr ';'
  | typeDecl ';'
  | varDecl ';' 
  | simpleStatement ';'
  | ifStatement
  | guardStatement
  | whStatement 
  | repeatStatement ';'
  | loopStatement
  | switchStatement
  | returnStatement ';'
  | foStatement
  | block
  | 'break' ';'
  | 'continue' ';'
  | 'fallthrough' ';'
  | ';' ;

BOOL : 'true' | 'false' ;

MAP
 : 'map' ;

LSQUARE : '[' ;
RSQUARE : ']' ;
LPAREN : '(' ;
RPAREN : ')' ;
NIL : 'nil' ;
COLON : ':' ;
CE : ':=' ;
RANGE : 'range' ;
AST: '*' ;
THREEDOT : '...' ;
AT : '@' ;
CARET : '^' ;
CONST : 'const' ;

ID : [a-zA-Z_]([a-zA-Z_0-9])* ;
INT : '0'
  | [1-9] ('_'? DECIMAL_DIGITS)? ;

FLOAT : DECIMAL_DIGITS '.' DECIMAL_DIGITS? DECIMAL_EXPONENT?
  | DECIMAL_DIGITS DECIMAL_EXPONENT ;   
 // | '.' DECIMAL_DIGITS DECIMAL_EXPONENT? ;

WS : ([ \t\n]+ | '//' ~('\n')* '\n' | '/*' .*? '*/' )-> skip ;
STRING : '"' ( '\\"' | '\\\\' | ~('"' | '\\') )*      '"' ;

fragment DECIMAL_DIGIT : [0-9] ;
fragment DECIMAL_DIGITS : DECIMAL_DIGIT ('_'? DECIMAL_DIGIT)* ;
fragment DECIMAL_EXPONENT : 'e' [+-]? DECIMAL_DIGITS ;
