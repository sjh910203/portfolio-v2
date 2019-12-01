package org.zerock.domain;

import lombok.Data;

@Data
public class ProductsAttachVO {

	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean imageType;
	
	private Long productsNo;
}
