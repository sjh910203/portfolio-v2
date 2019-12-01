package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration( {
	"file:src/main/webapp/WEB-INF/spring/root-context.xml", 
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
	} )
@Log4j
public class ProductsControllerTests {

	@Setter(onMethod_ = {@Autowired})
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
		
	}
	
	/*
	@Test
	public void homeListTest() throws Exception {
		
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/"))
				.andReturn().getModelAndView().getModelMap());
	}

	@Test
	public void listTest() throws Exception {
		
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/petshop/list"))
				.andReturn().getModelAndView().getModelMap());
	}
	
	@Test
	public void registTest() throws Exception {
	
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/petshop/add")
				.param("productsName", "ControllerTest")
				.param("price", "1000")
				.param("explain", "ControllerTest")
				.param("animalType", "개")
				.param("productsType", "장난감")
				.param("brand", "기타")
				).andReturn().getModelAndView().getViewName();
	
		log.info(resultPage);
	}
	
	@Test
	public void getTest() throws Exception {
		
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/petshop/get")
				.param("productsNo", "26"))
				.andReturn().getModelAndView().getModelMap());
	}
	
	@Test
	public void deleteTest() throws Exception {
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/petshop/delete")
				.param("productsNo", "25"))
				.andReturn().
				getModelAndView()
				.getViewName();
		
		log.info(resultPage);
	}
	
	@Test
	public void updateTest() throws Exception {
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/petshop/update")
				.param("productsNo", "26")
				.param("categoryCode", "111")
				.param("productsName", "updateTest")
				.param("price", "2222")
				.param("explain", "updateTest")).andReturn()
				.getModelAndView()
				.getViewName();
		
		log.info(resultPage);
	}
	
	@Test
	public void testListPaging() throws Exception {
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/petshop/list")
				.param("pageNum", "2")
				.param("amount", "10"))
				.andReturn().getModelAndView().getModelMap());
	}
	*/
}
