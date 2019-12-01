package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ProductsVO;

public interface ProductsMapper {
	
	// 인덱스 페이지 리스트
	public List<ProductsVO> getHomeList();
	
	// 페이징
	public List<ProductsVO> getListWithPaging(Criteria cri);
	
	// 상품 정보 출력
	public ProductsVO getProducts(Long productsNo);
	
	//public void addProducts(ProductsVO products); 
	
	public void insertSelectKey(ProductsVO products);
	
	public int deleteProducts(Long productsNo);
	
	public int updateProducts(ProductsVO products);
	
	public int getTotalCount(Criteria cri);
}
