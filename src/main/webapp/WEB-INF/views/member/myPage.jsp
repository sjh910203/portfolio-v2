<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>

<style>
#infoForm {
  width: 60%;
  margin: 60px auto;
  background: #efefef;
  padding: 60px 120px 80px 120px;
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
  padding: 10px 10px 10px 0px;
  font-family: sans-serif;
  font-size: .8em;
  letter-spacing: 1px;
  color: rgb(120,120,120);
  transition: ease .3s;
}

h4 {
  width: 100%;
  padding-top: 20px;
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

button:hover {
  background: #8BC34A;
  color: #ffffff;
}
</style>

<div class="container">
	<div class="col-sm-12">
			<div class="content-side">
				<div class="panel-group">
					<form action="/member/updateMemberInfo" method="get" id="infoForm">
							<p>회원 정보</p>
							<label>
								<strong class="label-txt">이메일</strong>
							    <h4>${member.email}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
							<label>
							    <strong class="label-txt">이름</strong>
							    <h4>${member.name}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
							<label>
							    <strong class="label-txt">우편번호</strong>
							    <h4>${member.postCode}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
							<label>
							    <strong class="label-txt">주소</strong>
							    <h4>${member.address}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
							<label>
							    <strong class="label-txt">상세주소</strong>
							    <h4>${member.detailAddress}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
							<label>
							    <strong class="label-txt">핸드폰 번호</strong>
							    <h4>${member.phoneNumber}</h4>
							    <div class="line-box">
							      <div class="line"></div>
							    </div>
							</label>
						<input type="hidden" id="memberNo" value="<c:out value='${member.memberNo}' />">
						<div>
							<button type="submit" id="infoUpdateBtn" class="btn btn-default">수정</button>
							<button type="button" id="withdrawalModalBtn" class="btn btn-danger pull-right" 
								data-toggle="modal" data-target="#myModal">회원 탈퇴</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">회원 탈퇴</h4>
      </div>
      <div class="modal-body">
        <p>정말로 탈퇴하시나요? 탈퇴하시면 그 동안의 구매 기록이 모두 사라집니다</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-danger" id="withdrawalBtn">탈퇴</button>
      </div>
    </div>

  </div>
</div>

<script type="text/javascript" src="/resources/js/ajaxError.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	
	console.log("myPage script");
	
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
	
	$("#withdrawalBtn").on("click", function(e) {
		
		e.preventDefault();
		
		console.log("click withdrawal Button");
		
		var memberNo = $("#memberNo").val();
		
		console.log(memberNo);
		
		$.ajax({
			type: 'delete',
			url: '/member/withdrawal',
			data: JSON.stringify(memberNo),
		  	contentType: "application/json; charset=utf-8",
		  	dataType: 'text',
		  	success: function(result, status, xhr) {
		  		console.log("withdrawal member");
		  		alert('회원 탈퇴가 완료되었습니다');
		  		location.replace("/member/customLogout")
		  		/*
		  		var infoForm = $("#infoForm");
		  		infoForm.attr("method", "post");
		  		infoForm.attr("action", "/member/customLogout");
		  		infoForm.submit();
		  		*/
		  	}, error: function() {
				  alert("비정상적인 접근입니다");
			} 
		});
	});
	
	
});


</script>

<%@include file="../includes/footer.jsp" %>