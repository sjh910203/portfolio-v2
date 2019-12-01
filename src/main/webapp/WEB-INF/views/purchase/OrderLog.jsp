<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="../includes/header.jsp" %>

<style>
#orderContainer {
	margin-bottom: 50px;
}

#order_items .order_info {
    border: 1px solid #E6E4DF;
    margin-top: 10px;
}

#order_items .order_info .order_menu {
    background: #FE980F;
    color: #fff;
    font-size: 15px;
    font-family: 'Roboto', sans-serif;
    font-weight: normal;
}

#order_items .order_info .table.table-condensed thead tr {
    height: 51px;
}

#order_items .order_info .table.table-condensed tr {
    border-bottom: 1px solid#F7F7F0;
}

#order_items .order_info .table.table-condensed tr:last-child {
    border-bottom: 0;
}

.order_info table tr td {
    border-top: 0 none;
    vertical-align: inherit;
    margin-right: 5px;
}

#order_items .order_info .image {
    padding-left: 30px;
}


</style>

<div class="container">
		<div class="col-sm-12">
			<section id="order_items">
				<div class="container" id="orderContainer">
					<div class="table-responsive order_info">
						<table class="table table-condensed">
							<thead>
								<tr class="order_menu">
									<td>주문 번호</td>
									<td></td>
									<td>상품 번호</td>
									<td>수량</td>
									<td>가격</td>
									<td>결제 방법</td>
									<td>결제 상태</td>
									<td>결제 날짜</td>
									<td>배송 상태</td>
									<td></td>
								</tr>
							</thead>	
							<tbody>
								<c:forEach var="item" items="${orderLog}" varStatus="status">
									<tr>
										<td class="order_logNo">
											<div>
												<p id="logNo">${item.logNo}</p>
											</div>
										</td>
										<td class="order_product">
											<div id="img-side">
												<a href="#"><img src="#" id="orderAttach${status.index}"></a>
											</div>
										</td>
										<td class="order_pno">
											<div>
												<h4>${item.products.get(0).productsName}</h4>
											</div>
											<div id="pno">
												<p>${item.pno}</p>
											</div>
										</td>
										<td class="order_payAmount">
											<div>
												<p id="payAmount">${item.payAmount}</p>
											</div>
										</td>
										<td class="order_payPrice">
											<div>
												<p id="payPrice">${item.payPrice}</p>
											</div>
										</td>
										<td class="order_payMethod">
											<div>
												<p id="payMethod">${item.payMethod}</p>
											</div>
										</td>
										<td class="order_payStatus">
											<div>
												<p id="payStatus">${item.payStatus}</p>
											</div>
										</td>
										<td class="order_payDate">
											<div>
												<p id="payDate${status.index}">${item.payDate}</p>
											</div>
										</td>
										<td class="order_expressStatus">
											<div>
												<p id="expressStatus">${item.expressStatus}</p>
											</div>
										</td>
									</tr>
									<div>
										<input type="hidden" id="imageType${status.index}" value="${item.products.get(0).attachList.get(0).imageType}" />
				                        <input type="hidden" id="uuid${status.index}" value="${item.products.get(0).attachList.get(0).uuid}" />
				                        <input type="hidden" id="uploadPath${status.index}" value="${item.products.get(0).attachList.get(0).uploadPath}" />
				                        <input type="hidden" id="fileName${status.index}" value="${item.products.get(0).attachList.get(0).fileName}" />
									</div>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<p>환불을 원하시는 분은 고객센터를 통해 문의해주세요</p>
				</div>
			</section>
			<input type="hidden" id="size" value="${fn:length(orderLog)}" />
		</div>
</div>

<script type="text/javascript" src="/resources/js/ajaxError.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
	
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
		
		$("#orderAttach" + i).attr("src", imgSrci);
	}
    
	function displayTime(timeValue) {
		
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap < (1000 * 60 * 60 * 24)) {
			
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : 0) + mi, ':', (ss > 9 ? '' : 0) + ss].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
		}
	}
    
	$(".order_payDate").each(function(i) {
		var payDate = $("#payDate" + i).html();
		
		$("#payDate" + i).html(displayTime(payDate));
		
		console.log(payDate);
	});
  
});
</script>

<%@include file="../includes/footer.jsp" %>