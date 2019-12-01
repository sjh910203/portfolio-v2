package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReviewsPageDTO;
import org.zerock.domain.ReviewsVO;

public interface ReviewsService {
	
	public int register(ReviewsVO vo);
	
	public ReviewsVO get(Long reviewsNo);
	
	public int modify(ReviewsVO vo);
	
	public int remove(Long reviewsNo);
	
	public List<ReviewsVO> getList(Criteria cri, Long productsNo);
	
	public ReviewsPageDTO getListPage(Criteria cri, Long productsNo);
}
