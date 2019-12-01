package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.CartVO;
import org.zerock.domain.OrderLogVO;

public interface PurchaseMapper {
	
	public List<CartVO> goCart(Long mNo);
	
	public CartVO checkProductsInCart(CartVO vo);

	public int addCart(CartVO vo);
	
	public int updateCartItem(CartVO vo);
	
	public int deleteCartItem(Long cartNo);
	
	public boolean deleteCartForMember(Long mNo);
	
	public boolean deleteOrderLog(Long mno);
	
	public int insertOrderLog(OrderLogVO vo);
	
	public List<OrderLogVO> orderLogInfo(Long mno);
	
	public int updateLog(OrderLogVO vo);
	
	public int refundLog(OrderLogVO vo);
}
