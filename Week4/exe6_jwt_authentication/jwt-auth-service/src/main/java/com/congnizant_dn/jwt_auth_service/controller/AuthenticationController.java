package com.congnizant_dn.jwt_auth_service.controller;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.util.*;

@RestController
public class AuthenticationController {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticationController.class);

    private final String secretKey = "secret";

    @GetMapping("/authenticate")
    public ResponseEntity<Map<String, String>> authenticate(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        LOGGER.info("START - /authenticate");

        if (authHeader == null || !authHeader.startsWith("Basic ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Missing or invalid Authorization header"));
        }

        String base64Credentials = authHeader.substring("Basic ".length());
        byte[] decodedBytes = Base64.getDecoder().decode(base64Credentials);
        String credentials = new String(decodedBytes, StandardCharsets.UTF_8);
        String[] parts = credentials.split(":", 2);

        if (parts.length != 2) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid Authorization format"));
        }

        String username = parts[0];
        String password = parts[1];

        LOGGER.info("Decoded credentials - user: {}", username);

        if (!username.equals("user") || !password.equals("pwd")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid credentials"));
        }

        String token = Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 3600 * 1000)) // 1 hour
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();

        LOGGER.info("Generated Token");

        return ResponseEntity.ok(Map.of("token", token));
    }
}
