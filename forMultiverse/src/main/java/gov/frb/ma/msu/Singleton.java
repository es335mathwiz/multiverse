package gov.frb.ma.msu;

public class Singleton {

    private static final Singleton me= new Singleton();

   public Singleton()   {
 
    }

   static public synchronized Singleton getInstance() {
      return me;
    }
}
