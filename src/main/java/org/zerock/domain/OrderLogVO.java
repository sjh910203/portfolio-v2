package org.zerock.domain;

import java.util.List;

import lombok.Data;

@Data
public class OrderLogVO {

	private long logNo;
	
	private long pno;
	
	private long mno;
	
	private int payAmount;
	
	private int payPrice;
	
	private String payMethod;
	
	private String payStatus;
	
	private String payDate;
	
	private String renewalDate;
	
	private String expressStatus;
	
	private List<ProductsVO> products;
}
