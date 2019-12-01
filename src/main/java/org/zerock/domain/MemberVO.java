package org.zerock.domain;

import java.util.List;

import lombok.Data;

@Data
public class MemberVO {

	private Long memberNo;
	
	private String email;
	
	private String password;
	
	private boolean enabled;

	private String name;
	
	private String postCode;
	
	private String address;
	
	private String detailAddress;
	
	private String phoneNumber;
	
	private String regDate;
	
	private String updateDate;
	
	private String authKey;
	
	private int failCounter;
	
	private String pwChangeFlag;
	
	private List<MemberAuthVO> authList;
	
	private String googleID;
	
	private String naverID;
}
