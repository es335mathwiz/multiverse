package gov.frb.ma.msu;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import generated.*;
import javax.xml.bind.Marshaller;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;

/**
 * Hello world!
 *
 */
public class makeXml
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );



    }

    public static void setFields ()
    {
	//JAXBContext jc = JAXBContext.newInstance("test.jaxb");



ObjectFactory objFactory = new ObjectFactory();
AMAModel model= (AMAModel) objFactory.createAMAModel();
Equation equation01= (Equation) objFactory.createEquation();
Equation equation02= (Equation) objFactory.createEquation();


model.setModelName("firstModel");
equation01.setValue("77");
equation01.setDescription("this is a trivial equation");
equation02.setValue("99");
model.getEndogenousVariableOrExogenousVariableOrParameter().add(equation01);
model.getEndogenousVariableOrExogenousVariableOrParameter().add(equation02);
model.getEndogenousVariableOrExogenousVariableOrParameter().add(equation01);
try {
JAXBContext jaxbContext = JAXBContext.newInstance("generated");
Marshaller marshaller = jaxbContext.createMarshaller();
marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT,
   new Boolean(true));
try {
    //Validator validator = jaxbContext.createValidator(); this is the pre 2.0
    //System.out.println("\nValidator returned: " +
    //         validator.validate(model )+" after changing the promotion");
marshaller.marshal(model,
   new FileOutputStream("jaxbOutput.xml"));
} catch (FileNotFoundException ee) {
System.out.println("jaxbOutput.xml not found");
}
} catch(JAXBException ee){
    ee.printStackTrace();
System.out.println("There has been a problem either creating the "+ "context for package '");
}


}

}
