package com.example.phanlamtuankiet;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("/")
	public String hello() {
		return "Hello from Phan Lâm Tuấn Kiệt!";
	}

	@GetMapping("/api/status")
	public String status() {
		return "Application is running!";
	}
}
