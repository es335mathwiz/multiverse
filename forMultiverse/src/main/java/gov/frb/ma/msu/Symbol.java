package gov.frb.ma.msu;

public class Symbol {
String name;
Type type;
String initialValue;
public String getInitialValue() {
	return initialValue;
}
public void setInitialValue(String initialValue) {
	this.initialValue = initialValue;
}
public Symbol(String name){this.name=name;}
public Symbol(String name,Type type){this(name);this.type=type;}
public Symbol(String name,Type type,String initVal){this(name);this.type=type;this.initialValue=initVal;}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public Type getType() {
	return type;
}
public void setType(Type type) {
	this.type = type;
}
}
