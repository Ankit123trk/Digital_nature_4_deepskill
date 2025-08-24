package com.cognizant_dn.spring_learn;

import com.cognizant_dn.spring_learn.model.Country;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

@SpringBootApplication
public class SpringLearnApplication {

	public static void displayCountry() {
		ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
		Country country = (Country) context.getBean("country", Country.class);
		System.out.println("Country: " + country);
	}

	public static void main(String[] args) {
		SpringApplication.run(SpringLearnApplication.class, args);
		displayCountry();
	}

}
