package gov.frb.ma.msu;
import java.util.*;
public class SymbolTable implements Scope {
HashMap<String,Symbol> symbols = new HashMap<String,Symbol>();
public SymbolTable(){initTypeSystem();}
	
	public void define(Symbol sym) {
		
symbols.put(sym.name,sym);
	}
protected void initTypeSystem(){}

	public Scope getEnclosingScope() {
		
		return null;
	}

	
	public String getScopeName() {
		
		return "global";
	}

	
	public Symbol resolve(String name) {
		
		return symbols.get(name);
		
	}

}
