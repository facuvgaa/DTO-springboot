package com.apirest.apirest;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class ApirestApplicationTests {

	@Test
	void contextLoads() {
		// This test verifies that the Spring context loads successfully
		// Database connection is not required for this test
	}

}
