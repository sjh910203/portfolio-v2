package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReviewsVO;

public interface ReviewsMapper {
	
	public int insert(ReviewsVO vo);
	
	public ReviewsVO read(Long reviewsNo);
	
	public int delete(Long reviewsNo);
	
	public int update(ReviewsVO vo);
	
	public List<ReviewsVO> getListWithPaging(@Param("cri") Criteria cri, 
			@Param("productsNo") Long productsNo);
	
	public int getCountByPno(Long productsNo);
}
