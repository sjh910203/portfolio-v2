<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<!-- saved from url=(0039)https://demo.themeum.com/html/eshopper/ -->
<html lang="en">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <title>PetShop</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
	<script src="https://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  		crossorigin="anonymous"></script>
    <link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.7.0/css/all.css' >
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link href="../../resources/css/prettyPhoto.css" rel="stylesheet">
    <link href="../../resources/css/price-range.css" rel="stylesheet">
    <link href="../../resources/css/main.css" rel="stylesheet">


</head>
<!--/head-->

<style>
	select {

    	-webkit-appearance: none;  /* 네이티브 외형 감추기 */
    	-moz-appearance: none;
    	appearance: none;
    	background: url(이미지 경로) no-repeat 95% 50%;  /* 화살표 모양의 이미지 */
	}

	/* IE 10, 11의 네이티브 화살표 숨기기 */
	select::-ms-expand {
    	display: none;
	}

	#animalType, #productsType, #brand {
		font-size: 10px;
		background-color: #ffffff;
        background-color: rgba( 255, 255, 255, 0.5 );
		width: 15%; /* 원하는 너비설정 */
		height: 50px;
    	padding: .8em .5em; /* 여백으로 높이 설정 */
    	font-family: inherit;  /* 폰트 상속 */
    	border: none;
		border-radius: 20px;
		text-align: center;
	}
	
	
</style>

<%@include file="../../../resources/css/image.css" %>

<body style="">
    <div class="header-middle">
        <!--header-middle-->
        <div class="container">
            <div class="row">
                <div class="col-md-4 clearfix">
                    <div class="logo pull-left">
                        <a href="/"><img src="../../resources/images/logo.png" alt=""></a>
                    </div>
                </div>
                <div class="col-md-8 clearfix">
                    <div class="shop-menu clearfix pull-right">
                        <ul class="nav navbar-nav">
                            <li>
                            	<sec:authorize access="isAuthenticated()">
                            		<a href="/purchase/Cart"><i class="fa fa-shopping-cart"></i> 장바구니</a>
                            	</sec:authorize>
                            </li>
                            <li>
                            	<sec:authorize access="isAnonymous()">
                            		<a href="/member/customLogin"><i class="fa fa-lock"></i> 로그인</a>
                            	</sec:authorize>
                            	<sec:authorize access="isAuthenticated()">
                            		<a href="#" id="logout-btn"><i class="fa fa-lock"></i> 로그아웃</a>
                            	</sec:authorize>
                            </li>
                            <li>
                            	<sec:authorize access="isAnonymous()">
                            		<a href="/member/join"><i class="fa fa-address-card-o"></i> 회원가입</a>
                            	</sec:authorize>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--/header-middle-->

    <div class="header-bottom" style="background-color:#363432; border-bottom: 4px solid #FDB45E;">
        <!--header-bottom-->
        <div class="container">
            <div class="row">
                <div class="col-sm-9">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                    <div class="mainmenu pull-left">
                        <ul class="nav navbar-nav collapse navbar-collapse dropdown">
                            <li><a href="/" class="active">Home</a></li>
                            <sec:authorize access="isAnonymous()">
                            		<li><a href="/products/list">상품</i></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('ROLE_MEMBER')">
                            		<li><a href="/products/list">상품</i></a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('ROLE_ADMIN')">
                            		<li class="dropdown"><a href="#">상품<i class="fa fa-angle-down"></i></a>
                            			<ul role="menu" class="sub-menu">
                            				<li><a href="/products/list">상품 목록</a></li>
                            				<li><a href="/products/add">상품 등록</a></li>
                            			</ul>
                            		</li>
                            </sec:authorize>
                            
                            <sec:authorize access="isAuthenticated()">
                            	<li class="dropdow"><a href="/purchase/OrderLog">구매 이력</a>
                            </sec:authorize>
							
							<sec:authorize access="isAuthenticated()">
                            	<li class="dropdow"><a href="/member/myPage">계정 정보</a>
                            </sec:authorize>
                        </ul>
                    </div>
                </div>

				   
				<div class="col-sm-3">
					<div class="search_box pull-right">
						<form id="searchForm" action="/products/list" method="get">
							<input type="hidden" name="type" value="search">
							<input type="text" name="keyword" placeholder="Search" style="border-radius:20px; background: transparent;">
							<button class="btn btn-default" type="submit" style="background-color: #363432; border:0; outline:0;">
								<i class="fa fa-search" style="font-size:25px;color: black;"></i>
							</button>
						</form>
					</div>
				</div>
				
				<!-- logout modal -->
				<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLable">로그아웃</h4>
							</div>
							<div class="modal-body">									
								<form role="form" id="logoutForm" action="/member/customLogout" method='post'>
									<button type="submit" class="btn btn-lg btn-warning btn-block">로그아웃</button>
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
								</form>
							</div>

						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				</div>
				<!-- /.modal -->

            </div>
        </div>
    </div>
    <!--/header-bottom-->
    </header>
    <!--/header-->
    
    <script type="text/javascript">
    	$(document).ready(function() {

    	      var csrfHeaderName = "${_csrf.headerName}";
    	      var csrfTokenValue = "${_csrf.token}";
    	      
    	      $(document).ajaxSend(function(e, xhr, options) {
    				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    			});
    		  
    		
    		$("#searchForm button").on("click", function(e) {
    			var searchForm = $('#searchForm');
    		
    			if(!searchForm.find("input[name='keyword']").val()) {
    				alert("검색할 제품의 이름을 입력해주세요");
    				return false;
    			}
    		})
    		
    		$("#logout-btn").on("click", function() {
    			$("#logoutModal").modal("show");
    		});
    		
    		$(".btn-success").on("click", function() {
    			e.preventDefault();
    			$("#logoutForm").submit();
    		});
    		
    	});
    </script>
    
    <c:if test="${param.logout != null}">
    	<script>
    		$(document).ready(function() {
    			alert("로그아웃하였습니다");
    		});
    	</script>
    </c:if>
    
    <c:if test="${param.incorrectAccess}">
    	<script>
    		location.replace('/');
    	</script>
    </c:if>