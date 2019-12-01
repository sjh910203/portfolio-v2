package org.zerock.domain;

import java.util.List;

import lombok.Data;

@Data
public class CartVO {
	
	private Long cartNo;
	
	private Long mno;
	
	private Long pno;
	
	private int amount;
	
	private List<ProductsVO> products;
}
