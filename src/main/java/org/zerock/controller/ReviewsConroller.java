package org.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReviewsPageDTO;
import org.zerock.domain.ReviewsVO;
import org.zerock.service.ReviewsService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/reviews/")
@RestController
@Log4j
@AllArgsConstructor
public class ReviewsConroller {

	private ReviewsService service;
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReviewsVO vo) {
		
		log.info("ReviewsVO : " + vo);
		
		int insertCount = service.register(vo);
		
		log.info("Reviews INSERT COUNT : " + insertCount);
		
		return insertCount == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value ="/pages/{productsNo}/{page}",
			produces = { MediaType.APPLICATION_XML_VALUE, 
					MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReviewsPageDTO> getList(@PathVariable("page") int page,
			@PathVariable("productsNo") Long productsNo) {
		
		log.info("get reviews List...");
		
		Criteria cri = new Criteria(page, 5);
		
		log.info(productsNo);
		log.info(cri);
		
		return new ResponseEntity<>(service.getListPage(cri, productsNo), 
				HttpStatus.OK);
	}
	
	@GetMapping(value = "/{reviewsNo}",
			produces = { MediaType.APPLICATION_XML_VALUE, 
					MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReviewsVO> get(@PathVariable("reviewsNo") Long reviewsNo) {
		
		log.info("get : " + reviewsNo);
		
		return new ResponseEntity<>(service.get(reviewsNo), HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #vo.reviewer")
	@DeleteMapping(value = "/{reviewsNo}", produces = {MediaType.TEXT_PLAIN_VALUE} )
	public ResponseEntity<String> remove(@RequestBody ReviewsVO vo, 
			@PathVariable("reviewsNo") Long reviewsNo) {
		
		log.info("remove : " + reviewsNo);
		
		log.info("reviewer : " + vo.getReviewer());
		
		return service.remove(reviewsNo) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #vo.reviewer")
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{reviewsNo}",
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReviewsVO vo,
			@PathVariable("reviewsNo") Long reviewsNo) {
		
		vo.setReviewsNo(reviewsNo);
		
		log.info("reviewsNo : " + reviewsNo);
		
		log.info("modify : " + vo);
		
		return service.modify(vo) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
