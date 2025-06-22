package singletonpatternexample;

public class LoggerTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
        Logger logger1 = Logger.getInstance();
        Logger logger2 = Logger.getInstance();

        logger1.log("This is the first log message.");
        logger2.log("This is the second log message.");

       
        if (logger1 == logger2) {
            System.out.println("Both logger instances are the same.");
        } else {
            System.out.println("Logger instances are different!");
        }
	}

}
