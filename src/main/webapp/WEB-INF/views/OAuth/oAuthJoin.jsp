<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

<style>
#join-form {
  width: 60%;
  margin: 60px auto;
  background: #efefef;
  padding: 60px 120px 80px 120px;
  text-align: center;
  -webkit-box-shadow: 2px 2px 3px rgba(0,0,0,0.1);
  box-shadow: 2px 2px 3px rgba(0,0,0,0.1);
}

label {
  display: block;
  position: relative;
  margin: 50px 0px;
}

.label-txt {
  position: absolute;
  top: -1.6em;
  padding: 10px;
  font-family: sans-serif;
  font-size: .8em;
  letter-spacing: 1px;
  color: rgb(120,120,120);
  transition: ease .3s;
}

.input {
  width: 100%;
  padding: 10px;
  background: transparent;
  border: none;
  outline: none;
}

.line-box {
  position: relative;
  width: 100%;
  height: 2px;
  background: #BCBCBC;
}

.line {
  position: absolute;
  width: 0%;
  height: 2px;
  top: 0px;
  left: 50%;
  transform: translateX(-50%);
  background: #8BC34A;
  transition: ease .6s;
}

.input:focus + .line-box .line {
  width: 100%;
}

.label-active {
  top: -3em;
}

.button {
  display: inline-block;
  padding: 12px 24px;
  background: rgb(220,220,220);
  font-weight: bold;
  color: rgb(120,120,120);
  border: none;
  outline: none;
  border-radius: 3px;
  cursor: pointer;
  transition: ease .3s;
}

.post-btn {
  display: inline-block;
  background: rgb(220,220,220);
  font-weight: bold;
  color: rgb(120,120,120);
  border: none;
  outline: none;
  border-radius: 3px;
  cursor: pointer;
  transition: ease .3s;
}

button:hover {
  background: #8BC34A;
  color: #ffffff;
}
</style>

<form id="join-form" action="/join" method="post">
  <label>
    <strong class="label-txt">이메일</strong>
    <input type="email" class="input" name="email">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <strong class="pull-left" id="checkResult">이메일을 입력해주세요</strong>
  </label>
  <label id="pw1">
    <strong class="label-txt">비밀번호</strong>
    <input type="password" class="input" name="password1">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <strong class="pull-left" id="checkResultpw1"> 영문,숫자,특수문자 혼합하여 8자리~20자리 이내</strong>
  </label>
  <label id="pw2">
    <strong class="label-txt">비밀번호 재입력</strong>
    <input type="password" class="input" name="password2">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <strong class="pull-left" id="checkResultpw2">비밀번호를 다시 입력해주세요</strong>
  </label>
  <label>
    <strong class="label-txt">이름</strong>
    <input type="text" class="input" name="name">
    <div class="line-box">
      <div class="line"></div>
    </div>
  </label>
    <button class="post-btn pull-left" type="button" id="postSearch">우편번호 검색</button>
    <br>
  <label>
    <strong class="label-txt">우편번호</strong>
    <input type="text" class="input" id="postCode" readonly>
    <div class="line-box">
      <div class="line"></div>
    </div>
  </label>
  <label>
    <strong class="label-txt">주소</strong>
    <input type="text" class="input" id="address" readonly>
    <div class="line-box">
      <div class="line"></div>
    </div>
  </label>
  <label>
    <strong class="label-txt">상세주소</strong>
    <input type="text" class="input" id="detailAddress">
    <div class="line-box">
      <div class="line"></div>
    </div>
  </label>
  <label>
    <strong class="label-txt">참고항목</strong>
    <input type="text" class="input" id="extraAddress" readonly>
    <div class="line-box">
      <div class="line"></div>
    </div>
  </label>
  <label>
    <strong class="label-txt">핸드폰 번호</strong>
    <input type="text" class="input" name="phoneNumber" placeholder="000-0000-0000">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <strong class="pull-left" id="checkResultpn">핸드폰 번호를 입력해주세요</strong>
  </label>
  <button type="submit" class="button" id="join-btn">가입하기</button>
  
</form>

<script type="text/javascript" src="/resources/js/ajaxError.js"></script>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<script type="text/javascript">
$(document).ready(function(){

	  $('.input').focus(function(){
	    $(this).parent().find(".label-txt").addClass('label-active');
	  });

	  $(".input").focusout(function(){
	    if ($(this).val() == '') {
	      $(this).parent().find(".label-txt").removeClass('label-active');
	    };
	  });

	  // 입력 여부 플래그
	  var idCk = 0;
	  var pwCk1 = 0;
	  var pwCk2 = 0;
	  var nameCk = 0;
	  var postCodeCk = 0;
	  var addressCk = 0;
	  var pnCk = 0;

	  $("input[name=phoneNumber]").blur(function() {
		  
		  var pn = $("input[name=phoneNumber]").val();
		  
		  var reg_pn = /^\d{3}-\d{3,4}-\d{4}$/;

		  if(reg_pn.test(pn) == false) {
			  $("#checkResultpn").text("핸드폰 번호를 바르게 입력해주세요");
			  $("#checkResultpn").css("color", "red");
		  } else {
			  $("#checkResultpn").text("");
			  pnCk = 1;
			  console.log("pnCk " + pnCk);
		  }
	  });

	  // 주소 검색 api
	  function execDaumPostcode() {
		  daum.postcode.load(function(){
	        new daum.Postcode({
	        	 oncomplete: function(data) {
	                 var addr = ''; // 주소 변수
	                 var extraAddr = ''; // 참고항목 변수

	                 //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                 if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                     addr = data.roadAddress;
	                 } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                     addr = data.jibunAddress;
	                 }

	                 // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                 if(data.userSelectedType === 'R'){
	                     // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                     // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                     if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                         extraAddr += data.bname;
	                     }
	                     // 건물명이 있고, 공동주택일 경우 추가한다.
	                     if(data.buildingName !== '' && data.apartment === 'Y'){
	                         extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                     }
	                     // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                     if(extraAddr !== ''){
	                         extraAddr = ' (' + extraAddr + ')';
	                     }
	                     // 조합된 참고항목을 해당 필드에 넣는다.
	                     document.getElementById("extraAddress").value = extraAddr;
	                 
	                 } else {
	                     document.getElementById("extraAddress").value = '';
	                 }

	                 // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                 document.getElementById('postCode').value = data.zonecode;
	                 postCodeCk = 1;
	                 console.log("postCodeCk " + postCodeCk);
	                 document.getElementById("address").value = addr;
	                 addressCk = 1;
	                 console.log("addressCk " + addressCk);
	                 // 커서를 상세주소 필드로 이동한다.
	                 document.getElementById("detailAddress").focus();
	             }
	         }).open();
		  });
	    }
	  
	  // 주소 검색 호출 버튼
	  $("#postSearch").on("click", function() {
		  execDaumPostcode();
	  });
	  
	  // 회원 가입 ajax
	  function join(member, callback, error) {
		  
		  console.log("join function");
		  
		  $.ajax({
			  	type: 'post',
			  	url: '/OAuth/registMemberInfo',
			  	data: JSON.stringify(member),
			  	contentType: "application/json; charset=utf-8",
			  	dataType: 'text',
			  	success: function(result, status, xhr) {
			  		console.log('join success' + result);
			  		callback(result);
			  	}
		  	});
	  }
	  
	  // 가입 버튼 
	  $("#join-btn").on("click", function(e) {
		  
		  e.preventDefault();
		  
		  if(idCk == 1 && pwCk1 == 1 && pwCk2 == 1 
				  && nameCk == 1 && postCodeCk == 1 
				  && addressCk == 1 && pnCk == 1) {
			  
			  console.log("idCK : " + idCk + " pwCK1 : " + pwCk1 + " pwCK2 : " + pwCk2 + 
					  " nameCK : " + nameCk + " postCodeCK : " +  postCodeCk + 
					  " addressCK : " +  addressCk + " pnCK : " +  pnCk);
			  
			  console.log("join member");
			  
			  var member = {
				  email: $("input[name=email]").val(),
				  password: $("input[name=password2]").val(),
				  name: $("input[name=name]").val(),
				  postCode: $("#postCode").val(),
				  address: $("#address").val(),
				  detailAddress: $("#detailAddress").val(),
				  phoneNumber: $("input[name=phoneNumber]").val()
			  }
			  
			  join(member, function(result) {
				  console.log("join member success" + result);
				  alert("추가 정보 입력이 완료되었습니다. 환영합니다 고객님.");
				  location.replace('/');
			  });
		  } else {
			  alert("필수 항목을 모두 작성해주세요");
		  }
	  });
	  
	  // oauth profile 호출
	  var profile = "${profile}";
	  
	  console.log(profile);
	  
	  if(profile != null) {
		  $("input[name=email]").val("${profile.email}");
		  $("input[name=email]").attr("readonly", true);
		  $("#checkResult").hide();
		  idCk = 1;
		  $("input[name=password1]").val("${profile.googleID}");
		  $("input[name=password1]").attr("readonly", true);
		  $("#pw1").hide();
		  pwCk1 = 1;
		  $("input[name=password2]").val("${profile.googleID}");
		  $("input[name=password2]").attr("readonly", true);
		  $("#pw2").hide();
		  pwCk2 = 1;
		  $("input[name=name]").val("${profile.name}");
		  $("input[name=name]").attr("readonly", true);
		  nameCk = 1;
		  
		  console.log("idCK : " + idCk + " pwCK1 : " + pwCk1 + " pwCK2 : " + pwCk2 + " nameCK : " + nameCk);
	  }
	  
	  
	  
	});
</script>

<%@include file="../includes/footer.jsp" %>