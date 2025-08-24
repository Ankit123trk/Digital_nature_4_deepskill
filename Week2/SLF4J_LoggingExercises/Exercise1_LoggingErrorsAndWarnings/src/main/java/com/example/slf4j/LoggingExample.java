package com.example.slf4j;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoggingExample {

    private static final Logger logger = LoggerFactory.getLogger(LoggingExample.class);

    public static void main(String[] args) {
        logger.error("This is a error message for Exercise 1: Logging Error Messages and Warning Levels");
        logger.warn("This is a warning message for Exercise 1: Logging Error Messages and Warning Levels");
    }
}
