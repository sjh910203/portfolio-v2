package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ProductsAttachVO;
import org.zerock.domain.ProductsVO;

public interface ProductsService {
	
	public List<ProductsVO> getHomeList();
	
	public List<ProductsVO> getListWithPaging(Criteria cri);
	
	public ProductsVO getProducts(Long productsNo);
	
	//public void addProducts(ProductsVO products);
	
	public void addProducts(ProductsVO products);
	
	public boolean deleteProducts(Long productsNo);
	
	public boolean updateProducts(ProductsVO products);
	
	public int getTotal(Criteria cri);
	
	public List<ProductsAttachVO> getAttachList(Long productsNo);
}
