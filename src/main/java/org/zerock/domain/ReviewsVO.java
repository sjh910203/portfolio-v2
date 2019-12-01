package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReviewsVO {
	
	private Long reviewsNo;
	
	private Long productsNo;
	
	private String reviews;
	
	private String reviewer;
	
	private Date reviewDate;
	
	private Date reviewUpdate;
}
