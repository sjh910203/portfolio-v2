package org.zerock.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.CartVO;
import org.zerock.domain.MemberVO;
import org.zerock.domain.OrderLogVO;
import org.zerock.service.MemberService;
import org.zerock.service.PurchaseService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/purchase/*")
@Log4j
@AllArgsConstructor
public class PurchaseController {

	private MemberService memberService;
	
	private PurchaseService service;
	
	@GetMapping("/Cart")
	public void goCart(Principal principal, Model model) {
		
		MemberVO memberInfo = new MemberVO();
		
		if(principal != null) {
			memberInfo = memberService.memberNoInfo(principal.getName());
			
			log.info("cart page " + principal.getName());
			
			long memberNo = memberInfo.getMemberNo();
			
			log.info(memberNo);
			
			List<CartVO> cartList = service.goCart(memberNo);
			
			log.info(cartList);
			
			model.addAttribute("cart", cartList);
			
			// 총 가격
			int totalPrice = 0;
			
			for(int i = 0; i < cartList.size(); i++) {
				totalPrice += cartList.get(i).getProducts().get(0).getPrice() * cartList.get(i).getAmount();
			} 
			
			log.info("TotalPrice : " + totalPrice);
			
			model.addAttribute("totalPrice", totalPrice);
			
			// 회원 정보
			MemberVO member = memberService.memberInfo(principal.getName());
			
			log.info(member);
			
			model.addAttribute("member", member);
		} else {
			model.addAttribute("incorrectAccess");
			// 작동 되는지 테스트
		}
		
		
	}
	
	@PostMapping(value = "/addCart", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> addCart(@RequestBody CartVO vo, Principal principal) {
		
		log.info("add cart " + vo);

		MemberVO memberInfo = memberService.memberNoInfo(principal.getName());
		
		vo.setMno(memberInfo.getMemberNo());
		
		log.info(vo.getMno() + " " + vo.getPno());
		
		CartVO cart = service.checkProductsInCart(vo);
		
		int count = 0;
		
		if(cart != null) {
			log.info(cart);
			// 원래 양에 받아온 양을 더해줘야함
			cart.setAmount(cart.getAmount() + vo.getAmount());
			count = service.updateCartItem(cart);
		} else {
			count = service.addCart(vo);	
		}
		
		return count == 1 
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PostMapping(value="/deleteCartItem", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> deleteCartItem(@RequestBody Long cartNo) {
		
		log.info(cartNo);
		
		int count = service.deleteCartItem(cartNo);
		
		return count == 1
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@PostMapping(value="/afterPurchase", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> afterPurchase(@RequestBody List<OrderLogVO> vo, Principal principal) {
		
		log.info("insert order info");
		
		log.info(vo);
		
		MemberVO mno = memberService.memberNoInfo(principal.getName());

		for(int i = 0; i < vo.size(); i++) {
			vo.get(i).setMno(mno.getMemberNo());
		}
		
		int count = service.insertOrderLog(vo);

		return count == vo.size()
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value="/OrderLog")
	public void orderLogInfo(Principal principal, Model model) {
		
		log.info("order log info");
		
		MemberVO mno = memberService.memberNoInfo(principal.getName());
		
		List<OrderLogVO> orderLog = service.orderLogInfo(mno.getMemberNo());

		log.info(orderLog);

		model.addAttribute("orderLog", orderLog);
		
	}
}
