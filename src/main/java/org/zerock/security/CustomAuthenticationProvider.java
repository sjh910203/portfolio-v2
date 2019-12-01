package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.zerock.security.domain.CustomUser;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private PasswordEncoder pwe;
	
	@Autowired
	private UserDetailsService service;
	
	@Override
	public Authentication authenticate(Authentication authentication) 
			throws AuthenticationException {
		
		UsernamePasswordAuthenticationToken authToken = 
				(UsernamePasswordAuthenticationToken) authentication;
		
		CustomUser userInfo = (CustomUser) service.loadUserByUsername(authToken.getName());

		log.warn("authenticate");
		log.warn("email : " + authToken.getPrincipal() + " password : " + authToken.getCredentials());
		
		if(!pwe.matches((CharSequence) authToken.getCredentials(), userInfo.getPassword())) {

			log.warn("password : " + authToken.getCredentials() + " user password : " + userInfo.getPassword() );
			
			log.warn("not matched password");
			
			throw new BadCredentialsException((String) authToken.getPrincipal());
		} else {
			log.warn("password ok");
		}
		
		if(!userInfo.isEnabled() || !userInfo.isCredentialsNonExpired()) {

			log.warn("account Verification " + userInfo.isEnabled());
			
			throw new DisabledException((String) authToken.getPrincipal());
		} else {
			log.warn("account Verification success");
		}
		
		log.warn("authenticate ok");
		
		return new UsernamePasswordAuthenticationToken(authToken.getPrincipal(), authToken.getCredentials(), userInfo.getAuthorities());
	}

	@Override
	public boolean supports(Class<?> authentication) {
		
		return true;
	}

}
