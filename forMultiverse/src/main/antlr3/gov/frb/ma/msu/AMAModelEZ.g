grammar AMAModelEZ;

options {

  language = Java;
 backtrack=true;
 memoize=true;
output=AST;//produce a tree
    ASTLabelType=CommonTree; 
}
//tokens{
//  }
@header {
package  gov.frb.ma.msu;
}
@lexer::header {
  package  gov.frb.ma.msu;
}

model: MODEL END;

WS : (  ' '  | '\n'  | '\r'  | '\t'|'_NOTD'|'_DATA'|'DTRM')+ {$channel=HIDDEN;};

MODEL: 'MODEL';
END: 'END';

EQUATION: 'EQUATION';
EQ: 'EQ';
EQTYPE: 'EQTYPE';
ENDOG: 'ENDOG';

PROMPT: '>';

IMPOSED: 'IMPOSED';
STOCH: 'STOCH';
LAG: 'LAG';
ELAG: 'ELAG';
LEAD: 'LEAD';
ENDOGENOUS: 'endogenous' | 'ENDOGENOUS';
EXOGENOUS: 'exogenous' | 'EXOGENOUS';
FILEMOD: 'filemod' | 'FILEMOD';
INNOV: 'innov' | 'INNOV';


   PLUS: '+';
    MINUS: '-' ;
    MULTIPLY: '*' ;
    DIVIDE: '/' ;
    EXP: '**' | '^' ;

      FLOATBASE: INTEGER '.' INTEGER
      | '.' INTEGER
      | INTEGER '.';
//            DIGIT: ('0'..'9') ;
 
     FLOAT: FLOATBASE
      | FLOATBASE ('e'|'E') (('-'|'+'))? FLOATBASE
      | INTEGER ('e'|'E') (('-'|'+'))? FLOATBASE;
        
      INTEGER: ('0'..'9')+ ;

      LETTER: (('a'..'z')|('A'..'Z'))  ;
   IDENTIFIER: LETTER  | LETTER ( ('0'..'9') | LETTER | '_' )+ ;


       COMMA: ',' ;
      EQUALS: '=' ;
      OPENPAREN: '(' ;
      CLOSEPAREN: ')' ;

      variablelist : IDENTIFIER+;
 
      constant : (INTEGER|FLOAT);
      
      element : LAG OPENPAREN IDENTIFIER (COMMA INTEGER)? CLOSEPAREN
     | LEAD OPENPAREN IDENTIFIER (COMMA INTEGER)? CLOSEPAREN
    | IDENTIFIER | constant
        |
        OPENPAREN 
    expression 
  CLOSEPAREN
 ;
     
     
     unary : MINUS element | element;
     
     factor :  (unary (EXP factor)*);
     
     term: factor ((MULTIPLY|DIVIDE) factor)*;
     
     
     expression : term
     ((PLUS|MINUS) term)*;
     
     
     
