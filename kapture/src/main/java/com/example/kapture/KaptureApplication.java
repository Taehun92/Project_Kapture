package com.example.kapture;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication
public class KaptureApplication {
	
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(KaptureApplication.class);
    }
	
	public static void main(String[] args) {
		SpringApplication.run(KaptureApplication.class, args);
	}
	
}
