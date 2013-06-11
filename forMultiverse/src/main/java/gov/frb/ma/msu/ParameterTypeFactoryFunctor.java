package gov.frb.ma.msu;

public class ParameterTypeFactoryFunctor implements SingletonFactoryFunctor {

	
	public ParameterType makeInstance() {
	
		return new ParameterType();
	}

}
