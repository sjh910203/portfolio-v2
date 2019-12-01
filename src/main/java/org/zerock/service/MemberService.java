package org.zerock.service;

import java.util.HashMap;

import org.zerock.domain.MemberVO;

public interface MemberService {
	
	public MemberVO memberNoInfo(String email);
	
	public MemberVO loginInfo(String email);
	
	public MemberVO memberInfo(String email);

	public int emailCheck(String email);
	
	public int join(MemberVO vo) throws Exception;
	
	public MemberVO selectAuthKey(MemberVO vo);
	
	public void updateEnabled(MemberVO vo);

	public int updateAuthKey(MemberVO vo);
	
	public void updateFailCount(String email);
	
	public void resetFailCount(String email);
	
	public Integer checkFailCount(String email);
	
	public MemberVO findPW(MemberVO vo) throws Exception;
	
	public int findFlag(MemberVO vo);
	
	public boolean checkPW(MemberVO vo);

	public int updateMemberPW(MemberVO vo);
	
	public int updateMemberInfo(MemberVO vo);
	
	public int withdrawalMember(MemberVO vo);
	
	/*
	public String getAccessToken(String code);
	
	public HashMap<String, Object> getUserInfo(String accessToken);
	*/
}
