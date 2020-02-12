package org.zerock.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@AllArgsConstructor
@Service
public class OAuthServiceImpl implements OAuthService {

	private final MemberMapper mapper;

	private final BCryptPasswordEncoder pwEncoder;
	
	@Override
	public String getAccessTokenKakao(String code) {
		
		 String access_Token = "";
	     String refresh_Token = "";
	     String reqURL = "https://kauth.kakao.com/oauth/token";
	     
	     try {
	          URL url = new URL(reqURL);
	          HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	            
	          //    POST 요청을 위해 기본값이 false인 setDoOutput을 true로
	          conn.setRequestMethod("POST");
	          conn.setDoOutput(true);
	            
	          //    POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
	          BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
	          StringBuilder sb = new StringBuilder();
	          sb.append("grant_type=authorization_code");
	          sb.append("&client_id=0b18208a4f09de8ada4c78b8e0941a84");
	          sb.append("&redirect_uri=http://localhost:8080/OAuth/kakaoLogin");
	          sb.append("&code=" + code);
	          bw.write(sb.toString());
	          bw.flush();
	            
	          //    결과 코드가 200이라면 성공
	          int responseCode = conn.getResponseCode();
	          log.info("responseCode : " + responseCode);
	 
	          //    요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
	          BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	          String line = "";
	          String result = "";
	            
	          while ((line = br.readLine()) != null) {
	              result += line;
	          }
	          log.info("response body : " + result);
	            
	          //    Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
	          JsonParser parser = new JsonParser();
	          JsonElement element = parser.parse(result);
	            
	          access_Token = element.getAsJsonObject().get("access_token").getAsString();
	          refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();
	            
	          log.info("access_token : " + access_Token);
	          log.info("refresh_token : " + refresh_Token);
	            
	          br.close();
	          bw.close();
	      } catch (IOException e) {
	          e.printStackTrace();
	      } 
	        
	      return access_Token;
	  }

	@Override
	public HashMap<String, Object> getUserInfo(String accessToken) {
		
		HashMap<String, Object> userInfo = new HashMap<>();
		
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		
		try {
			
			URL url = new URL(reqURL);
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			conn.setRequestMethod("POST");
			
			conn.setRequestProperty("Authorization", "Bearer " + accessToken);
			
			int responseCode = conn.getResponseCode();
			
			log.info("responseCode : " + responseCode);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			
			String line = "";
			
			String result = "";
			
			while((line = br.readLine()) != null) {
				result += line;
			}
			
			log.info("responseBody : " + result);
			
			JsonParser parser = new JsonParser();
			
			JsonElement element = parser.parse(result);
			
			JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
			
			JsonObject kakaoAccount = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
			
			String nickName = properties.getAsJsonObject().get("nickname").getAsString();
			
			String email = kakaoAccount.getAsJsonObject().get("email").getAsString();
			
			String id = element.getAsJsonObject().get("id").getAsString();
			
			userInfo.put("id", id);
			
			userInfo.put("nickname", nickName);
			
			userInfo.put("email", email);
			
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return userInfo;
	}

	@Override
	public void kakaoLogout(String accessToken) {
		String reqURL = "https://kapi.kakao.com/v1/user/logout";
		
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "Bearer " + accessToken);
			
			int responseCode = conn.getResponseCode();
			
			log.info("responseCode : " + responseCode);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			
			String result = "";
			String line = "";
			
			while((line = br.readLine()) != null) {
				result += line;
			}
			
			log.info(result);
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		
	}

	@Override
	@Transactional
	public int googleRegistMemberInfo(MemberVO vo) {
		
		log.info("googleRegistMemberInfo");
		
		int count = 0;
		
		vo.setPassword(pwEncoder.encode(vo.getPassword()));
		vo.setFailCounter(0);
		vo.setAuthKey("checked");
		
		count = mapper.join(vo);
		
		return count;
	}
}