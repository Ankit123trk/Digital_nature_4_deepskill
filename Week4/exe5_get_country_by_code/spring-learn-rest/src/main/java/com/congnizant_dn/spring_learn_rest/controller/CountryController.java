package com.congnizant_dn.spring_learn_rest.controller;

import com.congnizant_dn.spring_learn_rest.model.Country;
import com.congnizant_dn.spring_learn_rest.service.CountryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CountryController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryController.class);

    @Autowired
    private CountryService countryService;

    @GetMapping("/countries/{code}")
    public Country getCountryIndia(@PathVariable String code){
        LOGGER.info("START - getCountryIndia()");
        Country country = countryService.getCountry(code);
        LOGGER.info("END - getCountryIndia()");
        return country;
    }

}
