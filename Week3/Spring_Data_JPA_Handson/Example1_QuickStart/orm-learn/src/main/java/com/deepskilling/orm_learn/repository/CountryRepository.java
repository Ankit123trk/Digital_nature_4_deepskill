package com.deepskilling.orm_learn.repository;

import com.deepskilling.orm_learn.model.Country;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CountryRepository extends JpaRepository<Country, String> {

}
