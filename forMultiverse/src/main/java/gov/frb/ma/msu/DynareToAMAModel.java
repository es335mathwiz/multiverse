package gov.frb.ma.msu;

import gov.frb.ma.msu.EconXML.AMAModel;
import gov.frb.ma.msu.EconXML.EndogenousVariable;
import gov.frb.ma.msu.EconXML.Equation;
import gov.frb.ma.msu.EconXML.ObjectFactory;

import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import org.antlr.runtime.ANTLRFileStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.tree.CommonTree;
import org.antlr.runtime.tree.CommonTreeNodeStream;
import java.io.File;
public class DynareToAMAModel {
	dynare412Parser d412p;
	public DynareToAMAModel(String modFName,String amaModFName,String strIndx,String newDir) throws Exception{
	

	ANTLRFileStream  theInput = new ANTLRFileStream(newDir+modFName);
	 dynare412Lexer theLexer = new dynare412Lexer(theInput);
   CommonTokenStream theTokens = new CommonTokenStream(theLexer);
   dynare412Parser     theParser  = new dynare412Parser(theTokens);
   dynare412Parser.statement_list_return parsedModel =theParser.statement_list();

CommonTree tree = (CommonTree)parsedModel.getTree();
CommonTreeNodeStream nodes = new CommonTreeNodeStream(tree);
nodes.setTokenStream(theTokens);


List<String> newEquations = new ArrayList<String>();
SymbolTable symtab= new SymbolTable();

SingletonWrapper.setFactory(new ParameterTypeFactoryFunctor());
SingletonWrapper.setInstance(null);
ParameterType paramType = (ParameterType)SingletonWrapper.instance();
SingletonWrapper.setFactory(new LagLeadTypeFactoryFunctor());
SingletonWrapper.setInstance(null);
LagLeadVarType llVarType = (LagLeadVarType)SingletonWrapper.instance();
SingletonWrapper.setFactory(new InnovationTypeFactoryFunctor());
SingletonWrapper.setInstance(null);
InnovationVarType innovType = (InnovationVarType)SingletonWrapper.instance();

dynare412Tree  walker = new dynare412Tree(nodes,newEquations,symtab,paramType,llVarType,innovType);





dynare412Tree.statement_list_return statement_listTree=walker.statement_list(newEquations,symtab,paramType,llVarType,innovType);	
	
	


ObjectFactory objFactory = new ObjectFactory();

AMAModel statement_list = objFactory.createAMAModel();
String modName = statement_list.getModelName();
String newModName = strIndx;

statement_list.setModelName(newModName);
EndogenousVariable endV =objFactory.createEndogenousVariable();
gov.frb.ma.msu.EconXML.Parameter paramV = objFactory.createParameter();
gov.frb.ma.msu.EconXML.Innovation innovV = objFactory.createInnovation();
endV.setDescription("aDescription");
endV.setName("atestName");
HashMap<String,Symbol> aSet=symtab.symbols;

Iterator<String> iterator = aSet.keySet().iterator();
List<Object> modAccessor=statement_list.getEndogenousVariableOrExogenousVariableOrParameter();
while( iterator.hasNext() ){
String theKey=iterator.next();
if(aSet.get(theKey).getType()==llVarType)
{
endV =objFactory.createEndogenousVariable();
endV.setName(AMASubs(theKey));
statement_list.getEndogenousVariableOrExogenousVariableOrParameter().add(endV);
} else if(aSet.get(theKey).getType()==paramType){
	paramV =objFactory.createParameter();
	paramV.setName(AMASubs(theKey));
	String initVal=aSet.get(theKey).getInitialValue();
	if(initVal!=null)	paramV.setDefaultValue(AMASubs(initVal));
	else 	paramV.setDefaultValue("$noDefaultValue");
		
	modAccessor.add(paramV);
	}
else if(aSet.get(theKey).getType()==innovType){
	innovV =objFactory.createInnovation();
	innovV.setName(AMASubs(theKey));
	modAccessor.add(innovV);
	}
}




Iterator<String> eqiterator = newEquations.iterator();

while( eqiterator.hasNext() ){
Equation anEq =objFactory.createEquation();
anEq.setValue(AMASubs((String)eqiterator.next()));
modAccessor.add(anEq);
} 



JAXBContext jaxContext = JAXBContext.newInstance( "gov.frb.ma.msu.EconXML" );
Marshaller mrshllr = jaxContext.createMarshaller();
mrshllr.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
mrshllr.marshal( statement_list, new FileWriter(amaModFName) );
	}
	public static String AMASubs(String oldStr){
	return(	oldStr.replaceAll("_", "\\$U\\$S\\$").replaceAll("([^a-zA-Z])N([^a-zA-Z0-9])","$1\\$notN$2").replaceAll("^N$","\\$notN").replaceAll("^N([^a-zA-Z0-9])","\\$notN$1").replaceAll("([^a-zA-Z0-9])N$","$1\\$notN"));
	}
	public static void main(String[] args)throws Exception{
		DynareToAMAModel dta;
		dta =new DynareToAMAModel("g:/RES2/sce11/dynareExamples/examples/fs2000ns.mod","g:/RES2/sce11/dynareExamples/examples/AltEx1.xml","trynot");
	}

	public DynareToAMAModel(String modFName,String amaModFName,String strIndx) throws Exception{

	this(modFName,amaModFName,strIndx,".");

	
	String current = new java.io.File( "." ).getCanonicalPath();
    System.out.println("Current dir after this:"+current);
String currentDir = System.getProperty("user.dir");
    System.out.println("Current dir using System  after this:" +currentDir);

	
	    		
		}
	}	
	
	
	
	

