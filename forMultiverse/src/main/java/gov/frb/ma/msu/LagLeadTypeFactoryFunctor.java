package gov.frb.ma.msu;

public class LagLeadTypeFactoryFunctor implements SingletonFactoryFunctor {

	public LagLeadVarType makeInstance() {
	
		return new LagLeadVarType();
	}

}
