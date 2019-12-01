package org.zerock.domain;

import java.util.List;

import lombok.Data;

@Data
public class ProductsVO {
	
	private long productsNo;
	
	private String productsName;
	
	private int price;
	
	private String explain;
	
	private String productsType;
	
	private String animalType;
	
	private String brand;
	
	private List<ProductsAttachVO> attachList;
}
