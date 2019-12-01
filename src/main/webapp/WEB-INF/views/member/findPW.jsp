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
	<h2>비밀번호 찾기</h2>
	<form action="/findPW" method="post" id="findForm">
		<div class="form-group">
			<input type="email" name="inputEmail" id="inputEmail" placeholder="Email Address" autofocus>
		</div>
		<div class="form-group">
			<input type="text" name="phoneNumber" id="phoneNumber" placeholder="Phone Number">
		</div>
		<button type="submit" id="find-btn" class="btn btn-default">Find</button>
	</form>
</div>

<script type="text/javascript">
$(document).ready(function() {

	console.log("find script ready");

	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
	
	$.ajaxSetup({
    	error: function(jqXHR, exception) {
        	if (jqXHR.status === 0) {
            	alert('Not connect.\n Verify Network.');
        	}
        	else if (jqXHR.status == 400) {
            	alert('Server understood the request, but request content was invalid. [400]');
        	}
        	else if (jqXHR.status == 401) {
            	alert('Unauthorized access. [401]');
        	}
        	else if (jqXHR.status == 403) {
            	alert('Forbidden resource can not be accessed. [403]');
        	}
        	else if (jqXHR.status == 404) {
            	alert('Requested page not found. [404]');
        	}
        	else if (jqXHR.status == 500) {
            	alert('Internal server error. [500]');
        	}
        	else if (jqXHR.status == 503) {
            	alert('Service unavailable. [503]');
        	}
        	else if (exception === 'parsererror') {
            	alert('Requested JSON parse failed. [Failed]');
        	}
        	else if (exception === 'timeout') {
            	alert('Time out error. [Timeout]');
        	}
        	else if (exception === 'abort') {
            	alert('Ajax request aborted. [Aborted]');
        	}
        	else {
            	alert('Uncaught Error.n' + jqXHR.responseText);
        	}
    	}
	});
	
	var findForm = $("#findform");
	
	
	function findPW(member, callback, error) {
		$.ajax({
			type:'post',
			url: "/member/findPW",
			data: JSON.stringify(member),
			contentType: "application/json; charset=utf-8",
			dataType: 'text',
			success: function(result, status, xhr) {
				console.log("find PW ajax");
				callback(result);
			}, error: function(error) {
				alert("입력칸을 모두 채워주세요");
			}
		});
	}

	$("#find-btn").on("click", function(e) {
		console.log("find PW click");
		console.log($("#inputEmail").val() + " " + $("#phoneNumber").val())
		e.preventDefault();
		
		var email = $("#inputEmail").val();
		var phoneNumber = $("#phoneNumber").val();
		
		var member = {
				email: email,
				phoneNumber: phoneNumber
		}
		
		findPW(member, function(result) {
			console.log("findPW");
			alert("해당 주소로 비밀번호를 보냈습니다.");
			location.replace('/');
		});

	});
});
</script>

<%@include file="../includes/footer.jsp" %>