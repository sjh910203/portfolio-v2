package org.zerock.controller;

import java.security.Principal;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.MemberVO;
import org.zerock.service.MemberService;


import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/member/*")
@AllArgsConstructor
public class MemberController {
	
	private MemberService service;
	
	private GoogleConnectionFactory gcf;
	
	private OAuth2Parameters oa2p;

	@GetMapping("/customLogin")
	public void login(String error, String logout, Model model) {
		
		log.info("error : " + error);
		log.info("logout : " + logout);
		
		if(error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "Logout");
		}
		
		OAuth2Operations oauthOperation = gcf.getOAuthOperations();
		
		String url = oauthOperation.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, oa2p);
		
		model.addAttribute("google_url", url);
		
		log.info("google login url " + url);
	}

	@PostMapping("/customLogin")
	public void postLogin(String error, String logout, Model model) {

		log.info("error : " + error);
		log.info("logout : " + logout);

		if(error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}

		if(logout != null) {
			model.addAttribute("logout", "Logout");
		}
	}

	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("access denide : " + auth);
		
		model.addAttribute("msg", "Access Denied");
	}

	@GetMapping("/customLogout")
	public void logoutGet() {
		log.info("get custom logout");
	}
	
	@PostMapping("/customLogout")
	public void logoutPost() {
		log.info("post custom logout");
	}
	
	@GetMapping("/join")
	public void join()	{
		log.info("join");
	}
	
	@PostMapping(value = "/emailCheck", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public int emailCheck(@RequestBody String email) {
		
		log.info("Check Email : " + email);
		
		int count = service.emailCheck(email);
		
		log.info("count : " + count);
		
		return count;
	}
	
	@PostMapping(value = "/join", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody 
	public ResponseEntity<String> join(@RequestBody MemberVO vo) throws Exception {
		
		log.info("MemberVO : " + vo);
		
		int insertCount = service.join(vo);
		
		log.info("inserCount : " + insertCount);
		// insertquery 개수가 5개라서 5으로 해야함
		return insertCount == 5
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@GetMapping(value="/joinConfirm")
	public String joinConfirm(MemberVO vo, Model model) {

		log.info("email : " + vo.getEmail());

		MemberVO member = service.loginInfo(vo.getEmail());
		
		Long memberNo = member.getMemberNo();
		
		vo.setMemberNo(memberNo);
		
		log.info("memberNo : " + memberNo + " / AuthKey : " + vo.getAuthKey());
		
		// auth key 검증
		MemberVO auth = service.selectAuthKey(vo);

		if(auth != null) {
			log.info("memberNo : " + vo.getMemberNo());
			log.info(vo.getEmail() + " : auth confirm");
			
			// authKey 사용 확인
			vo.setEnabled(true);
			vo.setAuthKey("checked");
			// count가 1이면 auth Status 갱신, 0이면 거부 메시지
			service.updateEnabled(vo);
			service.updateAuthKey(vo);

			model.addAttribute("msg", "인증이 완료되었습니다");
			model.addAttribute("url", "/");
		} else {
			log.info("Wrong AuthKey");

			model.addAttribute("msg", "정상적인 루트로 접근해주세요");
			model.addAttribute("url", "/");
		}
		
		return "/member/joinConfirm";
	}
	
	// 비밀번호 찾기 페이지 호출
	@GetMapping("/findPW")
	public void findPWPage() {
		log.info("find PW page");
	}
	
	// 비밀번호 찾기 기능
	@PostMapping(value = "/findPW", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> findPW(@RequestBody MemberVO vo) throws Exception {

		log.info("find PW for " + vo.getEmail());
		
		MemberVO info = service.findPW(vo);
		
		log.info(info);
		
		log.info("find PW for " + info.getEmail());
		
		return info != null
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PostMapping(value = "/checkPW", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public boolean checkPW(@RequestBody MemberVO vo) {
		
		log.info("checkPW for " + vo.getEmail());
		
		boolean check = service.checkPW(vo);
		
		log.info("check " + check);
		
		return check;
	}
	
	// 비밀번호 변경 페이지 호출
	@GetMapping("/updatePW")
	public void updatePWPage(Long memberNo, String email, String phoneNumber, 
			String pwChangeFlag, Model model) {
		
		log.info("update PW Page");
		
		MemberVO vo = new MemberVO();
		
		vo.setMemberNo(memberNo);
		vo.setEmail(email);
		vo.setPhoneNumber(phoneNumber);
		vo.setPwChangeFlag(pwChangeFlag);
		
		MemberVO findFlag = new MemberVO();
		
		findFlag.setEmail(vo.getEmail());
		findFlag.setPwChangeFlag(vo.getPwChangeFlag());
		
		int flag = service.findFlag(findFlag);

		if(flag != 1) {
			model.addAttribute("member", null);
		} else {
			model.addAttribute("member", vo);
		}
	}
	
	// 비밀번호 변경
	@PostMapping(value = "/updatePWConfirm", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> updatePWConfirm(@RequestBody MemberVO vo) {
		
		log.info("update PW");
		
		MemberVO findFlag = new MemberVO();
		
		findFlag.setEmail(vo.getEmail());
		findFlag.setPwChangeFlag(vo.getPwChangeFlag());
		
		int flag = service.findFlag(findFlag);
		
		log.info(flag);

		if(flag != 1) {
			return new ResponseEntity<> ("error", HttpStatus.INTERNAL_SERVER_ERROR);
		} else {
			int count = service.updateMemberPW(vo);
			
			log.info(count);
			//
			service.resetFailCount(vo.getEmail());
			
			return count == 1
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@GetMapping(value = "/myPage")
	public void myPage(Principal principal, Model model) {
		
		String email = principal.getName();
		
		log.info("member info page for " + email);
		
		MemberVO vo = service.memberInfo(email);
		
		model.addAttribute("member", vo);
	}
	
	@GetMapping(value = "/updateMemberInfo")
	public String memberInfoPage(Principal principal, Model model) {
		
		String email = principal.getName();
		
		log.info("update Member Info Page");

		MemberVO vo = service.memberInfo(email);
		
		model.addAttribute("member", vo);
		
		return "/member/updateMemberInfo";
	}
	
	@PostMapping(value = "/updateMemberInfo", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> updateMemberInfo(Principal principal, 
			@RequestBody MemberVO vo) {
		
		String email = principal.getName();
		
		log.info(email);
		
		vo.setEmail(email);
		
		int pwCount = service.updateMemberPW(vo);

		int infoCount = service.updateMemberInfo(vo);
		
		return pwCount == 1 && infoCount == 1 
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@DeleteMapping(value = "/withdrawal", 
			consumes = "application/json", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
			MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<String> withdrawal(Principal principal, 
			@RequestBody Long memberNo) {
		
		String email = principal.getName();
		
		log.info("withdrawal member " + email + " " + memberNo);

		int count = 0;
		
		MemberVO vo = new MemberVO();
		vo.setEmail(email);
		vo.setMemberNo(memberNo);
		
		count = service.withdrawalMember(vo);
		
		log.info(count);
		
		return count >= 1
				? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
