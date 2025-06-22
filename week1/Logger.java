
package singletonpatternexample;
public class Logger {
	// private static instance of the class
    private static Logger singleInstance;

    //  Private constructor 
    private Logger() {
        System.out.println("Logger Initialized.");
    }

   
    public static Logger getInstance() {
        if (singleInstance == null) {
            singleInstance = new Logger();
        }
        return singleInstance;
    }

    
    public void log(String message) {
        System.out.println("Log Message: " + message);
    }
}
