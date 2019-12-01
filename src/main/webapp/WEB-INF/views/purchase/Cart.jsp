<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="../includes/header.jsp" %>

<style>
.cart_info {
	margin-top:5%;
}
</style>

<section id="cart_items">
		<div class="container">
			<div class="table-responsive cart_info">
				<table class="table table-condensed">
					<thead>
						<tr class="cart_menu">
							<td class="image">품목</td>
							<td class="description"></td>
							<td class="price">가격</td>
							<td class="quantity">개수</td>
							<td class="total">총 가격</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${cart}" varStatus="status"> 
							<tr>
								<td class="cart_product">
									<div id="img-side">
										<a href="#"><img src="#" id="cartAttach${status.index}"></a>
									</div>
								</td>
                                <td class="cart_description">
                                    <h4><a href="/products/get?productsNo=${item.products.get(0).productsNo}"><c:out value="${item.products.get(0).productsName}"/></a></h4>
                                        <p id="pno${status.index}"><c:out value="${item.products.get(0).productsNo}"/></p>
                                </td>
                                <td class="cart_price">
                                    <p id="price${status.index}"><c:out value="${item.products.get(0).price}"/></p>
                                </td>
                                <td class="cart_quantity">
                                    <div class="cart_quantity_button">
                                       <h2 id="quantity${status.index}">${item.amount}</h2>
                                    </div>
                                </td>
                                <td class="cart_total">
                                    <p class="cart_total_price" id="amountPrice${status.index}"></p>
                                </td>
                                <td class="cart_delete">
                                    <a class="cart_quantity_delete" href="#">
                                    	<i class="fa fa-times">
                                        	<input type="hidden" name="cartNo" id="cartNo${status.index}" value="<c:out value='${item.cartNo}'/> " >
                                        </i>
                                    </a>
                                </td>
                           </tr>
                           <input type="hidden" id="imageType${status.index}" value="${item.products.get(0).attachList.get(0).imageType}" />
                           <input type="hidden" id="uuid${status.index}" value="${item.products.get(0).attachList.get(0).uuid}" />
                           <input type="hidden" id="uploadPath${status.index}" value="${item.products.get(0).attachList.get(0).uploadPath}" />
                           <input type="hidden" id="fileName${status.index}" value="${item.products.get(0).attachList.get(0).fileName}" />
                       </c:forEach>
					</tbody>
				</table>
				 <div>
				 	<input type="hidden" id="size" value="${fn:length(cart)}" />
				 	<input type="hidden" id="email" value="${member.email}" />
                    <input type="hidden" id="name" value="${member.name}" />
                    <input type="hidden" id="postCode" value="${member.postCode}" />
                    <input type="hidden" id="address" value="${member.address}" />
                    <input type="hidden" id="phoneNumber" value="${member.phoneNumber}" />        	
                 </div>
			</div>
		</div>
	</section> <!--/#cart_items-->

	<section id="do_action">
		<div class="container">
			<div class="heading">
				<h3>결제 방법 선택</h3>
				<p>결제 방법을 선택해주세요</p>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="chose_area">
                        <ul>
                            <li>
                                <ul>
                                    <li>
                                        <label>결제 방법</label>
                                    </li>
                                    <li>
                                        <tr>
                                            <td><!-- 하나만 선택되게 하기 -->
                                                <input type="radio">
                                                <label>신용카드</label>
                                            </td>
                                            <td>
                                                <input type="radio">
                                                <label>계좌이체</label>
                                            </td>
                                            <td>
                                                <input type="radio">
                                                <label>핸드폰 결제</label>
                                            </td>
                                        </tr>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <ul>
                                    <li>
                                        <label>배송 방법</label>
                                    </li>
                                    <li>
                                        <tr>
                                            <td><!-- 하나만 선택되게 하기 -->
                                                <input type="radio">
                                                <label>택배 배송</label>
                                            </td>
                                            <td>
                                                <input type="radio">
                                                <label>방문 수령</label>
                                            </td>
                                        </tr>
                                    </li>
                                </ul>
                            </li>    
                        </ul>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="total_area">
						<ul>
							<li>상품 가격 <span id="totalPrice">${totalPrice}</span></li>
							<li>배송비 <span></span></li>
							<li>총 가격 <span></span></li>
						</ul>
							<a class="btn btn-default check_out" href="#" id="checkOut">결제하기</a>
					</div>
				</div>
			</div>
		</div>
	</section><!--/#do_action-->

<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<script type="text/javascript" src="/resources/js/ajaxError.js"></script>

<script type="text/javascript">
$(document).ready(function() {

	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
	
	// 장바구니 상품 이미지
	for(var i = 0; i < $("#size").val(); i++) {
		var imgSrci = null;
		var uuid = $("#uuid" + i).val();
		var uploadPath = $("#uploadPath" + i).val();
		var fileName = $("#fileName" + i).val();
		
		if($("#imageType" + i).val()) {
			imgSrci = encodeURIComponent(uploadPath + "/s_" + uuid + "_" + fileName);
			imgSrci = "/display?fileName=" + imgSrci;
		} else {
			imgSrci = '../../resources/images/attach.png';
		}
	
		console.log(imgSrci);
		
		$("#cartAttach" + i).attr("src", imgSrci);
	}
	
	// 각 항목 합계 가격
	for(var i = 0; i < $("#size").val(); i++) {
		var price = $("#price" + i).html();
		var amount = $("#quantity" + i).html();
		
		var amountPrice = price*amount;
		
		$("#amountPrice" + i).html(amountPrice);
	}
	
	$(".cart_delete").on("click", "a", function(e) {
		var cartNumber = $(this).find("input[name=cartNo]").val();
		
		console.log(cartNumber);
		
		$.ajax({
			type: 'post',
			url: '/purchase/deleteCartItem',
			data: JSON.stringify(cartNumber),
			contentType: "application/json; charset=utf-8",
			dataType: 'text',
			success: function(result, status, xhr) {
			  	console.log('delete cart item ' + result);

			  	alert("상품이 장바구니에서 삭제 되었습니다");
			  	
			  	location.replace("/purchase/Cart");
			  }
		});
	});
	
	console.log($("#totalPrice").html());
	
	var IMP = window.IMP;
	IMP.init('imp85199466');
	
	// 결제 api
	$("#checkOut").on("click", function(e) {	
		var msg;
		var date = new Date();
		
		IMP.request_pay({
			pg: 'kakaopay',
			pay_method: 'card',
			merchant_uid: 'merchant_' + date.getTime(),
			name: 'PETSHOP 반려동물 용품 결제',
			amount: $("#totalPrice").html(),
			buyer_email: $("#email").val(),
			buyer_name: $("#name").val(),
			buyer_tel: $("#phoneNumber").val(),
			buyer_addr: $("#address").val(),
			buyer_postcode: $("#postCode").val(),
		}, function(rsp) {
			if (rsp.success) {
				// orderLog 배열 저장
				var orderLogVO = new Array();
				
				$(".cart_product").each(function(i) {
			
					var pno = $("#pno" + i).html();
					var payAmount = $("#quantity" + i).html();
					var payPrice = $("#amountPrice" + i).html();
					
					var data = [];
					
					data[i] = {
							pno : pno,
							payAmount : payAmount,
							payPrice : payPrice
					};
					
					orderLogVO.push(data[i]);
					
					console.log(data[i]);
				});
				
				console.log(orderLogVO);
				
				// 구매 이력 기록
				$.ajax({
					traditional : true,
					type:'post',
					url: "/purchase/afterPurchase",
					data: JSON.stringify(orderLogVO),
					contentType: "application/json; charset=utf-8",
					dataType: 'text',
					success: function(result, status, xhr) {
						console.log("after purchase process success");
						callback(result);
					}
				});
				
				// 장바구니 내용물 삭제
				$(".cart_product").each(function(i) {
					var cartNumber = $("#cartNo" + i).val();
					
					console.log("delete cart Item " + cartNumber);
					
					$.ajax({
						type: 'post',
						url: '/purchase/deleteCartItem',
						data: JSON.stringify(cartNumber),
						contentType: "application/json; charset=utf-8",
						dataType: 'text',
						success: function(result, status, xhr) {
						  	console.log('delete cart item ' + result);
						  }
					});	
				});
				
				var msg = '결제가 완료되었습니다. ';
				msg += ' 고유ID : ' + rsp.imp_uid;
				msg += ' 상점 거래ID : ' + rsp.merchant_uid;
				msg += ' 결제 금액 : ' + rsp.paid_amount;
				msg += ' 카드 승인번호 : ' + rsp.apply_num;
			} else {
				msg = '결제에 실패하였습니다. ';
				msg += '에러 내용 : ' + rsp.error_msg;
				}

			alert(msg);
			location.replace('/purchase/Cart'); // 성공 후 처리 필요
		});
	});

});
</script>

<%@include file="../includes/footer.jsp" %>