<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="includes/header.jsp" %>

    <section id="slider">
        <!--slider-->
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <div id="slider-carousel" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#slider-carousel" data-slide-to="0" class=""></li>
                            <li data-target="#slider-carousel" data-slide-to="1" class=""></li>
                            <li data-target="#slider-carousel" data-slide-to="2"></li>
                        </ol>

                        <div class="carousel-inner">
                            <div class="item">
                                <div class="col-sm-6">
                                    <h1><span>Pet</span>Shop</h1>
                                    <h2>반려동물 관련 상품 전문 샵</h2>
                                    <p>반려동물에게 좋은 물건을 싼 가격에!</p>
                                    <button type="button" class="btn btn-default get">구입하기</button>
                                </div>
                                <div class="col-sm-6">
                                    <img src="../../resources/images/food1.jpg" class="girl img-responsive" alt="">
                                </div>
                            </div>
                            <div class="item active left">
                                <div class="col-sm-6">
                                    <h1><span>Pet</span>Shop</h1>
                                    <h2>반려동물 관련 상품 전문 샵</h2>
                                    <p>반려동물에게 좋은 물건을 싼 가격에!</p>
                                    <button type="button" class="btn btn-default get">구입하기</button>
                                </div>
                                <div class="col-sm-6">
                                    <img src="../../resources/images/food2.jpg" class="girl img-responsive" alt="">
                                </div>
                            </div>

                            <div class="item next left">
                                <div class="col-sm-6">
                                   	<h1><span>Pet</span>Shop</h1>
                                    <h2>반려동물 관련 상품 전문 샵</h2>
                                    <p>반려동물에게 좋은 물건을 싼 가격에!</p>
                                    <button type="button" class="btn btn-default get">구입하기</button>
                                </div>
                                <div class="col-sm-6">
                                    <img src="../../resources/images/food3.jpg" class="girl img-responsive" alt="">
                                </div>
                            </div>

                        </div>

                        <a href="#" class="left control-carousel hidden-xs" data-slide="prev">
                            <i class="fa fa-angle-left"></i>
                        </a>
                        <a href="#" class="right control-carousel hidden-xs" data-slide="next">
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </section>
    <!--/slider-->

    <section>
        <div class="container">
            <div class="row">
                
                <%@include file="includes/leftSideBar.jsp" %>

                <div class="col-sm-9 padding-right">
                    <div class="features_items">
                        <!--features_items-->
                        <h2 class="title text-center">Features Items</h2>

                        <c:forEach items="${homeList}" var="products" end="8" varStatus="status">
							<div class="col-sm-4">
								<div class="product-image-wrapper">
									<div class="single-products">
										<div class="productinfo text-center">
											<img src="#" id="listAttach${status.index}" style="width:266px;height:381px;">
											<h2><c:out value="${products.price}" /></h2>
											<p><c:out value="${products.productsName}" /></p>
											<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Add to cart</a>
										</div>
										<div class="product-overlay">
											<div class="overlay-content">
												<h2><c:out value="${products.price}" /></h2>
												<p><c:out value="${products.productsName}" /></p>
												<a href="#" class="btn btn-default add-to-cart">
													<i class="fa fa-shopping-cart">
														<input type="hidden" id="productsNo" value="<c:out value='${products.productsNo}' />">
													</i>Add to cart
												</a>
											</div>
										</div>
									</div>
									<div class="choose">
										<ul class="nav nav-pills nav-justified">
											<li>
												<a href="#" id="addCart">
													<i class="fa fa-plus-square">
														<input type="hidden" id="productsNo" value="<c:out value='${products.productsNo}' />">
													</i>
													장바구니에 넣기
												</a>
											</li>
											<li><a class='move' href="/petshop/get?productsNo=<c:out value='${products.productsNo }' />" ><i class="fa fa-plus-square"></i>상세정보</a></li> <!-- 여기에 get 기능을 넣기 -->
										</ul>
									</div>
								</div>
							</div>
							<div>
								<input type="hidden" id="imageType${status.index}" value="${products.attachList.get(0).imageType}" />
								<input type="hidden" id="uuid${status.index}" value="${products.attachList.get(0).uuid}" />
								<input type="hidden" id="uploadPath${status.index}" value="${products.attachList.get(0).uploadPath}" />
								<input type="hidden" id="fileName${status.index}" value="${products.attachList.get(0).fileName}" />
							</div>
						</c:forEach>
						<input type="hidden" id="size" value="${fn:length(homeList)}" />
                    </div>
                    <!--features_items-->

                </div>
            </div>
        </div>
    </section>

<script type="text/javascript">
$(document).ready(function() {
	
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
	
	// 이미지 출력
	for(var i = 0; i < $("#size").val(); i++) {
		var imgSrci = null;
		var uuid = $("#uuid" + i).val();
		var uploadPath = $("#uploadPath" + i).val();
		var fileName = $("#fileName" + i).val();
		
		if($("#imageType" + i).val()) {
			imgSrci = encodeURIComponent(uploadPath + "/bs_" + uuid + "_" + fileName);
			imgSrci = "/display?fileName=" + imgSrci;
		} else {
			imgSrci = '../../resources/images/attach.png';
		}
	
		console.log(imgSrci);
		
		$("#listAttach" + i).attr("src", imgSrci);
	}

	$(".overlay-content").on("click", "a", function(e) {
		e.preventDefault();

		var pno = $(this).find("#productsNo").val();
		
		console.log(pno);
		
		var cart = {
				pno : pno,
				amount : 1
		}
			
		$.ajax({
			type: 'post',
			url: '/purchase/addCart',
			data: JSON.stringify(cart),
			contentType: "application/json; charset=utf-8",
			dataType: 'text',
			success: function(result, status, xhr) {
			  	console.log('add cart ' + result);

			  	alert("상품이 장바구니에 추가되었습니다");
			  }
		});
	});
	
	$(".choose").on("click", "#addCart", function(e) {
		e.preventDefault();

		var pno = $(this).find("#productsNo").val();
		
		console.log(pno);
		
		var cart = {
				pno : pno,
				amount : 1
		}
			
		$.ajax({
			type: 'post',
			url: '/purchase/addCart',
			data: JSON.stringify(cart),
			contentType: "application/json; charset=utf-8",
			dataType: 'text',
			success: function(result, status, xhr) {
			  	console.log('add cart ' + result);

			  	alert("상품이 장바구니에 추가되었습니다");
			  }
		});
	});
	
});

</script>

<%@include file="includes/footer.jsp" %>