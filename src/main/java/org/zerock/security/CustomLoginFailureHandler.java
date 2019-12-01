package org.zerock.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.zerock.common.MessageUtils;
import org.zerock.domain.MemberVO;
import org.zerock.service.MemberService;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Getter
@Setter
@Log4j
public class CustomLoginFailureHandler implements AuthenticationFailureHandler {

	private String loginEmailName;

	private String loginPasswordName;
	
	private String errorMsg;
	
	private String defaultFailureUrl;
	
	@Autowired
	private MemberService service;
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, 
			HttpServletResponse response, AuthenticationException exception) 
					throws IOException, ServletException {
		String loginEmail = request.getParameter(loginEmailName);
		String loginPassword = request.getParameter(loginPasswordName);
		String errormsg = null;
		
		if(exception instanceof UsernameNotFoundException) {
			errormsg = MessageUtils.getMessage("error.UsernameNotFoundException");
		} else if(exception instanceof BadCredentialsException) {
			loginFailureCount(loginEmail); 

			errormsg = MessageUtils.getMessage("error.BadCredentials");
		} else if(exception instanceof InternalAuthenticationServiceException) {
			errormsg = MessageUtils.getMessage("error.BadCredentials");
		} else if(exception instanceof DisabledException) {
			errormsg = MessageUtils.getMessage("error.Disabled");
		} else if(exception instanceof CredentialsExpiredException) {
			errormsg = MessageUtils.getMessage("error.CredentialsExpired");
		} 
		
		request.setAttribute(loginEmailName, loginEmail);
		request.setAttribute(loginPasswordName, loginPassword);
		request.setAttribute(errorMsg, errormsg);
		
		request.getRequestDispatcher(defaultFailureUrl).forward(request, response);
	}
	
	protected void loginFailureCount(String email) {

		Integer cnt = 0;
		
		if(service.loginInfo(email) != null) {
			
			service.updateFailCount(email);
			
			cnt = service.checkFailCount(email);
		}

		log.warn("fail count : " + cnt);
		
		if(cnt == 3) {
			MemberVO vo = service.loginInfo(email);
			
			vo.setEnabled(false);
			
			service.updateEnabled(vo);
		}
	}
}
