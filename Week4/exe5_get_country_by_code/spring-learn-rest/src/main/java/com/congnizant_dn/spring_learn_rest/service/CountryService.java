package com.congnizant_dn.spring_learn_rest.service;

import com.congnizant_dn.spring_learn_rest.model.Country;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryService.class);

    public Country getCountry(String code) {
        LOGGER.info("START - getCountry({})", code);

        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        List<Country> countryList = (List<Country>) context.getBean("countryList");

        for(Country country : countryList){
            if (country.getCode().equalsIgnoreCase(code)){
                LOGGER.info("END - getCountry()");
                return country;
            }
        }

        LOGGER.info("END - getCountry() - NOT FOUND!!");
        return null;
    }

}
