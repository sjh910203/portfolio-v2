package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.zerock.service.ProductsService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */

@Controller
@Log4j
@AllArgsConstructor
public class HomeController {
	
	private ProductsService service;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		log.info(formattedDate);
		
		log.info("Welcome home! The client locale is {}." + locale);
		
		model.addAttribute("homeList", service.getHomeList());
		
		return "home";
	}
}
