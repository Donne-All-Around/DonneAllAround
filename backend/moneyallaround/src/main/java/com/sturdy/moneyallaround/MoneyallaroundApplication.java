package com.sturdy.moneyallaround;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication(scanBasePackages = "com.sturdy.moneyallaround")
public class MoneyallaroundApplication {

	public static void main(String[] args) {
		SpringApplication.run(MoneyallaroundApplication.class, args);
	}

}
