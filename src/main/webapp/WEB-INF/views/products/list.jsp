<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="../includes/header.jsp" %>

	<section>
		<div class="container">
			<div class="row">
				
				<%@include file="../includes/leftSideBar.jsp" %>
				
				<div class="col-sm-9 padding-right">
					<div class="features_items"><!--features_items-->
						<h2 class="title text-center">Features Items</h2>

						<c:forEach items="${list}" var="products" end="8" varStatus="status">
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
												<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart">
													<input type="hidden" id="productsNo" value="<c:out value='${products.productsNo}' />">
												</i>Add to cart</a>
											</div>
										</div>
									</div>
									<div class="choose">
										<ul class="nav nav-pills nav-justified">
											<li><a href="#" id="addCart"><i class="fa fa-plus-square"><input type="hidden" id="productsNo" value="<c:out value='${products.productsNo}' />"></i>장바구니에 넣기</a></li>
											<li><a class='move' href="<c:out value='${products.productsNo }' />" ><i class="fa fa-plus-square"></i>상세정보</a></li>
										</ul>
									</div>
									
									<form id='actionForm' action="/products/list" method='get'>
										<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
										<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
									</form>
									
									<div>
										<input type="hidden" id="imageType${status.index}" value="${products.attachList.get(0).imageType}" />
										<input type="hidden" id="uuid${status.index}" value="${products.attachList.get(0).uuid}" />
										<input type="hidden" id="uploadPath${status.index}" value="${products.attachList.get(0).uploadPath}" />
										<input type="hidden" id="fileName${status.index}" value="${products.attachList.get(0).fileName}" />
									</div>
								</div>
							</div>
						</c:forEach>
						<input type="hidden" id="size" value="${fn:length(list)}" />
						
						<div class="pull-right"> 
							<ul class="pagination">		
								<c:if test="${pageMaker.prev}">
									<li class="paginate_button previous">
										<a href="${pageMaker.startPage - 1}">앞으로</a>
									</li>
								</c:if>
							
								<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
									<li class='paginate_button ${pageMaker.cri.pageNum == num ? "active" : "" } '>
										<a href="${num}">
											${num}
										</a>
									</li>
								</c:forEach>
							
								<c:if test="${pageMaker.next}">
									<li class="paginate_button next">
										<a href="${pageMaker.endPage + 1}">뒤로</a>
									</li>
								</c:if>
							</ul>
						
						</div>
					</div><!--features_items-->
				</div>
				
				

			
			<!-- modal -->
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                	<div class="modal-dialog">
                		<div class="modal-content">
                			<div class="modal-header">
                				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                				<h4 class="modal-title" id="myModalLabel">Modal title</h4>
                			</div>
                			<div class="modal-body">처리가 완료되었습니다</div>
                			<div class="modal-footer">
                				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                			</div>
                		</div>
                		<!-- /modal-content -->
                	</div>
                	<!-- /modal-dialog -->
                </div>
                <!-- /modal -->
            
            </div>  
            <!-- /row -->
		</div>
		<!-- /container -->
	</section>
	
	<script type="text/javascript">
	
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});

	$(document).ready(function() {

		var result = '<c:out value="${result}"/>';
		
		checkModal(result);
		
		history.replaceState({}, null, null);
		
		// 모달 출력
		function checkModal(result) {
			
			if(result === '') {
				return;
			}
			
			if(parseInt(result) > 0) {
				$(".modal-body").html("상품 번호" + parseInt(result) + " 번이 등록 되었습니다");
			}
			
			console.log(result);
			
			$("#myModal").modal("show");
		}
		
		// 페이징 버튼 이벤트
		var actionForm = $("#actionForm");
		
		$(".paginate_button a").on("click", function(e) {
			
			e.preventDefault();
			
			console.log('click');
			
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		// 게시물 상세 정보 클릭 이벤트
		$(".move").on("click", function(e) {
			e.preventDefault();
			actionForm.append("<input type='hidden' name='productsNo' value='" 
					+ $(this).attr("href")+"'>");
			actionForm.attr("action", "/products/get");
			actionForm.submit();
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
	
	<%@include file="../includes/footer.jsp" %>