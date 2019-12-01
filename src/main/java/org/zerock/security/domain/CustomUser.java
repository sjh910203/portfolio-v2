package org.zerock.security.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.zerock.domain.MemberVO;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CustomUser extends User {

	private static final long serialVersionUID = 1L;
	
	private MemberVO member;

	public CustomUser(String email, String password, 
			boolean enabled, boolean accountNonExpired,
			boolean credentialsNonExpired, boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities) {
		super(email, password, enabled, 
				true, true, true, authorities);
	}
	
	public CustomUser(String email, String googleID, Collection<? extends GrantedAuthority> authorities) {
		super(email, googleID, authorities);
	}
	
	public CustomUser(MemberVO vo) {

		super(vo.getEmail(), vo.getPassword(), vo.isEnabled(), true, true, true,
				vo.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuthority())).collect(Collectors.toList()));

		this.member = vo;
	}
}