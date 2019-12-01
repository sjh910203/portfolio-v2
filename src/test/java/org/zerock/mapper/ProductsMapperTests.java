package org.zerock.mapper;

import java.util.List;

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
public class ProductsMapperTests {

	@Setter(onMethod_ = @Autowired)
	private ProductsMapper mapper;
	
	/*
	@Test
	public void testGetList() {
		mapper.getHomeList().forEach(products -> log.info(products));
	}
	
	@Test
	public void testInsert() {
		ProductsVO products = new ProductsVO();
		
		products.setCategoryCode(101);
		products.setProductsName("mapper 테스트용 상품");
		products.setPrice(1000);
		products.setExplain("mapper 테스트용 상품");
		
		mapper.addProducts(products);
		
		log.info(products);
	}
	
	@Test
	public void testGet() {
		ProductsVO products = mapper.getProducts(5L);
		
		log.info(products);
	}
	
	@Test
	public void testDelete() {
		log.info("DELETE COUNT: " + mapper.deleteProducts(21L));
	}
	
	@Test
	public void updateTest() {
		
		ProductsVO products = new ProductsVO();
		
		products.setProductsNo(22L);
		products.setCategoryCode(101);
		products.setProductsName("mapper 테스트용 상품");
		products.setPrice(1000);
		products.setExplain("mapper 테스트용 상품");
		
		int count = mapper.updateProducts(products);
		log.info("UPDATE COUNT : " + count);
	}
	
	@Test
	public void testPaging() {
		
		Criteria cri = new Criteria();
		cri.setPageNum(2);
		cri.setAmount(10);
		
		List<ProductsVO> list = mapper.getListWithPaging(cri);
		
		list.forEach(products -> log.info(products));
	}
	
	@Test
	public void testTypeList() {
		Criteria cri = new Criteria();
		cri.setKeyword("고양이");
		cri.setType("a");
		
		List<ProductsVO> list = mapper.getListWithPaging(cri);
		
		list.forEach(products -> log.info(products));
	}
	*/
}
