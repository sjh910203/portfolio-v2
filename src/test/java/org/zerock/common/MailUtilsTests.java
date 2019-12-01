package org.zerock.common;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/**.xml")
@Log4j
public class MailUtilsTests {

	@Test
	public void messageTests() {
		log.info("error.BadCredentials : " + MessageUtils.getMessage("error.BadCredentials"));
	}
	
}
