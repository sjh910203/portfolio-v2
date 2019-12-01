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
</style>

<div class="login-form">
	<h2>비밀번호 교체</h2>
	<form action="/updatePW" method="post" id="updateForm">
		<div class="form-group">
			<input type="password" name="password1" id="password1" placeholder="비밀번호" autofocus>
		</div>
		<div>
			<strong id="pwCheck1">영문,숫자,특수문자 혼합하여 8자리~20자리 이내</strong>
		</div>
		<div class="form-group">
			<input type="password" name="password2" id="password2" placeholder="재입력">
		</div>
		<div>
			<strong id="pwCheck2">비밀번호를 다시 입력해주세요.</strong>
		</div>
		<div>
			<input type="hidden" name="memberNo" id="memberNo" value="${member.memberNo}" readonly>
			<input type="hidden" name="email" id="inputEmail" value="${member.email}" readonly>
			<input type="hidden" name="phoneNumber" id="phoneNumber" value="${member.phoneNumber}" readonly>
			<input type="hidden" name="pwChangeFlag" id="pwChangeFlag" value="${member.pwChangeFlag}" readonly>
		</div>
		<button type="submit" id="update-btn" class="btn btn-default">변경</button>
	</form>
</div>

<script type="text/javascript" src="/resources/js/ajaxError.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	
	console.log("update pw ready");

	var pf1 = 0;
	
	var pf2 = 0;
	
	var pw1 = null;

	var pw2 = null;
	
	$("#password1").blur(function() {
		
		console.log("pw check1");

		// 비밀번호 정규식
		var reg_pw = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$/;
		// 공백 정규식
		var reg_space = /\s/g;
		
		pw1 = $("#password1").val();
		
		var pwCheck1 = $("#pwCheck1");
		
		var member = {
				email: $("#inputEmail").val(),
				password: pw1,
				phoneNumber: $("#phoneNumber").val()
		}
		
		$.ajax({
			type:'post',
			url: "/member/checkPW",
			data: JSON.stringify(member),
			contentType: "application/json; charset=utf-8",
			dataType: 'json',
			success: function(check) {
				console.log("update PW Confirm");
				console.log(check);
				
				if(!check && reg_pw.test(pw1) == true) {
					pwCheck1.text("해당 비밀번호는 사용 가능합니다");
					pwCheck1.css("color", "black");
					pf1 = 1;
					console.log(pf1);
				} else if(check == true && reg_pw.test(pw1) == true) {
					pwCheck1.text("해당 비밀번호는 사용할 수 없습니다");
					pwCheck1.css("color", "red");
				} else if(reg_space.test(pw1) == true) {
					pwCheck1.text("비밀번호에 공백은 사용하지 못합니다");
					pwCheck1.css("color", "red");
					$("#password1").val("");
				} else {
					pwCheck1.text("비밀번호를 다시 확인해주세요");
					pwCheck1.css("color", "red");
				}
			}
		});
	});
	
	$("#password2").blur(function() {
		
		console.log("pw check2");
		
		pw2 = $("#password2").val()
		
		var pwCheck2 = $("#pwCheck2");

		if(pw1 != pw2) {
			pwCheck2.text("비밀번호를 바르게 입력해주세요");
			pwCheck2.css("color", "red");
		} else {
			pwCheck2.text("비밀번호가 일치합니다");
			pwCheck2.css("color", "black");
			pf2 = 1;
			console.log(pf2);
		}
	});
	
	function updatePW(member, callback, error) {
		$.ajax({
			type:'post',
			url: "/member/updatePWConfirm",
			data: JSON.stringify(member),
			contentType: "application/json; charset=utf-8",
			dataType: 'text',
			success: function(result, status, xhr) {
				console.log("update PW ajax");
				callback(result);
			}, error: function(result, status, xhr) {
				alert("부정한 접근 방법입니다.");
			}
		});
	}
	
	$("#update-btn").on("click", function(e) {
		
		e.preventDefault();
		
		console.log("update PW");
		
		if(pf1 == 1 && pf2 == 1) {
			var member = {
					memberNo: $("#memberNo").val(),
					email: $("#inputEmail").val(),
					phoneNumber: $("#phoneNumber").val(),
					password: $("#password2").val(),
					pwChangeFlag: $("#pwChangeFlag").val()
			}
		
			updatePW(member, function(result) {
				console.log("Update PW Complete");
				alert("비밀번호 변경이 완료되었습니다.");
				location.replace('/');
			});
		} else {
			alert("모든 항목을 채워주세요.");
		}
	});
});
</script>

<%@include file="../includes/footer.jsp" %>