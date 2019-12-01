package org.zerock.oauth;

import java.util.Iterator;

import org.apache.commons.lang3.StringUtils;
import org.zerock.domain.MemberVO;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

import lombok.extern.log4j.Log4j;

@Log4j
public class SNSLogin {
	
	private OAuth20Service oauthService;
	
	private SNS sns;
	
	public SNSLogin(SNS sns) {
		
		this.oauthService = new ServiceBuilder(sns.getClientId())
				.apiSecret(sns.getClientSecret())
				.callback(sns.getRedirectUrl())
				.scope("profile")
				.build(sns.getApi20Instance());
		
		this.sns = sns;
	}
	
	public String getNaverAuthURL() {
		
		return this.oauthService.getAuthorizationUrl();
	}
	
	public MemberVO getUserProfile(String code) throws Exception {
		
		OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
		
		OAuthRequest request = new OAuthRequest(Verb.GET, this.sns.getProfileUrl());
	
		oauthService.signRequest(accessToken, request);
		
		Response response = oauthService.execute(request);
		
		return parseJson(response.getBody());
	}
	
	private MemberVO parseJson(String body) throws Exception {
		
		log.warn(body);
		
		MemberVO vo = new MemberVO();
		
		ObjectMapper mapper = new ObjectMapper();
		
		JsonNode rootNode = mapper.readTree(body);
		
		log.warn("google? " + this.sns.isGoogle());
		log.warn("naver? " + this.sns.isNaver());
		
		if(this.sns.isGoogle()) {
			// 이름
			String name = rootNode.get("displayName").asText();
			
			vo.setName(name);
			
			Iterator<JsonNode> iterEmails = rootNode.path("emails").elements();
			
			// 이메일
			while(iterEmails.hasNext()) {
				JsonNode emailNode = iterEmails.next();
				
				String type = emailNode.get("type").asText();
				
				if(StringUtils.equals(type, "ACCOUNT")) {
					
					String email = emailNode.get("value").asText();
					
					vo.setEmail(email);
					
					break;
				}
			}
		
			// google id번호
			String id = rootNode.get("id").asText();
			
			if(sns.isGoogle()) {
				vo.setGoogleID(id);
			}
			
		} else if(this.sns.isNaver()) {
			//
		}
		
		log.warn(vo);
		
		return vo;
	}
}
