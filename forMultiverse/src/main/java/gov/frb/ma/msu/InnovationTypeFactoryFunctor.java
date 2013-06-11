package gov.frb.ma.msu;

public class InnovationTypeFactoryFunctor implements SingletonFactoryFunctor {

	public InnovationVarType makeInstance() {
	
		return new InnovationVarType();
	}

}