<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

<style>
.login-form {
	position: relative;
	width: 30%;
	height: 30%;
	margin: auto;
	margin-bottom: 50px;
}

.error-box {
	position: relative;
	margin: 5px 0px 5px 0px;
}

#login-btn {
	position: relative;
    margin: 10px 0px 10px 0px; 
}
    
#kakaoLoginBtn {
	position: relative;
    margin: 10px 0px 10px 0px;    
}

#googleLoginBtn {
	position: relative;
    margin: 10px 0px 10px 0px;     
}
</style>

<div class="login-form"><!--login form-->
	<h2>Login to your account</h2>
	<form action="/login" method="post" id="loginForm">
		<div class="form-group">
			<input type="email" name="inputEmail" placeholder="Email Address" autofocus>
		</div>
		<div class="form-group">
			<input type="password" name="inputPassword" placeholder="Password">
		</div>
		<div class="error-box">
			<c:if test="${not empty ERRORMSG}">
				<font color="red">
					<strong>
						${ERRORMSG}
					</strong>
				</font>
			</c:if>
		</div>
		<div>
			<span>
				<input type="checkbox" class="checkbox" name="remember-me"> 
				로그인 유지하기
			</span>
		</div>
		<div class="error-box">
			<a href="/member/join">회원 가입</a>
			/
			<a href="/member/findPW">비밀번호 찾기</a>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<button type="submit" id="login-btn" class="btn btn-default">Login</button>

		<!-- 
		<a href="https://kauth.kakao.com/oauth/authorize?client_id=0b18208a4f09de8ada4c78b8e0941a84&redirect_uri=http://localhost:8080/OAuth/kakaoLogin&response_type=code" id="kakaoLoginBtn">
			<img id="kakao-btn" src="../../../resources/images/kakao_account_login_btn_medium_narrow.png">
		</a>
		 -->
		<a href="${google_url}" id="googleLoginBtn">
			<img src="../../resources/images/btn_google_signin_dark_focus_web.png">
		</a>
		
	</form>
</div><!--/login form-->

<script type="text/javascript">
var loginForm = $("#loginForm");

$("#login-btn").on("click", function(e) {
	console.log("login click");
	e.preventDefault();
	
	var inputEmail = $("input[name=inputEmail]").val();
	
	var inputPassword = $("input[name=inputPassword]").val();

	if(inputEmail != null && inputPassword != null) {
		loginForm.submit();	
	} else {
		alert("아이디와 비밀번호를 입력해주세요");
	}
	
	
});

		
</script>

<%@include file="../includes/footer.jsp" %>