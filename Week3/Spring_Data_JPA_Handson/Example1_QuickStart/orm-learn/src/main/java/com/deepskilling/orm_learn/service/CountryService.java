package com.deepskilling.orm_learn.service;

import com.deepskilling.orm_learn.model.Country;
import com.deepskilling.orm_learn.repository.CountryRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
public class CountryService {

    private CountryRepository countryRepository;

    CountryService(CountryRepository countryRepository){
        this.countryRepository = countryRepository;
    }

    public List<Country> getAllCountries(){
        return countryRepository.findAll();
    }

}
