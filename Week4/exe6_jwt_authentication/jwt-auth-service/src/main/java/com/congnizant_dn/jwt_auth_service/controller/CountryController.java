package com.congnizant_dn.jwt_auth_service.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class CountryController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryController.class);

    @GetMapping("/countries")
    public Map<String, String> getCountries() {
        LOGGER.info("Accessed /countries endpoint");
        return Map.of("message", "Country list accessed!");
    }
}
