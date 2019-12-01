package org.zerock.oauth;

import org.apache.commons.lang3.StringUtils;

import com.github.scribejava.apis.GoogleApi20;
import com.github.scribejava.core.builder.api.DefaultApi20;

import lombok.Data;

@Data
public class SNS implements SnsUrls {
	
	private String service;

	private String clientId;
	
	private String clientSecret;
	
	private String redirectUrl;
	
	private DefaultApi20 api20Instance;
	
	private String profileUrl;
	
	private boolean isNaver;
	
	private boolean isGoogle;
	
	public SNS(String service, String clientId, String clientSecret, String redirectUrl) {
		this.service = service;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.redirectUrl = redirectUrl;
		
		this.isNaver = StringUtils.equalsIgnoreCase("naver", this.service);
		this.isGoogle = StringUtils.equalsIgnoreCase("google", this.service);
		
		if(isNaver) {
			this.api20Instance = NaverAPI20.getInstance();
			this.profileUrl = NAVER_PROFILE_URL;
		} else if(isGoogle) {
			this.api20Instance = GoogleApi20.instance();
			this.profileUrl = GOOGLE_PROFILE_URL;
		}
	}
}
