package org.zerock.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.CartVO;
import org.zerock.domain.OrderLogVO;
import org.zerock.domain.ProductsAttachVO;
import org.zerock.mapper.PurchaseMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class PurchaseServiceImpl implements PurchaseService {

	@Setter(onMethod_ = @Autowired)
	private PurchaseMapper mapper;

	@Override
	public List<CartVO> goCart(Long mno) {
		
		log.warn("Cart Page for " + mno);

		return mapper.goCart(mno);
	}

	@Override
	public CartVO checkProductsInCart(CartVO vo) {

		log.warn("check Products In Cart " + vo.getMno());
		
		return mapper.checkProductsInCart(vo);
	}

	@Override
	public int addCart(CartVO vo) {
		
		log.warn("add cart " + vo);
		
		return mapper.addCart(vo);
	}

	@Override
	public int updateCartItem(CartVO vo) {

		log.warn("update Cart Item");
		
		return mapper.updateCartItem(vo);
	}

	@Override
	public int deleteCartItem(Long cartNo) {

		log.warn("delete Cart Item");
		
		return mapper.deleteCartItem(cartNo);
	}

	@Override
	@Transactional
	public int insertOrderLog(List<OrderLogVO> vo) {
		
		log.warn("insert order log");

		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String payDate = sdf.format(date);
		
		for(int i = 0; i < vo.size(); i++) {
			vo.get(i).setPayMethod("카드");
			vo.get(i).setPayStatus("결제 완료");
			vo.get(i).setExpressStatus("배송 준비 중");
			vo.get(i).setPayDate(payDate);
		}
		
		log.warn(vo);
		
		int count = 0;
		
		for(int i = 0; i < vo.size(); i++) {
			log.warn(vo.get(i));
			count += mapper.insertOrderLog(vo.get(i));
		}
		
		log.warn("count : " + count);
		
		return count;
	}

	@Override
	public List<OrderLogVO> orderLogInfo(Long mno) {
		
		log.warn("order log info " + mno);
		
		return mapper.orderLogInfo(mno);
	}
	
	@Override
	public int updateLog(OrderLogVO vo) {
		
		log.warn("update log " + vo.getMno());
		
		return mapper.updateLog(vo);
	}

	@Override
	public int refundLog(OrderLogVO vo) {
		
		log.warn("refund log " + vo.getMno());
		
		return mapper.refundLog(vo);
	}

}
