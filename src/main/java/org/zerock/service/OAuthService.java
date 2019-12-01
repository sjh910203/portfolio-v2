package org.zerock.service;

import java.util.HashMap;

import org.zerock.domain.MemberVO;

public interface OAuthService {

	public String getAccessTokenKakao(String code);
	
	public HashMap<String, Object> getUserInfo(String accessToken);
	
	public void kakaoLogout(String accessToken);
	
	public int googleRegistMemberInfo(MemberVO vo);
}
