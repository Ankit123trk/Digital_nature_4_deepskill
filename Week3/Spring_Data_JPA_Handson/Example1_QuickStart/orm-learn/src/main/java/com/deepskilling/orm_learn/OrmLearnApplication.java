package com.deepskilling.orm_learn;

import com.deepskilling.orm_learn.model.Country;
import com.deepskilling.orm_learn.service.CountryService;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

@SpringBootApplication
public class OrmLearnApplication {

	public static void main(String[] args) {
		ApplicationContext context = SpringApplication.run(OrmLearnApplication.class, args);
		CountryService countryService = context.getBean(CountryService.class);
		List<Country> countriesData = countryService.getAllCountries();
		System.out.println("Country Data : ");
		for (Country country : countriesData) {
			System.out.println("Country Code: " + country.getCode());
			System.out.println("Country Name: " + country.getName());
			System.out.println("Population: " + country.getPopulation());
			System.out.println("Capital: " + country.getCapital());
			System.out.println("Currency: " + country.getCurrency());
			System.out.println("-------------------------------");
		}
	}
}
