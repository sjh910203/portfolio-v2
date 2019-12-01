package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.domain.ProductsAttachVO;
import org.zerock.domain.ProductsVO;
import org.zerock.service.ProductsService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/products/*")
@AllArgsConstructor
public class ProductsController {
	
	private ProductsService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		
		log.info("/list" + cri);
		
		model.addAttribute("list", service.getListWithPaging(cri));
		
		int total = service.getTotal(cri);
		
		log.info("total : " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@GetMapping("/get")
	public void get(@RequestParam("productsNo") Long productsNo, 
			@ModelAttribute("cri") Criteria cri, Model model) {
		/* 해당 페이지 이동 */
		
		log.info("/get");
		
		model.addAttribute("products", service.getProducts(productsNo));
	}
	
	@GetMapping("/add")
	@PreAuthorize("isAuthenticated()")
	@Secured("ROLE_ADMIN")
	public void add() {
		/* 해당 페이지 이동 */
		
	}
	
	@PostMapping("/add")
	@PreAuthorize("isAuthenticated()")
	@Secured("ROLE_ADMIN")
	public String add(ProductsVO products, RedirectAttributes rttr) {
		
		log.info("==============================");
		log.info("add products : " + products);
		
		if(products.getAttachList() != null) {
			
			products.getAttachList().forEach(attach -> log.info(attach));
		
		}
		
		log.info("==============================");
		
		service.addProducts(products);
		
		rttr.addFlashAttribute("result", products.getProductsNo());
		
		return "redirect:/products/list";
	}
	
	@GetMapping("/update")
	@PreAuthorize("isAuthenticated()")
	@Secured("ROLE_ADMIN")
	public void update(@RequestParam("productsNo") Long productsNo, 
			@ModelAttribute("cri") Criteria cri, Model model) {
		
		
		log.info("/update");
		
		model.addAttribute("products", service.getProducts(productsNo));
	}
	
	@PostMapping("/update")
	@PreAuthorize("isAuthenticated()")
	@Secured("ROLE_ADMIN")
	public String update(ProductsVO products, 
			@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		
		log.info("updateProducts : " + products);
		
		if(service.updateProducts(products)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("productsNo", products.getProductsNo());
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		
		log.info(products.getProductsNo() + cri.getPageNum() + cri.getAmount());
		
		return "redirect:/products/get";// 수정하면 해당 번호 게시글로 빠짐
	}
	
	@PostMapping("/delete")
	@PreAuthorize("isAuthenticated()")
	@Secured("ROLE_ADMIN")
	public String delete(@RequestParam("productsNo") Long productsNo,
			@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		
		log.info("deleteProducts : " + productsNo);
		
		List<ProductsAttachVO> attachList = service.getAttachList(productsNo);
		
		if(service.deleteProducts(productsNo)) {
			
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
			}
		
		return "redirect:/products/list" + cri.getListLink();
	}
	
	private void deleteFiles(List<ProductsAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files...");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() 
					+ "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get("C:\\upload\\" + attach.getUploadPath() 
					+ "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbnail);
					
					Path bigThumnail = Paths.get("C:\\upload\\" + attach.getUploadPath() 
					+ "\\bs_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(bigThumnail);
				}
			} catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
	@GetMapping(value = "/getAttachList",
			produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<ProductsAttachVO>> getAttachList(Long productsNo) {
		
		log.info("getAttachList " + productsNo);
		
		return new ResponseEntity<>(service.getAttachList(productsNo), HttpStatus.OK);
	}
}
