<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../includes/header.jsp" %>

    <section>
        <div class="container">
            <div class="row">
                   
               <%@ include file="../includes/leftSideBar.jsp" %>

                <div class="col-sm-9 padding-right">
                    <div class="product-details">
                        <!--product-details-->
                        <div class="col-sm-5">
                        	<div class="row">
                            	<div class="view-product">
                            
                            	</div>
                            </div>
                        </div>
                        
                        <div class="col-sm-7">
                            <div class="product-information">
                                <!--/product-information-->
                                <img src="../../resources/images/new.jpg" class="newarrival" alt="">
                                <strong id="animalType"><c:out value="${products.animalType}"/> ></strong>
                                <strong id="productsType"><c:out value="${products.productsType}"/> ></strong>
                                <strong id="brand"><c:out value="${products.brand}"/></strong>
                                <hr>
                                <h2><c:out value="${products.productsName}" /></h2>
                                <p>Products NO : <c:out value="${products.productsNo}" /></p>
                                <span>
                                    <span><c:out value="${products.price}" /></span>
                                    <label>개수:</label>
                                    <input type="text" value="1" id="productsAmount">
                                    <button type="button" class="btn btn-fefault cart" id="addCart">
                                        <i class="fa fa-shopping-cart"></i>
                                        Add to cart
                                    </button>
                                </span>
                                <p><b>상품 종류: </b> <c:out value="${products.productsType}" /></p>
                                <p><b>브랜드: </b> <c:out value="${products.brand}"></c:out></p>
                                <a href="#"><img src="../../resources/images/share.png" class="share img-responsive" alt=""></a>
                                <button data-oper='list' class="btn btn-default" style="margin:10px;">목록</button>
                                <sec:authorize access="hasRole('ROLE_ADMIN')">
                                	<button data-oper='update' class="btn btn-default" style="margin:10px;">수정</button>
                             	</sec:authorize>
                             	<!-- <button data-oper='delete' class="btn btn-danger" style="margin:10px;">삭제</button> -->
                             	
                             	
                             	<form id='operForm' action="/petshop/update" method="get">
                             		<input type="hidden" name='productsNo' value='<c:out value="${products.productsNo }"/>' >
                             		<input type="hidden" name='pageNum' value='<c:out value="${cri.pageNum}"/>' >
                             		<input type="hidden" name='amount' value='<c:out value="${cri.amount}"/>' >
                             	</form>
                            </div>
                            <!--/product-information-->
                        </div>
                        
                        <div class="row">
                        	<div class="item">
                        		<ul>
                                    
                        		</ul>
                        	</div>
                        </div>
                    </div>
                    <!--/product-details-->
                    
                    <!-- 원본 이미지 출력 장소 -->
                    <div class="bigPicturePlace">
						<div class='bigPictureWrapper'>
							<div class="bigPicture">
		
							</div>
						</div>
					</div>

                    <%@ include file="../includes/productsDetails.jsp" %>

                </div>
            </div>
        </div>
    </section>
    
    <div id="addCartModal" class="modal fade" role="dialog">
	  <div class="modal-dialog">
	
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">장바구니</h4>
	      </div>
	      <div class="modal-body">
	        <p>장바구니에 상품이 추가되었습니다. 장바구니로 이동하시겠습니까?</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-warning" >이동</button>
	      </div>
	    </div>
	
	  </div>
	</div>

    <script type="text/javascript">
    	$(document).ready(function() {
    		
    		// 버튼 동작
    		var operForm = $("#operForm");
    		
    		$("button[data-oper = 'update']").on("click", function(e) {
    			
    			operForm.attr("action", "/petshop/update").submit();
    			
    		}); 
    		
    		$("button[data-oper = 'list']").on("click", function(e) {
    			
    			operForm.find("input[name=productsNo]").remove();
    			
    			operForm.attr("action", "/petshop/list");
    			
    			operForm.submit();
    		});
    		
    		// getAttachList
    		(function() {
    			
    			var productsNo = '<c:out value="${products.productsNo}"/>';
    			
    			$.getJSON("/petshop/getAttachList", {productsNo: productsNo}, function(obj) {
    				
    				console.log(obj);
    				
    				var str1 = ""; // .view-product
    				var str2 = ""; // .item
    				
    				$(obj).each(function(i, obj) {
    					
    					var fileCallPathT = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
    					var fileCallPathBT = encodeURIComponent(obj.uploadPath + "/bs_" + obj.uuid + "_" + obj.fileName);
    					
    					if(obj.imageType && i == 0) {
    						// 클릭시 원본 출력
    						str1 += "<input type='hidden' data-path='" + obj.uploadPath 
    						+ "' data-uuid='" + obj.uuid + "' data-filename='" 
    						+ obj.fileName + "' data-type='" + obj.imageType + "' >";
                            str1 += "<img src='/display?fileName=" + fileCallPathBT + "'>";
    					} 
    					
    					if(obj.imageType && 0 < i < 4) {
    						// 클릭시 큰 썸네일 출력
    						str2 += "<li id='item" + i + "' style='display:inline-block;'> <input type='hidden' data-path='" + obj.uploadPath 
    						+ "' data-uuid='" + obj.uuid + "' data-filename='" 
    						+ obj.fileName + "' data-type='" + obj.imageType + "' >";
    						str2 += "<img src='/display?fileName=" + fileCallPathT + "''> </li>";
    					}
    					
    					if(!obj.imageType) {
    						// 이미지 파일 아닐때. 클릭시 다운로드 
    						str2 += "<li id='item'" + i +"><input type='hidden' data-path='" + obj.uploadPath 
    						+ "' data-uuid='" + obj.uuid + "' data-filename='" 
    						+ obj.fileName + "' data-type='" + obj.imageType + "' >";
    						str2 += "<span> " + obj.fileName + "</span><br/>";
    						str2 += "<img src='/resources/images/attach.png'></li>";
    					}
    				
    				});
    				
    				// 첫번째 이미지 큰 화면 출력
    				$(".view-product").html(str1);
    				// 그 이후의 이미지 작은 화면 출력
    				$(".item ul").html(str2);
    			});
    		})();
    		
    		// view-product 클릭시 원본 이미지 출력
    		$(".view-product").on("click", function(e) {
    			
    			console.log("view image");
    			
    			var imgObj = $(".view-product input");
    			
    			var path = encodeURIComponent(imgObj.data("path") + "/" + imgObj.data("uuid") + "_" + imgObj.data("filename"));
    			
    			if(imgObj.data("type")) {
    				showImage(path.replace(new RegExp(/\\/g), "/"));
    			} 
    		});
    		
    		// 원본 이미지 출력
    		function showImage(fileCallPath) {
    			
    			console.log(fileCallPath);
    			
    			$(".bigPictureWrapper").css("display", "flex").show();
    			
    			$(".bigPicture")
    			.html("<img src='/display?fileName=" + fileCallPath + "'>")
    			.animate({width:'100%', height:'100%'}, 1000);
    		}
    		
    		// 원본 이미지 닫기
    		$(".bigPicturePlace").on("click", function(e) {
    			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
    			setTimeout(function() {
    				$('.bigPictureWrapper').hide();
    			}, 1000);
    		});
    		
    		// item 작은 썸네일을 큰 썸네일로 교체, 이미지가 아닐 경우 파일 다운로드
    		$(".item").on("click", "li", function(e) {
    			//var itemList = $(this).attr("id");
    			var selectItem = $(this).html();
    			var fileCallPathBT = encodeURIComponent($(selectItem).data("path") + "/bs_" + $(selectItem).data("uuid") + "_" + $(selectItem).data("filename"));
    			var fileType = $(selectItem).data("type");
    			var fileCallPath = encodeURIComponent($(selectItem).data("path") + "/" + $(selectItem).data("uuid") + "_" + $(selectItem).data("filename"));
    			var str = "";
    			
    			console.log(fileCallPath);
    			
    			if(fileType) {
    				str += "<input type='hidden' data-path='" + $(selectItem).data("path") 
    					+ "' data-uuid='" + $(selectItem).data("uuid") + "' data-filename='" 
    					+ $(selectItem).data("filename") + "' data-type='" + $(selectItem).data("type") + "' >";
    				str += "<img src='/display?fileName=" + fileCallPathBT + "'>";
    				
    				console.log(selectItem);
        			console.log(fileCallPathBT);
        			console.log(str);
    				$(".view-product").html(str);
    			} else {
    				
    				console.log("download file");
    				
    				self.location = "/download?fileName=" + fileCallPath;
    			}
    			
    		});

    		
    		$("#addCart").on("click", function(e) {
    			
    			e.preventDefault();
    			
    			if($("productsAmount").val() == 0) {
    				alert("0개는 등록이 안됩니다");
    			} else {
    			
	    			var cart = {
	    					pno : $("input[name=productsNo]").val(),
	    					amount : $("#productsAmount").val()
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
    			} //.else
    			
    		});
    	});
   
    </script>

<%@include file="../includes/footer.jsp" %>

