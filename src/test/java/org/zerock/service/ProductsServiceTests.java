package org.zerock.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ProductsVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ProductsServiceTests {

	@Setter(onMethod_ = @Autowired)
	private ProductsService service;
	
	/*
	@Test
	public void testExist() {
		
		log.info(service);
		assertNotNull(service);
	}
	
	@Test
	public void testGetProducts() {
		
		log.info(service.getProducts(25L));
		
	}
	
	@Test
	public void testGetList() {
		service.getListWithPaging(new Criteria(2, 10)).forEach(products -> log.info(products));
	}
	
	@Test
	public void addProductsTest() {
		ProductsVO products = new ProductsVO();
		products.setCategoryCode(101);
		products.setProductsName("add products test");
		products.setPrice(1000);
		products.setExplain("add products test");
		
		service.addProducts(products);
		
		log.info("add products : " + products.getProductsNo());
	}
	
	@Test
	public void deleteProductsTest() {
		log.info("before");
		log.info(service.getList());
		
		log.info(service.deleteProducts(23L));
		
		log.info("after");
		log.info(service.getList());
	}
	
	@Test
	public void updateProductsTest() {
		
		log.info("before");
		log.info(service.getList());
		
		ProductsVO products = service.getProducts(24L);
		
		if(products == null) {
			return;
		}
		
		products.setCategoryCode(102);
		products.setProductsName("update products test");
		products.setPrice(3000);
		products.setExplain("update products test");
		
		service.updateProducts(products);
		
		log.info("after");
		log.info(service.getList());
	}
	
	@Test
	public void testGetHomeList() {
		service.getHomeList().forEach(products -> log.info(products));
	}
	
	@Test
	public void testListByBrand() {
		String brand = "CJ";
		
		service.getListByBrand(brand).forEach(products -> log.info(products));
	}
	
	@Test
	public void testListByAnimalType() {
		String animalType = "개";
		
		service.getListByAnimalType(animalType).forEach(products -> log.info(products));
	}
	*/
}
