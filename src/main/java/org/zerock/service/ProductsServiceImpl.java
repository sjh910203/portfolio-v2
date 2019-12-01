package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ProductsAttachVO;
import org.zerock.domain.ProductsVO;
import org.zerock.mapper.ProductsAttachMapper;
import org.zerock.mapper.ProductsMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Log4j
@Service
public class ProductsServiceImpl implements ProductsService {

	@Setter(onMethod_ = @Autowired)
	private ProductsMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ProductsAttachMapper attachMapper;
	
	@Override
	public List<ProductsVO> getHomeList() {
		
		log.info("get list");
		
		return mapper.getHomeList();
	}
	
	@Override
	public List<ProductsVO> getListWithPaging(Criteria cri) {
		
		log.info("get list with paging" + cri);
		
		return mapper.getListWithPaging(cri);
	}

	@Override
	public ProductsVO getProducts(Long productsNo) {
		
		log.info("get products");
		
		return mapper.getProducts(productsNo);
	}

	/*
	@Override
	public void addProducts(ProductsVO products) {

		log.info("add products");
		
		mapper.addProducts(products);
	}
	*/
	
	@Transactional
	@Override
	public void addProducts(ProductsVO products) {
		log.info("add products");
		
		mapper.insertSelectKey(products);
		
		if(products.getAttachList() == null || products.getAttachList().size() <= 0) {
			return;
		}
		
		products.getAttachList().forEach(attach -> {
			attach.setProductsNo(products.getProductsNo());
			attachMapper.insert(attach);
			log.info("inserted");
		});
	}
	
	@Transactional
	@Override
	public boolean deleteProducts(Long productsNo) {

		log.info("delete products");
		
		attachMapper.deleteAll(productsNo);
		
		return mapper.deleteProducts(productsNo) == 1;
	}

	@Transactional
	@Override
	public boolean updateProducts(ProductsVO products) {

		log.info("update products " + products);
		
		attachMapper.deleteAll(products.getProductsNo());
		
		boolean updateResult = mapper.updateProducts(products) == 1;
		
		if(updateResult && products.getAttachList().size() > 0) {
			
			products.getAttachList().forEach(attach -> {
				
				attach.setProductsNo(products.getProductsNo());
				attachMapper.insert(attach);
			});
		}
		
		return updateResult;
	}

	@Override
	public int getTotal(Criteria cri) {
		
		log.info("get total count");
		
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<ProductsAttachVO> getAttachList(Long productsNo) {
		
		log.info("get Attach List by productsNo");
		
		return attachMapper.findByProductsNo(productsNo);
	}
}
