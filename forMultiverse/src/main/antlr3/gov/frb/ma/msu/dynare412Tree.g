tree grammar dynare412Tree;
options {
tokenVocab=dynare412;
ASTLabelType=CommonTree;
output=AST;
backtrack=true;//without backtrack multiple alternatives match model comparison
}


@header {
package gov.frb.ma.msu;
import  java.util.List;
import  java.util.ArrayList;
import java.util.Iterator;

}
@members{
SymbolTable symtab;
ParameterType param;
LagLeadVarType llVar;
InnovationVarType innovVar;
List<String> equations;
   public dynare412Tree(CommonTreeNodeStream input, 
List<String> equations,SymbolTable symtab,ParameterType param,
LagLeadVarType llVar, InnovationVarType innovVar)
    {
        this(input);
        this.equations=equations;
        this.symtab = symtab;
        this.param=param;
        this.llVar=llVar;
        this.innovVar=innovVar;
    } 
void print(String ss){System.out.print(ss);}

}


statement_list[List<String> equations,SymbolTable symtab,ParameterType param,LagLeadVarType llVar, InnovationVarType innovVar] 	@init{
this.equations=equations;
this.symtab=symtab;
this.param=param;
this.llVar=llVar;
this.innovVar=innovVar;
}
: statement+ ; 
// -> alone means don't add to AST


statement : parameters
    |init_param 
          | var
          | varexo
          | model
          | initval
          | steady
          | check
          | simul
          |shocks
          ;
shocks	:shock_list;//	^(AShockList (^(AStderr NAME expr[equations]))+){System.out.println("tree walker found shocks");};
shock_list
	:^(AShockList shock_elem+);
	
	shock_elem:^(AShockVar nm=NAME ){
if(  symtab.symbols.containsKey($nm.text)  ){symtab.symbols.get($nm.text).setType(innovVar);} else
 {
Symbol innov = new Symbol($nm.text,innovVar);
symtab.define(innov);}
 
}
	|^(ACorr NAME expression);
	
var : ^(VAR vnms=var_list) {
Iterator itr = $var_list.nameList.iterator();
while(itr.hasNext()) {
Object element = itr.next(); 
if(  symtab.symbols.containsKey(element.toString())  ){} else {
Symbol newLagLead = new Symbol(element.toString(),llVar);
symtab.define(newLagLead);}
} 

}
;



varexo : ^(VAREXO var_list){
Iterator itr = $var_list.nameList.iterator();
while(itr.hasNext()) {
Object element = itr.next(); 
String innovName=element.toString();
 if(  symtab.symbols.containsKey(innovName)  ){symtab.symbols.get(innovName).setType(innovVar);} else
 {
Symbol innov = new Symbol(innovName,innovVar);
symtab.define(innov);}
}
}
;

parameters : ^(PARAMETERS var_list){
Iterator itr = $var_list.nameList.iterator();
while(itr.hasNext()) {
Object element = itr.next(); 
 
if(  symtab.symbols.containsKey(element.toString())  ){} else {
Symbol newParam = new Symbol(element.toString(),param);
symtab.define(newParam);}
} 

}
;

init_param : ^(AParamInit vn=NAME expVal=expression){

if(  symtab.symbols.containsKey($vn.text)  ){
Symbol element = symtab.symbols.get($vn.text);
element.setInitialValue($expVal.text);
} else {
Symbol newParam = new Symbol($vn.text,param);
symtab.define(newParam);
Symbol element = symtab.symbols.get($vn.text);
element.setInitialValue($expVal.text);}


};



var_list returns [List<Token> nameList]:
(nm+=NAME|nm+=NAME TEX_NAME!)+{
$nameList=$nm;      
        };


var_list_noTex : 
        (NAME)+
                ;




number : INT_NUMBER
       | FLOAT_NUMBER
       ;




initval : ^(INITVAL initval_list ) ;

initval_list :  initval_elem+;

initval_elem : ^(NAME expression);



//check

check : CHECK SEMI
      ;






//steady


steady : STEADY SEMI
       ;



//simul
simul : SIMUL SEMI
      | SIMUL OPENPAREN simul_options_list CLOSEPAREN SEMI
      ;

simul_options_list : simul_options (COMMA simul_options)*
                   ;

simul_options : o_periods
              ;





//options
o_linear : LINEAR ;
o_periods : PERIODS EQUAL INT_NUMBER ;

//expression
//expression returns [String expStr]:  theVar=model_var{$expStr=$theVar.text;}
//| val=FLOAT_NUMBER	{$expStr=$val.text;}
//| val=INT_NUMBER {$expStr=$val.text;}
//|^(un=(PLUS|MINUS|UMINUS) exp=expression){$expStr="("+$un.text+"("+$exp.text+"))";}
//|^(op=(PLUS|MINUS|TIMES|DIVIDE|POWER) exp1=expression exp2=expression) 
//   {$expStr="("+$exp1.text+$op.text+$exp2.text+")";}
//|^(blf=begLeftFunc rest=expression) {$expStr=$blf.text+"["+$rest.text+"]";}
/*|^(NAME  expression+) */
//;
expression returns [String expStr]
	:	 theStr=expr[equations]{$expStr=$theStr.text;};

begLeftFunc returns [String expStr]: EXP {$expStr="exp";}
	| LOG {$expStr="Log";}
	| LOG10 {$expStr="Log10";}
	| SIN {$expStr="Sin";}
	| COS {$expStr="Cos";}
	| TAN {$expStr="Tan";}
	| ASIN {$expStr="Asin";}
	| ACOS {$expStr="Acos";}
	| ATAN {$expStr="Atan";}
	| SQRT {$expStr="Sqrt";};
 	



comma_expression : expression ( COMMA expression)*
                 ;



model_options :  o_linear
              ;

model_options_list : model_options (COMMA model_options)*
                   | model_options
                   ;

model : ^(MODEL model_options_list?         equation_list)
{
Iterator itr = equations.iterator();
while(itr.hasNext()) {
Object element = itr.next(); 
 
    };
};

equation_list:^(AnEquationList equation+){ 
Iterator itr = equations.iterator();
while(itr.hasNext()) {

    Object element = itr.next(); 
    

} 
    
        };
              

equation  : ^(EQUAL exp=handside)
{
equations.add($exp.expStr);
}
	|	 ^(EQUAL exp1=handside exp2=handside)
{

equations.add($exp1.expStr+"-("+$exp2.expStr+")");

}
         ;

//model_var returns [String expStr]://^(AModelVarOrParam theNm=NAME){$expStr=$theNm.text;}|
//^(AModelVarOrParam theNm=NAME theInt=signed_integer)
//{$expStr=$theNm.text+"[t+"+$theInt.text+"]";};
//^(AModelVarOrParam theNm=NAME theInt=UMINUS INT_NUMBER)
//{$expStr=$theNm.text+"[t+"+$theInt.text+"]";};

//signed_integer returns [String expStr]: ^(num=INT_NUMBER)
//{$expStr=$num.text;}
//	|	^(UMINUS INT_NUMBER)
//	{$expStr="(-1)"+$num.text;}
//               ;
expr[List<String> equations] returns [String str]	:	^(PLUS ex1=expr[equations] ex2=expr[equations])
{$str= "("+ $ex1.str+"+"+ $ex2.str+")";}
|^(MINUS ex1=expr[equations] ex2=expr[equations])
{$str="("+ $ex1.str+"-"+ $ex2.str+")";}
|^(TIMES ex1=expr[equations] ex2=expr[equations])
{$str="("+ $ex1.str+"*"+ $ex2.str+")";}
|^(DIVIDE ex1=expr[equations] ex2=expr[equations])
{$str="("+ $ex1.str+"/"+ $ex2.str+")";}
|^(POWER ex1=expr[equations] ex2=expr[equations])
{$str="("+ $ex1.str+"^"+ $ex2.str+")";}
|^(UMINUS  ex=expr[equations])
{$str="(-"+ $ex.str+")";}
|prim=element
{$str=$prim.str;}
;
element returns [String str]	:	
aFloat=FLOAT_NUMBER {$str=$aFloat.text;}

|anint=INT_NUMBER{$str=$anint.text;}
|^(AModelVarOrParam vn=NAME){
if(  symtab.symbols.containsKey($vn.text)  ){
if(symtab.symbols.get($vn.text).getType()==llVar)
{$str=$vn.text+"[t]";} else{$str=$vn.text;}
}else{
$str=$vn.text;
}}
	|	^(AModelVarOrParam vn=NAME UMINUS theInt=INT_NUMBER){
if(  symtab.symbols.containsKey($vn.text)  ){

if(symtab.symbols.get($vn.text).getType()==llVar)
{$str=$vn.text+"[t-"+$theInt+"]";} else{$str=$vn.text;}
}else{
$str=$vn.text;
}}
	|	^(AModelVarOrParam vn=NAME UPLUS? theInt=INT_NUMBER){
if(  symtab.symbols.containsKey($vn.text)  ){
if(symtab.symbols.get($vn.text).getType()==llVar)
{$str=$vn.text+"[t+"+$theInt+"]";} else{$str=$vn.text;}
}else{
$str=$vn.text;
}}
|^(LOG  ex=expr[equations]){$str="Log["+$ex.str+"]";}
|^(LOG10  ex=expr[equations]){$str="Log[10,"+$ex.str+"]";}
|^(LN  ex=expr[equations]){$str="Log["+$ex.str+"]";}
|^(COS  ex=expr[equations]){$str="Cos["+$ex.str+"]";}
|^(SIN ex=expr[equations]){$str="Sin["+$ex.str+"]";}
|^(EXP  ex=expr[equations]){$str="Exp["+$ex.str+"]";}
|^(SQRT  ex=expr[equations]){$str="Sqrt["+$ex.str+"]";}
    ;
handside returns[String expStr]
	:	 theStr=expr[equations]{$expStr=$theStr.str;};
