package com.deepskilling.orm_learn.model;

import jakarta.persistence.*;

@Entity
@Table(name = "country")
public class Country {
    @Id
    @Column(name = "code")
    private String code;

    @Column(name = "name")
    private String name;

    @Column(name = "population")
    private Long population;

    @Column(name = "capital")
    private String capital;

    @Column(name = "currency")
    private String currency;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getPopulation() {
        return population;
    }

    public void setPopulation(Long population) {
        this.population = population;
    }

    public String getCapital() {
        return capital;
    }

    public void setCapital(String capital) {
        this.capital = capital;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}
