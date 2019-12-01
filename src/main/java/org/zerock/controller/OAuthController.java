package org.zerock.controller;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.MemberVO;
import org.zerock.oauth.SNS;
import org.zerock.oauth.SNSLogin;
import org.zerock.service.MemberService;
import org.zerock.service.OAuthService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/OAuth/*")
@AllArgsConstructor
public class OAuthController {

	private OAuthService service;

	private MemberService memberService;
	
	@Autowired
	private SNS googleSns;
	
	@RequestMapping(value = "/kakaoLogin")
	public String kakaoLogin(@RequestParam("code") String code, HttpSession session, Model model) {
		
		log.info("kakao code : " + code);
		
		String accessToken = service.getAccessTokenKakao(code);
		
		log.info("controller access token : " + accessToken);
		
		HashMap<String, Object> userInfo = service.getUserInfo(accessToken);
		
		log.info("login for " + userInfo);
		
		if(userInfo.get("email") != null) {
			session.setAttribute("userId", userInfo.get("email"));
			session.setAttribute("access_Token", accessToken);
		}
		
		MemberVO vo = memberService.loginInfo(userInfo.get("email").toString());

		// 강제 로그인 기능 추가
		
		if(vo == null) {
			
			log.info("vo is not exist");
			
			return "home";
		} else {
			log.info("vo is exist : " + vo);
			
			Authentication authentication = new UsernamePasswordAuthenticationToken(userInfo.get("email"), userInfo.get("id"), AuthorityUtils.createAuthorityList(vo.getAuthList().get(0).getAuthority())); 
			
			SecurityContext securityContext = SecurityContextHolder.getContext();
			
			securityContext.setAuthentication(authentication);
			
			session.setAttribute("SPRING SECURITY CONTEXT", securityContext);
			
			return "home";	
		}
	}

	@RequestMapping(value = "/kakaoLogout")
	public String logout(HttpSession session) {
		
		service.kakaoLogout((String)session.getAttribute("access_Token"));
		
		session.removeAttribute("access_Token");
		session.removeAttribute("userId");
		
		return "home";
	}
	
	@RequestMapping(value = "/googleLogin", method = {RequestMethod.GET, RequestMethod.POST})
	public String snsLoginCallback(Model model, @RequestParam String code, HttpSession session) throws Exception {
		
		SNSLogin snsLogin = new SNSLogin(googleSns);
		MemberVO profile = snsLogin.getUserProfile(code);
		
		log.info("profile : " + profile);
		// email, name, id
		MemberVO loginInfo = memberService.loginInfo(profile.getEmail());
		
		// 이미 가입된 회원
		if(loginInfo != null) {
			// 로그인 처리
			// principal, credentials, authorities
			Authentication authentication = new UsernamePasswordAuthenticationToken(profile.getEmail(), profile.getGoogleID(), AuthorityUtils.createAuthorityList(loginInfo.getAuthList().get(0).getAuthority())); 
			
			SecurityContext securityContext = SecurityContextHolder.getContext();
			
			securityContext.setAuthentication(authentication);
			
			session.setAttribute("SPRING SECURITY CONTEXT", securityContext);
			
			return "home";
		} else {
			
			model.addAttribute("profile", profile);
			// email, googleID, name
			
			return "/OAuth/oAuthJoin";
		}
	}
	
	@GetMapping(value = "/oAuthJoin")
	public void registMemberInfoForm() {
		
		log.info("regist member info form");
		
	}
	
	@RequestMapping(value = "/registMemberInfo", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	private ResponseEntity<String> registMemberInfo(@RequestBody MemberVO vo) throws Exception {
		
		log.info("regist member info for google oauth");
		
		int count = 0;
		
		count = service.googleRegistMemberInfo(vo);
		
		return count == 5
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
}