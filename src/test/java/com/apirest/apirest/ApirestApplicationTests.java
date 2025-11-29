package com.apirest.apirest;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;
import com.apirest.repository.VerticalScalingRepository;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("test")
class ApirestApplicationTests {

	@MockBean
	private VerticalScalingRepository repository;

	@Test
	void contextLoads() {
		// This test verifies that the Spring context loads successfully
		// Repository is mocked to avoid database connection requirement
	}

}
