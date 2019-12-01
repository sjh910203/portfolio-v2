package org.zerock.service;

import java.util.List;

import org.zerock.domain.CartVO;
import org.zerock.domain.OrderLogVO;
import org.zerock.domain.ProductsAttachVO;

public interface PurchaseService {
	
	public List<CartVO> goCart(Long mno);
	
	public CartVO checkProductsInCart(CartVO vo);

	public int addCart(CartVO vo);
	
	public int updateCartItem(CartVO vo);
	
	public int deleteCartItem(Long cartNo);
	
	public int insertOrderLog(List<OrderLogVO> vo);
	
	public List<OrderLogVO> orderLogInfo(Long mno);

	public int updateLog(OrderLogVO vo);
	
	public int refundLog(OrderLogVO vo);
}
