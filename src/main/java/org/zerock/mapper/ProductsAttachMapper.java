package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.ProductsAttachVO;

public interface ProductsAttachMapper {

	public void insert(ProductsAttachVO vo);
	
	public void delete(String uuid);
	
	public List<ProductsAttachVO> findByProductsNo(Long productsNo);

	public void deleteAll(Long productsNo);
	
	public List<ProductsAttachVO> getOldFiles();
}
