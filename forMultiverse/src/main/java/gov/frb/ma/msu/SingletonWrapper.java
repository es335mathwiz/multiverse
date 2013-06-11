package gov.frb.ma.msu;

public final class SingletonWrapper {
	   /**
	    * A reference to a possibly alternate factory.
	    */
	 
	   static private SingletonFactoryFunctor _factory = null;

	   /**
	    * A reference to the current instance.
	    */
	   static private Singleton _instance = null;
	 

	   /**
	    * This is the default factory method.
	    * It is called to create a new Singleton when
	    * a new instance is needed and _factory is null.
	    */
	   static private Singleton makeInstance() {
	      return new Singleton();
	   }

	   /**
	    * This is the accessor for the Singleton.
	    */
	   static public synchronized Singleton instance() {
	      if(null == _instance) {
	         _instance = (null == _factory) ? makeInstance() : _factory.makeInstance();
	      }
	      return _instance;
	   }
	 
	   /**
	    * Sets the factory method used to create new instances.
	    * You can set the factory method to null to use the default method.
	    * @param factory The Singleton factory
	    */
	   static public synchronized void setFactory(SingletonFactoryFunctor factory) {
	      _factory = factory;
	   }
	 
	   /**
	    * Sets the current Singleton instance.
	    * You can set this to null to force a new instance to be created the
	    * next time instance() is called.
	    * @param instance The Singleton instance to use.
	    */
	   static public synchronized void setInstance(Singleton instance) {
	      _instance = instance;
	   }
	 

}
