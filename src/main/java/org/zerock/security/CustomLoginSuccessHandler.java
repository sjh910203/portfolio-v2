package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.zerock.service.MemberService;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Getter
@Setter
@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Setter(onMethod_ = @Autowired)
	private MemberService service;
	
	private String loginEmailName;
	
	private String defaultUrl;
	
	private RequestCache requestCache = new HttpSessionRequestCache();
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, 
			HttpServletResponse response, Authentication auth) 
					throws IOException, ServletException {
		
		log.info("Login Success");
		
		List<String> roleNames = new ArrayList<>();
		
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
		
		log.info(request.getParameter(loginEmailName) + " ROLE NAMES : " + roleNames);
		
		failCounterReset(request.getParameter(loginEmailName));
		
		resultRedirectStrategy(request, response, auth);
	}
	
	protected void resultRedirectStrategy(HttpServletRequest request, 
			HttpServletResponse response, Authentication auth) 
					throws IOException, ServletException {
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if(savedRequest != null) {
			String targetUrl = savedRequest.getRedirectUrl();
			
			redirectStrategy.sendRedirect(request, response, targetUrl);
		} else {
			redirectStrategy.sendRedirect(request, response, defaultUrl);
		}
	}
	
	protected void clearAuthenticationAttributes(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		
		if(session == null) {
			return;
		}
		
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}
	
	protected void failCounterReset(String email) {
	
		log.info("Fail Counter Reset");
		
		service.resetFailCount(email);
		
	}
}
