grammar dynare412;
options {
k=2;// with default lookahead get "code too large" runtime error
backtrack=true;//without backtrack multiple alternatives match model comparison
memoize=true;
output=AST;//produce a tree
    ASTLabelType=CommonTree; 
}
tokens{
AModelVarOrParam;
AParamInit;
UMINUS;
UPLUS;
AShockVar;
AShockList;
ACorr;
AnEquationList;
}
@header
{
package gov.frb.ma.msu;
}
@lexer::header
{
package gov.frb.ma.msu;
import java.util.Stack;

}
@lexer::members{
boolean stringOK=true;
}
//Tokens section

 DOTTIMES
 	:	
 	'.*';
 DOTDIVIDE
 	:	'./';
 DOTPOWER
 	:	'.^';
 POWER : '\^';
 
WS  :  (' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}
    ;


COMMENT
    :   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

LINE_COMMENT
    :  ('//'|'%') ~('\n'|'\r')*   ( '\n'|'\r'('\n')?  )?
{$channel=HIDDEN;
//System.out.println("comment detected:" + getText() );
}
    ;
//notDynareCode
//   :{false}?   ~('\n'|'\r')+  
//	;

SEMI : ';';
COMMA : ',';

VAR : 'var' ;
VAREXO : 'varexo';
PARAMETERS : 'parameters';
PERIODS : 'periods';
STEADY : 'steady';
CHECK : 'check';
SIMUL : 'simul';
MODEL : 'model';
INITVAL : 'initval';
ENDVAL : 'endval';
END : 'end';
SHOCKS : 'shocks';
STDERR : 'stderr';
COLON: ':';
TEX_NAME : '$' ~('$')+ '$';
//LBRAC: '['  {stringOK=true;System.out.println("LBRAC setting true");};
LBRAC: '['  ;
//RBRAC: ']'  TRANSP?{stringOK=false;System.out.println("RBRAC setting false");};
RBRAC: ']'  TRANSP?;
VALUES: 'values';
CORR: 'corr';
OPENPAREN
//	:	 '('{stringOK=true;System.out.println("OPENPAREN setting true");};
		:	 '(';
CLOSEPAREN 
	//:	')'  TRANSP?{stringOK=false;System.out.println("CLOSEPAREN setting false");};
	:	')'  TRANSP?;
SOLVE_ALGO 
	:	 'solve_algo';
HOMOTOPY_MODE
	:	'homotopy_mode';
HOMOTOPY_STEPS
	:	'homotopy_steps';
MARKOWITZ
	:	'markowitz';	
STACK_SOLVE_ALGO
	:	'stack_solve_algo';
MINIMAL_SOLVING_PERIODS
	:	'minimal_solving_periods';
STOCH_SIMUL
	:	'stoch_simul';
DR_ALGO	:	'dr_algo';
IRF :'irf';
INF	:	'inf';
PLUS : '+';
MINUS : '-';
TIMES : '*';
DIVIDE : '/';
EQUAL : '=';

EXP : 'exp';
LOG : 'log';
LOG10 : 'log10';
LN : 'ln';
SIN : 'sin';
COS : 'cos';
TAN : 'tan';
ASIN : 'asin';
ACOS : 'acos';
ATAN : 'atan';
SINH : 'sinh';
COSH : 'cosh';
TANH : 'tanh';
ASINH : 'asinh';
ACOSH : 'acosh';
ATANH : 'atanh';
SQRT : 'sqrt';
MAX : 'max';
MIN : 'min';
MODE_FILE
	:	'mode_file';
NAN_CONSTANT : 'nan';
            DROP	:	'drop';       
LINEAR : 'linear';
 BETA_PDF:	 'beta_pdf';
GAMMA_PDF
	:	'gamma_pdf';
       
NORMAL_PDF
	:	'normal_pdf';
       
     INV_GAMMA_PDF
     	:	'inv_gamma_pdf';
        
     INV_GAMMA1_PDF
     	:	'inv_gamma1_pdf';
        
      UNIFORM_PDF
      	:	 'uniform_pdf';
       
     INV_GAMMA2_PDF
     	:	'inv_gamma2_pdf';
 DSGE_PRIOR_WEIGHT
 	:	  'dsge_prior_weight';
ESTIMATED_PARAMS
	:	'estimated_params';
VAROBS	: 'varobs';	
ORDER : 'order'; 
DATAFILE: 'datafile';
MH_REPLIC: 'mh_replic';
MH_JSCALE: 'mh_jscale';
NODIAGNOSTIC: 'nodiagnostic';
ESTIMATION  : 'estimation';
NOBS	:	'nobs';
LOGLINEAR
	:	'loglinear';
FIRST_OBS
	:	'first_obs';
MH_NBLOCKS
	:	'mh_nblocks';
AIM_SOLVER
	:	'aim_solver';
//DATASAVER
//	:	 'datasaver';
MODE_COMPUTE
	:	'mode_compute';
MODE_CHECK
	:	'mode_check';
OBSERVATION_TRENDS
	:	'observation_trends';
	UNIT_ROOT_VARS: 'unit_root_vars';
	MH_DROP:
	'mh_drop';
NAME : Letter (Letter|JavaIDDigit)* TRANSP?
//{stringOK=false;System.out.println("NAME setting false");};



;
fragment
Letter : 'a'..'z'|'A'..'Z';


fragment
JavaIDDigit : '0'..'9'|'_';



// isn't ther a right paren missing?
FLOAT_NUMBER  : (((('0'..'9')*'.'('0'..'9')+) |(('0'..'9')+'.'))
(('e'|'E'|'d'|'D')('-'|'+')?('0'..'9')+)?) |
(('0'..'9')+(('e'|'E'|'d'|'D')('-'|'+')?('0'..'9')+));


fragment
Exponent : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
FloatTypeSuffix : ('f'|'F'|'d'|'D') ;

INT_NUMBER : ('0' | '1'..'9' '0'..'9'*) IntegerTypeSuffix? ;

fragment
IntegerTypeSuffix : ('l'|'L') ;


DOT 	:	'.';

//TRANSP 	:{stringOK==false}?=>	'\''{stringOK=true;System.out.println("TRANSP leaving false");};
//QUOTED_STRING :{stringOK==true}?=> '\'' ('\\' ('\\' | '\'') | ~('\\' | '\'' | '\r' | '\n'))* '\'' ;//'"' ~('\\'|'"')* '"';
TRANSP 	:	'\'';
//QUOTED_STRING :TRANSP ('\\' ('\\' | '\'') | ~('\\' | '\'' | '\r' | '\n'))* TRANSP ;//'"' ~('\\'|'"')* '"';
//QUOTED_STRING :'\'' ('\\' ('\\' | '\'') | ~( | '\'' | '\r' | '\n'))* '\'' ;//'"' ~('\\'|'"')* '"';

QUOTED_STRING
:       TRANSP ( ~('\\' | '\'') 
                        | ESCAPED  )* TRANSP ;

fragment
ESCAPED :       '\\'
                ( '\\' 
                | '\'' 
                | 'a'..'z'
                )
        ;


QUOTE_EOL : '\'' ('\\' ('\\' | '\'') | ~('\\' | '\'' | '\r' | '\n'))* ('\r' | '\n') ;


statement_list 
: statement+ ; 
// -> alone means don't add to AST


statement : parameters
    |init_param 
          | var
          | varexo
          | model
          | initval
          | steady->
          | check->
          | simul->
    |shocks
    |observation_trends->
    |unit_root_vars->
   |estimated_params->
   |estimation->
   |varobs->
   |periods->
   |stoch_simul ->
   |endval->
//   |notDynareCode->
	|	matlabStatement->
          ;


observation_trends : OBSERVATION_TRENDS SEMI trend_list END SEMI->;


trend_list :  trend_element+
           ;

trend_element :  NAME OPENPAREN expression CLOSEPAREN SEMI-> ;


unit_root_vars : UNIT_ROOT_VARS symbol_list SEMI-> ;
expression_or_empty 
	:	 | expr->;
estimated_elem3 
	:	 (expr? COMMA (INF|expr)?)+->;

estimated_elem2
:prior COMMA estimated_elem3->
| expr? COMMA expr? COMMA expr? COMMA expr?->
	|	 expr? COMMA expr? COMMA expr?->
		|	 expr? COMMA expr? 
  | expr->
                | expr? COMMA expr? COMMA expr? COMMA prior COMMA estimated_elem3->
                | expr? COMMA prior COMMA estimated_elem3->
                ;
estimated_elem1 : STDERR NAME
                | NAME
                | CORR NAME COMMA NAME
                | DSGE_PRIOR_WEIGHT
                ;
  
  estimated_elem : estimated_elem1 COMMA estimated_elem2 SEMI->;              	
	prior : BETA_PDF
       
      | GAMMA_PDF
       
      | NORMAL_PDF
       
      | INV_GAMMA_PDF
        
      | INV_GAMMA1_PDF
        
      | UNIFORM_PDF
       
      | INV_GAMMA2_PDF
        
      ;

estimation : ESTIMATION SEMI->
           | ESTIMATION OPENPAREN estimation_options_list CLOSEPAREN symbol_list? SEMI->
           | ESTIMATION symbol_list SEMI->
           ;
 o_nobs : NOBS EQUAL vec_int
   | NOBS EQUAL vec_int_number
   ;

vec_int_number : INT_NUMBER ;

vec_int_elem : vec_int_number
             | INT_NUMBER ':' INT_NUMBER
             ;

vec_int_1 : LBRAC COMMA? vec_int_elem (COMMA? vec_int_elem )*;


vec_int : vec_int_1 RBRAC
        | vec_int_1 COMMA RBRAC        
        ;

o_first_obs : FIRST_OBS EQUAL INT_NUMBER ;     
o_mh_nblocks : MH_NBLOCKS EQUAL INT_NUMBER ;     
           
estimation_options  : o_datafile
                   | o_nobs
                   | o_first_obs
 //                  | o_prefilter
 //                  | o_presample
//                   | o_lik_algo
 //                  | o_lik_init
 //                  | o_nograph
 //                  | o_conf_sig
                   | o_mh_replic
                  | o_mh_drop
                   | o_mh_jscale
//                   | o_optim
//                   | o_mh_init_scale
                  | o_mode_file
                   | o_mode_compute
                   | o_mode_check
 //                  | o_prior_trunc
  //                 | o_mh_mode
                   | o_mh_nblocks
 //                  | o_load_mh_file
                   | o_loglinear
                   | o_nodiagnostic
 //                  | o_bayesian_irf
//                   | o_dsge_var
 //                  | o_dsge_varlag
 //                  | o_irf
  //                 | o_tex
   //                | o_forecast
   //                | o_smoother
  //                 | o_moments_varendo
//                   | o_filtered_vars
//                   | o_kalman_algo
 //                  | o_kalman_tol
  //                 | o_xls_sheet
 //                  | o_xls_range
 //                  | o_filter_step_ahead
 //                  | o_solve_algo
 //                  | o_constant
 //                  | o_noconstant
 //                  | o_mh_recover
  //                 | o_diffuse_filter
  //                 | o_plot_priors
                   | o_order
                  | o_aim_solver
 //                  | o_partial_information
 //                  | o_filter_covariance
 //                  | o_filter_decomposition
 //                  | o_selected_variables_only
//                   | o_conditional_variance_decomposition
//                | o_cova_compute
                   ;
                   o_mh_drop : MH_DROP EQUAL non_negative_number ->;
o_mode_file
	: MODE_FILE EQUAL filename ;

o_aim_solver
	:	AIM_SOLVER;
o_loglinear
	:	LOGLINEAR;
o_mode_check : MODE_CHECK ;

o_mode_compute : MODE_COMPUTE EQUAL INT_NUMBER ;
/*	:	o_mh_replic
	|o_mh_jscale
	|o_order
	|o_nodiagnostic
	|o_datafile;*/
estimation_options_list 
	:	 estimation_options  (COMMA!? estimation_options)*;	

symbol_list : NAME (COMMA? NAME)*
             ;

filename : NAME
         | QUOTED_STRING
         ;
estimated_list 
	:	 estimated_elem+;
	

varobs : VAROBS  varobs_list SEMI->;

varobs_list :  NAME (NAME|COMMA NAME)*;


estimated_params : ESTIMATED_PARAMS SEMI estimated_list END SEMI->;	


shock_list : shock_elem+->^(AShockList shock_elem+);
 
shocks 	: SHOCKS SEMI shock_list END SEMI->shock_list;

shock_elem : det_shock_elem 
           | VAR NAME SEMI STDERR expr SEMI->^(AShockVar NAME )
           | VAR NAME EQUAL expr SEMI->^(AShockVar NAME )
           | VAR NAME COMMA NAME EQUAL expr SEMI->^(AShockVar NAME )
           | CORR NAME COMMA NAME EQUAL expr SEMI->^(AShockVar NAME )
           ;

det_shock_elem : VAR NAME SEMI PERIODS period_list SEMI VALUES value_list SEMI->^(AShockVar NAME )
               ;

period_list : (INT_NUMBER|INT_NUMBER COLON! INT_NUMBER) ( COMMA!? (INT_NUMBER|INT_NUMBER COLON! INT_NUMBER))*;


periods : PERIODS INT_NUMBER SEMI->
        
        | PERIODS EQUAL INT_NUMBER SEMI->
          
        ;



value_list
    :(number|expr) (COMMA! (number|expr))*;
 

var : VAR^ var_list SEMI! ;

varexo : VAREXO^ var_list SEMI!;

parameters : PARAMETERS^ var_list SEMI!;

init_param : NAME EQUAL expr SEMI->^(AParamInit NAME expr);



var_list : 
        (NAME|NAME TEX_NAME)  (COMMA!? NAME|COMMA!? NAME TEX_NAME)*;

var_list_noTex : 
        (NAME)  (COMMA!? NAME)*
                ;




number : INT_NUMBER
       | FLOAT_NUMBER
       ;




initval : INITVAL^ SEMI! initval_list END! SEMI! ;

initval_list :  initval_elem+;

initval_elem : NAME^ EQUAL! expr SEMI! ;



//check

check : CHECK SEMI
      ;






//steady


stoch_simul : STOCH_SIMUL SEMI->
             
            | STOCH_SIMUL OPENPAREN stoch_simul_options_list CLOSEPAREN SEMI 
             
            | STOCH_SIMUL symbol_list SEMI
             
            | STOCH_SIMUL OPENPAREN stoch_simul_options_list CLOSEPAREN symbol_list SEMI
              
            ;

stoch_simul_options_list :  stoch_simul_options  (COMMA stoch_simul_options)*;
 

stoch_simul_options : o_dr_algo
//                    | o_solve_algo
//                    | o_simul_algo
//                    | o_linear
                    | o_order
 //                   | o_replic
                    | o_drop
 //                   | o_ar
//                    | o_nocorr
//                    | o_nofunctions
 //                   | o_nomoments
//                    | o_nograph
                    | o_irf
 //                   | o_relative_irf
 //                   | o_hp_filter
 //                   | o_hp_ngrid
                    | o_periods
 //                   | o_simul
 //                   | o_simul_seed
 //                   | o_qz_criterium
  //                  | o_print
 //                   | o_noprint
 //                   | o_aim_solver
 //                   | o_partial_information
  //                  | o_conditional_variance_decomposition
 //                   | o_k_order_solver
 //                 | o_pruning
             ;
 
o_drop : DROP EQUAL INT_NUMBER ;
o_dr_algo : DR_ALGO EQUAL INT_NUMBER ;
o_irf : IRF EQUAL INT_NUMBER ;

steady : STEADY SEMI->
  
       | STEADY OPENPAREN steady_options_list CLOSEPAREN SEMI->
    
       ;

steady_options_list : steady_options (COMMA steady_options)*
                    ;

steady_options : o_solve_algo
               | o_homotopy_mode
               | o_homotopy_steps
               | o_markowitz
               ;
                                 
o_solve_algo : SOLVE_ALGO EQUAL INT_NUMBER ;

o_homotopy_mode : HOMOTOPY_MODE EQUAL INT_NUMBER ;
o_homotopy_steps : HOMOTOPY_STEPS EQUAL INT_NUMBER ;
o_markowitz : MARKOWITZ EQUAL non_negative_number ;

//simul
simul : SIMUL SEMI
      | SIMUL OPENPAREN simul_options_list CLOSEPAREN SEMI;


simul_options_list : simul_options (COMMA simul_options)*
                   ;


simul_options : o_periods
              | o_datafile
              | o_stack_solve_algo
              | o_markowitz
              | o_minimal_solving_periods
              ;
o_minimal_solving_periods : MINIMAL_SOLVING_PERIODS EQUAL non_negative_number ;              
                                          
o_stack_solve_algo : STACK_SOLVE_ALGO EQUAL INT_NUMBER ;
non_negative_number : INT_NUMBER
                    | FLOAT_NUMBER
                    ;

o_order : ORDER EQUAL INT_NUMBER ;

endval : ENDVAL SEMI initval_list END SEMI-> ;


o_datafile : DATAFILE EQUAL filename;
o_mh_replic : MH_REPLIC EQUAL INT_NUMBER ;
o_mh_jscale : MH_JSCALE EQUAL non_negative_number ;
o_nodiagnostic : NODIAGNOSTIC ;



o_linear : LINEAR ;
o_periods : PERIODS EQUAL INT_NUMBER ;


comma_expression : expr ( COMMA expr)*
                 ;



model_options :  o_linear
              ;

model_options_list : model_options (COMMA model_options)*
                   | model_options
                   ;

model : MODEL^ SEMI! 
        equation_list END!   SEMI!?
      | MODEL^ OPENPAREN! model_options_list CLOSEPAREN! SEMI! 
        equation_list END!  SEMI!?
      ;




model_var :  NAME OPENPAREN MINUS INT_NUMBER CLOSEPAREN->^(AModelVarOrParam NAME UMINUS INT_NUMBER)
        |NAME OPENPAREN PLUS? INT_NUMBER CLOSEPAREN->^(AModelVarOrParam NAME UPLUS INT_NUMBER)            ;
signed_integer : PLUS INT_NUMBER->^(INT_NUMBER)
               | MINUS INT_NUMBER->^(UMINUS INT_NUMBER)
  //             | INT_NUMBER->^(INT_NUMBER)
               ;
               
expr	:	mult ((PLUS^|MINUS^) mult )*;
//	|	(MINUS NAME)=>MINUS NAME->^(UMINUS NAME);
//|MINUS expr->^(UMINUS expr);
mult	:	factor ((DIVIDE^|TIMES^) factor)*;
factor 	:	primary (POWER^ factor)?;
primary	:	element;
element	:	FLOAT_NUMBER|model_var|INT_NUMBER
	|	MINUS NAME->^(UMINUS ^(AModelVarOrParam NAME))
	| MINUS element->^(UMINUS element)
	|		OPENPAREN expr CLOSEPAREN ->expr
		|MINUS		OPENPAREN expr CLOSEPAREN ->^(UMINUS expr)
	|NAME->^(AModelVarOrParam NAME)
|LOG^ OPENPAREN! expr CLOSEPAREN!
|LOG10^ OPENPAREN! expr CLOSEPAREN!
|LN^ OPENPAREN! expr CLOSEPAREN!
|COS^ OPENPAREN! expr CLOSEPAREN!
|SIN^ OPENPAREN! expr CLOSEPAREN!
|EXP^ OPENPAREN! expr CLOSEPAREN!
|SQRT^ OPENPAREN! expr CLOSEPAREN!
//	|	nonDynareFunc->
	;
               
               
               
               equation_list :( equation)+->^(AnEquationList equation+)
              ;

equation : hside EQUAL hside SEMI->^(EQUAL hside+)
	|	 expr SEMI->^(EQUAL expr)
         ;
hside	:	expr;


 //              notDynareCode
  //                            	:nonDynareFunc	randomToken SEMI->
   //                           	|NAME  randomToken SEMI->
          //                    	| randomToken (MINUS|PLUS|TIMES|DIVIDE|EQUAL) randomToken->
                 //           |randomToken->
               	//	DATASAVER OPENPAREN filename COMMA LBRAC RBRAC CLOSEPAREN SEMI
//    ;           	
  aTransp
  	:	TRANSP;             		
  /*             		
    randomToken
    	://nonDynareFunc
    	EQUAL randomToken
	| filename
	|LBRAC
	|RBRAC
	|SEMI
	|COMMA
	|COLON
	|DOT
    	|aTransp
 |expr   	
 |equation
    	|QUOTE_EOL   	
    	|nonDynareFunc 
    	;     
 //   	nonDynareFunc: NAME OPENPAREN LBRAC?	(nonDynareFunc aTransp? |expr aTransp?|filename) RBRAC?	
 //   	(COMMA? LBRAC? (nonDynareFunc aTransp?|expr aTransp?|filename) RBRAC?)* CLOSEPAREN
     	nonDynareFunc: NAME OPENPAREN (COLON|COMMA|randomToken)* CLOSEPAREN  
 //   | OPENPAREN COLON CLOSEPAREN	
    ;
  */  
   
matlabStatement
    :   'if' parExpression matlabStatementList ( SEMI 'elseif' parExpression matlabStatementList)* ('else' matlabStatementList)? SEMI 'end' SEMI
    |   'for' NAME '=' (NAME | INT_NUMBER) ':' (NAME | INT_NUMBER) (':' (NAME | INT_NUMBER))? matlabStatementList 'end'  SEMI?
    |   parExpression TRANSP? SEMI?
    |expression TRANSP? SEMI?
    ;

// Expressions
parExpression
    :   OPENPAREN expression CLOSEPAREN//('++'|'--')?
//    | expression
    ;
   
expression
    :   (conditionalOrExpression ((COLON|assignmentOperator) expression)?)//('++'|'--')?
//    |   ('(' conditionalOrExpression (assignmentOperator expression)? ')')('++'|'--')?
   |QUOTED_STRING
    ;
   
assignmentOperator
    :   '='
    |   '+='
    |   '-='
    |   '*='
    |   '/='
    ;

conditionalOrExpression
    :   conditionalAndExpression ( '||' conditionalAndExpression )*
    ;

conditionalAndExpression
    :   equalityExpression ( '&&' equalityExpression )*
    ;

equalityExpression
    :   relationalExpression ( ('==' | '!=') relationalExpression )*
    ;
    
relationalExpression
    :   additiveExpression ( relationalOp additiveExpression )*
    ;
    
relationalOp
    :   '<='
    |   '>='
    |   '<' 
    |   '>' 
    ;

additiveExpression
    :   multiplicativeExpression ( (PLUS | MINUS) multiplicativeExpression TRANSP?)*
    ;

multiplicativeExpression
    :   unaryExpressionNotPlusMinus ( ( DOT|TIMES | DIVIDE|POWER|DOTTIMES|DOTDIVIDE|DOTPOWER ) unaryExpressionNotPlusMinus )*
    ;

unaryExpressionNotPlusMinus
    :   '~' unaryExpressionNotPlusMinus
    |   '!' unaryExpressionNotPlusMinus
        |   MINUS unaryExpressionNotPlusMinus
        |   PLUS unaryExpressionNotPlusMinus
       |   literal 
    |   NAME (identifierSuffix)?
   
    |parExpression TRANSP?
    |LOG^ arguments
|LOG10^ OPENPAREN! arguments CLOSEPAREN!
|LN^ OPENPAREN! arguments CLOSEPAREN!
|COS^ OPENPAREN! arguments CLOSEPAREN!
|SIN^ OPENPAREN! arguments CLOSEPAREN!
|EXP^ OPENPAREN! arguments CLOSEPAREN!
|SQRT^ OPENPAREN! arguments CLOSEPAREN!
//     |quoted_string
//    |   primary ('++'|'--')?
    ;

//primary
 //   :   parExpression
 
 //   ;

literal 
    :   INT_NUMBER (COLON INT_NUMBER)?
    |FLOAT_NUMBER 
    | matExpression TRANSP?
    |   booleanLiteral
    |   'null'
    ;


booleanLiteral
    :   'true'
    |   'false'
    ;

identifierSuffix
    :   (LBRAC RBRAC)+ '.' 'class'
    |   (LBRAC expression RBRAC)+ // can also be matched by selector, but do here
    |   arguments
    ;

expressionList
    :   exprsOrColons (',' exprsOrColons)*
    ;

arguments
    :   OPENPAREN expressionList? CLOSEPAREN
    ;
exprsOrColons 
	:	
	(expression COLON expression|COLON|expression|matExpression);

matExpression 
	:	LBRAC (((PLUS|MINUS)?INF|expression))? (COMMA? ((PLUS|MINUS)?INF|expression))* RBRAC
	;
 
 matlabStatementList
    :   statement+ //(SEMI+ statementList? )
    ;
     
