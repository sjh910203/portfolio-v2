package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReviewsPageDTO;
import org.zerock.domain.ReviewsVO;
import org.zerock.mapper.ReviewsMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class ReviewsServiceImpl implements ReviewsService{
	
	private final ReviewsMapper mapper;

	@Override
	public int register(ReviewsVO vo) {
		
		log.info("register " + vo);
		
		return mapper.insert(vo);
	}

	@Override
	public ReviewsVO get(Long reviewsNo) {
		
		log.info("get " + reviewsNo);
		
		return mapper.read(reviewsNo);
	}
	
	@Override
	public int modify(ReviewsVO vo) {
		
		log.info("modify " + vo);
		
		return mapper.update(vo);
	}

	@Override
	public int remove(Long reviewsNo) {
		
		log.info("remove " + reviewsNo);
		
		return mapper.delete(reviewsNo);
	}

	@Override
	public List<ReviewsVO> getList(Criteria cri, Long productsNo) {
		
		log.info("get reviews List of a Products " + productsNo);
		
		return mapper.getListWithPaging(cri, productsNo);
	}

	@Override
	public ReviewsPageDTO getListPage(Criteria cri, Long productsNo) {
		
		log.info("get reviews List of a Products " + productsNo);
		
		return new ReviewsPageDTO(mapper.getCountByPno(productsNo), mapper.getListWithPaging(cri, productsNo));
	}

}
