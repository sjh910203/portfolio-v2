package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReviewsVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReviewsMapperTest {

	private Long[] productsNoArr = {261L, 262L, 263L, 264L, 265L};
	
	@Setter(onMethod_ = @Autowired)
	private ReviewsMapper mapper;

	/*
	@Test
	public void testMapper() {
		log.info(mapper);
	}
	
	@Test
	public void testCreate() {
		
		IntStream.rangeClosed(1, 10).forEach(i -> {
			
			ReviewsVO vo = new ReviewsVO();
			
			vo.setProductsNo(productsNoArr[i % 5]);
			vo.setReviews("상품평 테스트 " + i);
			vo.setReviewer("reviewer " + i);
			
			mapper.insert(vo);
		});
	}
	
	@Test
	public void testRead() {
		Long targetRno = 2L;
		
		ReviewsVO vo = mapper.read(targetRno);
		
		log.info(vo);
	}
	
	@Test
	public void testDelete() {
		Long targetRno = 3L;
		
		mapper.delete(targetRno);
		
		ReviewsVO vo = mapper.read(targetRno);
		
		log.info(vo);
	}
	
	@Test
	public void testUpdate() {
		Long targetRno = 2L;
		
		ReviewsVO vo = mapper.read(targetRno);
		
		vo.setReviews("업데이트 테스트");
		
		int count = mapper.update(vo);
		
		log.info("update count : " + count);
		
		log.info(vo);
	}
	*/
	
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		
		List<ReviewsVO> review = mapper.getListWithPaging(cri, productsNoArr[0]);
		
		review.forEach(reviews -> log.info(review));
	}
}
