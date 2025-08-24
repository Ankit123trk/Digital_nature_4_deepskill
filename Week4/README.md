# Week 04 – Assignments

This week includes hands-on exercises focused on:

- Spring Web with Spring Boot
- RESTful Web Services
- JWT-based Authentication
- Basic Authentication and Authorization using Spring Security

---

## 1. Spring REST using Spring Boot 3

### 🔹 [Exercise 1: Create Spring Web Project](./exe1_create_web_project/)
- Generated Spring Boot project using Spring Initializr
- Verified application structure and main class

### 🔹 [Exercise 2: Load Country from Spring XML](./exe2_load_country_from_xml/)
- Defined bean in `country.xml`
- Loaded it using `ClassPathXmlApplicationContext`

### 🔹 [Exercise 3: Hello World REST Web Service](./exe3_hello_world_rest//)
- Created a simple REST controller returning "Hello World!!"

### 🔹 [Exercise 4: Country Web Service](./exe4_country_web_service)
- Created `/country` REST endpoint
- Loaded `Country` bean from XML and returned as JSON

### 🔹 [Exercise 5: Get Country by Code](./exe5_get_country_by_code)
- Read list of countries from `country.xml`
- Returned a country object based on path variable (code)

---

## 2. JWT Authentication

### 🔹 [Exercise 6: JWT Authentication Service](./exe6_jwt_authentication/jwt-auth-service)
- Implemented `/authenticate` endpoint using Basic Auth
- Generated JWT token using `jjwt` library
- Returned token as JSON on successful login

---

## Tools / Frameworks Used

- Spring Boot
- Spring Web
- Spring Security
- jjwt (Java JWT)
- Postman / curl
