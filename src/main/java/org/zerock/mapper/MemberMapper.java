package org.zerock.mapper;

import org.zerock.domain.MemberVO;

public interface MemberMapper {
	
	public MemberVO memberNoInfo(String email);

	public MemberVO loginInfo(String email);
	
	public MemberVO memberInfo(String email);

	public int emailCheck(String email);
	
	public int join(MemberVO vo);
	
	public MemberVO selectAuthKey(MemberVO vo);
	
	public void updateEnabled(MemberVO vo);
	
	public int updateAuthKey(MemberVO vo);
	
	public void updateFailCount(String email);
	
	public void resetFailCount(String email);
	
	public Integer checkFailCount(String email);
	
	public MemberVO findPW(MemberVO vo);
	
	public int findFlag(MemberVO vo);
	
	public int updatePWChangeFlag(MemberVO vo);
	
	public int updateDate(MemberVO vo);
	
	public int updateMemberPW(MemberVO vo);
	
	public int updateMemberInfo(MemberVO vo);
	
	public boolean deleteMemberFlag(String email);
	
	public boolean deleteMemberAuthKey(Long memberNo);
	
	public boolean deleteMemberAuth(Long memberNo);
	
	public boolean deleteMemberInfo(Long memberNo);
	
	public boolean deleteMember(Long memberNo);
	
	
}
