package org.zerock.security;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
@Log4j
public class MemberTests {
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@Setter(onMethod_ = @Autowired)
	private DataSource ds;
	

	@Test
	public void testInsertMember() {
		
		// member
		String sql1 = 
				"insert into member(memberNo, email, password) values (?,?,?)";
		// member info
		String sql2 = "insert into member_info(name, postCode, address, detailAddress, phoneNumber, memberNo) values(?,?,?,?,?,?)";
		// member auth
		String sql3 = "insert into member_auth values(?,?)";
		
		for(int i = 0; i < 10; i++) {
			
			Connection con = null;
			PreparedStatement pstmt_m = null;
			PreparedStatement pstmt_i = null;
			PreparedStatement pstmt_a = null;
			
			try {
				
				con = ds.getConnection();
				pstmt_m = con.prepareStatement(sql1);
				
				pstmt_m.setLong(1, i);
				pstmt_m.setString(2, "testUser" + i +"@email.com");
				pstmt_m.setString(3, pwencoder.encode("pw" + i));
				pstmt_m.executeUpdate();
				
				pstmt_i = con.prepareStatement(sql2);
				pstmt_i.setString(1, "name" + i);
				pstmt_i.setString(2, "postCode" + i);
				pstmt_i.setString(3, "address" + i);
				pstmt_i.setString(4, "detailAddress" + i);
				pstmt_i.setString(5, "phoneNumber" + i);
				pstmt_i.setLong(6, i);
				pstmt_i.executeUpdate();
				
				pstmt_a = con.prepareStatement(sql3);
				pstmt_a.setLong(1, i);
				
				if(i < 2) {
					pstmt_a.setString(2, "ROLE_ADMIN");
				} else {
					pstmt_a.setString(2, "ROLE_MEMBER");
				}
				pstmt_a.executeUpdate();
				
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if(pstmt_m != null) {
					try {
						pstmt_m.close();
					} catch(Exception e) {
						
					}
				}
				if(con != null) {
					try {
						con.close();
					} catch(Exception e) {
						
					}
				}
			}
		}
	}
	/*
	@Test
	public void testInsertAuth() {
		
		String sql = 
				"insert into tbl_member_auth (userid, auth) values (?,?)";
		
		for(int i = 0; i < 100; i++) {
			
			Connection con = null;
			PreparedStatement pstmt = null;
			
			try {
				con = ds.getConnection();
				pstmt = con.prepareStatement(sql);
				
				if(i < 80) {
					pstmt.setString(1, "user" + i);
					pstmt.setString(2, "ROLE_USER");
				} else if(i < 90) {
					pstmt.setString(1, "manager" + i);
					pstmt.setString(2, "ROLE_MEMBER");
				} else {
					pstmt.setString(1, "admin" + i);
					pstmt.setString(2, "ROLE_ADMIN");
				}
				
				pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if(pstmt != null) {
					try {
						pstmt.close();
					} catch(Exception e) {
						
					}
				}
				if(con != null) {
					try {
						con.close();
					} catch(Exception e) {
						
					}
				}
			}
		}
	}
	*/
	
	
}
