package org.zerock.service;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.MailUtils;
import org.zerock.domain.MemberVO;
import org.zerock.domain.TempKey;
import org.zerock.mapper.MemberMapper;
import org.zerock.mapper.PurchaseMapper;

import lombok.AllArgsConstructor;

import lombok.extern.log4j.Log4j;

@Log4j
@AllArgsConstructor
@Service
public class MemberServiceImpl implements MemberService {

	private final MemberMapper mapper;
	
	private final PurchaseMapper pMapper;
	
	private final BCryptPasswordEncoder pwencoder;

	private final JavaMailSender mailSender;
	
	@Override
	public int emailCheck(String email) {
		
		log.info("Email Check");
		
		return mapper.emailCheck(email);
	}	
	
	@Override
	public MemberVO memberNoInfo(String email) {
		
		log.info("find memberNo for " + email);
		
		return mapper.memberNoInfo(email);
	}

	@Override
	public MemberVO loginInfo(String email) {
		
		log.info("read login info");
		
		return mapper.loginInfo(email);
	}

	@Override
	public MemberVO memberInfo(String email) {
		
		log.info("read member info");
		
		return mapper.memberInfo(email);
	}
	
	@Override
	@Transactional
	public int join(MemberVO vo) throws Exception{
		
		log.info("join" + vo);
		
		String authKey = new TempKey().getKey(50, false);
		
		vo.setPassword(pwencoder.encode( vo.getPassword() ) );
		vo.setAuthKey(authKey);
		vo.setFailCounter(0);
		
		MailUtils sendMail = new MailUtils(mailSender);
		
		sendMail.setSubject("PETSHOP 인증 메일");
		sendMail.setText(new StringBuffer()
				.append("<h1>" + vo.getEmail() + "(" + vo.getName() + ")님의 회원 인증을 위한 코드 발송입니다</h1>")
				.append("<p>아래 링크를 클릭하시면 인증이 마무리 됩니다</p>")
				.append("<a href='http://localhost:8080/member/joinConfirm?email=" 
				+ vo.getEmail() + "&authKey=" + vo.getAuthKey()  
				+ "' target='_blank'> 이메일 인증 확인 </a>").toString() );
		sendMail.setFrom("sjh910203@gmail.com", "관리자");
		sendMail.setTo(vo.getEmail());
		sendMail.send();
		
		return mapper.join(vo);
	}

	@Transactional
	@Override
	public MemberVO selectAuthKey(MemberVO vo) {
		
		log.info("select Auth Key");
		
		return mapper.selectAuthKey(vo);
	}
	
	@Transactional
	@Override
	public void updateEnabled(MemberVO vo) {
		
		log.info("update member enabled");
		
		mapper.updateEnabled(vo);
	}
	
	@Transactional
	@Override
	public int updateAuthKey(MemberVO vo) {
		
		log.info("update Auth Key");
		
		return mapper.updateAuthKey(vo);
	}

	@Override
	public void updateFailCount(String email) {
		
		log.info(email + " fail count update");
		
		mapper.updateFailCount(email);
	}
	
	@Override
	public void resetFailCount(String email) {
		
		log.info("reset Fail Counter for " + email);
		
		mapper.resetFailCount(email);
	}

	@Override
	public Integer checkFailCount(String email) {
		
		log.info(email + "checking fail count");
		
		return mapper.checkFailCount(email);
	}
	
	@Transactional
	@Override
	public int updateMemberPW(MemberVO vo) {
		
		log.info("update PW");

		String password = pwencoder.encode(vo.getPassword());
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String updateDate = sdf.format(date);
		
		vo.setPassword(password);
		vo.setEnabled(true);
		vo.setUpdateDate(updateDate);
		mapper.updateDate(vo);
		vo.setPwChangeFlag("changed");
		mapper.updatePWChangeFlag(vo);
		
		return mapper.updateMemberPW(vo);
	}

	@Transactional
	@Override
	public int updateMemberInfo(MemberVO vo) {
		
		log.info("update Member Info");
		
		String password = pwencoder.encode(vo.getPassword());
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String updateDate = sdf.format(date);
		
		vo.setPassword(password);
		vo.setUpdateDate(updateDate);
		mapper.updateDate(vo);
		
		return mapper.updateMemberInfo(vo); 
	}

	@Transactional
	@Override
	public MemberVO findPW(MemberVO vo) throws Exception {
		
		log.info("find PW");
		
		log.info(vo.getEmail() + " " + vo.getPhoneNumber());
		
		MemberVO info = mapper.findPW(vo);
		
		String authKey = new TempKey().getKey(50, false);
		
		MemberVO pwChangeFlag = new MemberVO();
		
		pwChangeFlag.setEmail(info.getEmail());
		pwChangeFlag.setPwChangeFlag(authKey);
		
		log.info(pwChangeFlag);
		
		mapper.updatePWChangeFlag(pwChangeFlag);
		
		MailUtils sendMail = new MailUtils(mailSender);
		
		sendMail.setSubject("PETSHOP 비밀번호 신청 메일");
		sendMail.setText(new StringBuffer()
				.append("<h1>" + info.getEmail() + "님의 비밀번호 검색/변경 서비스입니다</h1>")
				.append("<p>아래 링크를 클릭하시면  비밀번호 찾는 과정이 계속 됩니다</p>")
				.append("<a href='http://localhost:8080/member/updatePW?memberNo=" 
						+ info.getMemberNo() + "&email=" + info.getEmail() + "&phoneNumber=" 
						+ info.getPhoneNumber() + "&pwChangeFlag=" + pwChangeFlag.getPwChangeFlag() 
						+ "' target='_blank'> 변 경 </a>").toString() );
		sendMail.setFrom("sjh910203@gmail.com", "관리자");
		sendMail.setTo(info.getEmail());
		sendMail.send();
		
		return vo;
	}

	@Override
	public boolean checkPW(MemberVO vo) {
		
		// db에서 불러온 비밀번호
		MemberVO findPW = mapper.findPW(vo);

		// vo.getPassword 뷰 비밀번호 
		boolean check = pwencoder.matches(vo.getPassword(), findPW.getPassword());
		
		return check;
	}

	@Override
	public int findFlag(MemberVO vo) {
		
		log.info("find flag for " + vo.getEmail() + "& flag " + vo.getPwChangeFlag());
		
		return mapper.findFlag(vo);
	}
	
	@Override
	@Transactional
	public int withdrawalMember(MemberVO vo) {
		
		log.info(vo.getEmail() + "   " + vo.getMemberNo());
		
		int count = 0;
		
		if(mapper.deleteMemberFlag(vo.getEmail()) 
				&& mapper.deleteMemberAuthKey(vo.getMemberNo()) 
				&& mapper.deleteMemberAuth(vo.getMemberNo()) 
				&& mapper.deleteMemberInfo(vo.getMemberNo())
				&& mapper.deleteMember(vo.getMemberNo()) ) {
			count = 1;
		}
		
		int count2 = 0;
		
		if(pMapper.goCart(vo.getMemberNo()) != null 
				&& pMapper.orderLogInfo(vo.getMemberNo()) != null) {
			
			pMapper.deleteOrderLog(vo.getMemberNo());
			
			pMapper.deleteCartForMember(vo.getMemberNo());
			
			count2 = 1;
		}

		int totalCount = count + count2;
		
		log.info("withdrawal member " + totalCount);
		
		return totalCount;
	}
}
