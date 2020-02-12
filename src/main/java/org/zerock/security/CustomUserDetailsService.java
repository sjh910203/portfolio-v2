package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;
import org.zerock.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;

	@Override
	public UserDetails loadUserByUsername(String email) 
			throws UsernameNotFoundException {
		
		log.info("Load User By Email : " + email);
		
		MemberVO vo = mapper.loginInfo(email);
		
		log.info(vo);
		
		if(vo == null){
			throw new UsernameNotFoundException(email);
		}
		
		log.info("queried by member mapper : " + vo);
		
		CustomUser customUser = new CustomUser(vo);
		
		return customUser;
	}
	
}
