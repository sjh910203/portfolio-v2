<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
    
<style>
#productsTable {
	border: 1px solid;
	margin: 10px;
}

#productsTable td {
	border: 1px solid;
	width: 175px;
	height: 100px;
	font-size: 20px;
	font-family: 'Roboto', sans-serif;
	font-weight: 300;
	padding: 10px;
}

#productsTable #tableHead {
	background-color: #696763;
}
</style>

<!--category-tab-->
<div class="category-tab shop-details-tab">
	<div class="row">
		<div class="detail-bar col-sm-12">
			<ul class="nav nav-tabs">
				<li class="nav-item active"><a class="nav-link" href="#explain" data-toggle="tab">Details</a></li>
				<li class="nav-item" id="reviews-btn"><a class="nav-link" href="#reviews" data-toggle="tab">Reviews</a></li>
			</ul>
		</div>
		<div class="col-sm-12">
			<table id="productsTable">
				<tr>
					<td id="tableHead">대상 동물</td>
					<td>${products.animalType}</td>
					<td id="tableHead">브랜드</td>
					<td>${products.brand}</td>
				</tr>
				<tr>
					<td id="tableHead">상품명</td>
					<td>${products.explain}</td>
					<td id="tableHead">가격</td>
					<td>${products.price}</td>
				</tr>
				<tr>
					<td id="tableHead">상품 설명</td>
					<td colspan="3">${products.explain}</td>
				</tr>
			</table>
		</div>
	</div>
			
	<div class="row">
		<div class="detail-bar col-sm-12">
			<ul class="nav nav-tabs">
				<li class="nav-item"><a class="nav-link" href="#explain" data-toggle="tab">Details</a></li>
				<li class="nav-item active" id="reviews-btn"><a class="nav-link" href="#reviews" data-toggle="tab">Reviews</a></li>
			</ul>
		</div>
		<div class="col-sm-12">
			<div>
				<div class="reviewsList">
					<ul>
						
					</ul>
				</div>
				<div class="reviewsPage">
				
				</div>
				<sec:authorize access="isAuthenticated()">
					<form action="/reviews/new" id="reviewsForm" method="post">
						<span>
							<strong>작성자 : </strong>
							<input type="email" name="reviewer" placeholder="작성자" value='<sec:authentication property="principal" />' readonly>
						</span>
						<br>
						<strong>상품평</strong>
						<br>
						<textarea name="reviews"></textarea>
						<button type="button" id="addReviews" class="btn btn-default pull-right">등록 </button>
					</form>	
				</sec:authorize>	
				<sec:authorize access="isAnonymous()">
					<p>상품평 작성은 로그인을 하면 가능합니다</p>
				</sec:authorize>
			</div>
		</div>
	</div>

	
	<!-- modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLable">상품평</h4>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>상품평</label>
						<input type="text" class="form-control" name='modalReviews' value=''>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input type="email" class="form-control" name='modalReviewer' value=''>
					</div>
					<div class="form-group">
						<label>작성날짜</label>
						<input class="form-control" name='reviewDate' value=''>
					</div>
					<br>
					<strong>상품평을 고치실려면 내용을 바꾸시고 수정버튼을 눌러주세요</strong>
				</div>
				
				<sec:authorize access="isAuthenticated()">
					<div class="modal-footer">
						<button id='modalModBtn' type="button" class="btn btn-warning">수정</button>
						<button id='modalRemoveBtn' type="button" class="btn btn-danger">삭제</button>
					</div>
				</sec:authorize>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</div>
<!--/category-tab-->

<script type="text/javascript" src="/resources/js/reviews.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		// csrf토큰
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
		
		
		console.log("reviews script");

		var productsNoValue = '<c:out value="${products.productsNo}" />';
		var reviewsList = $(".reviewsList");

		showList(1);	
		
		var pageNum = 1;
		var reviewsPageFooter = $(".reviewsPage");
		
		// 상품평 페이징
		function showReviewsPage(reviewsCnt) {
			var endNum = Math.ceil(pageNum / 5.0) * 5;
			var startNum = endNum - 4;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 5 >= reviewsCnt) {
				endNum = Math.ceil(reviewsCnt/5.0);
			}
			
			if(endNum * 5 < reviewsCnt) {
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			
			if(prev) {
				str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Previous</a></li>";
			}
			
			for(var i = startNum; i <= endNum; i++) {
				var active = pageNum == i ? "active" : "";
				
				str += "<li class='page-item " + active + "'> <a class='page-link' href='" + i + "'>" + i +"</a></li>";
			}
			
			if(next) {
				str += "<li class='page-item'> <a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
			}
			
			str +="</ul></div>";
			
			//console.log(str);
			
			reviewsPageFooter.html(str);
		} // /showReviewsPage
		
		// 상품평 출력
		function showList(page) {
			
			console.log("show reivews list " + page);

			reviewsService.getList({productsNo:productsNoValue, page: page || 1}, function(reviewsCnt, list) {
				console.log("reviewsCnt: " + reviewsCnt);
				
				if(page == -1) {
					pageNum = Math.ceil(reviewsCnt/5.0);
					showList(pageNum);
					
					return
				}
				
				var str = "";
				
				if(list == null || list.length == 0) {
					reviewsList.html("");
					
					return;
				}
				
				for(var i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class='rev' style='list-style:none;' data-reviewsno='" + list[i].reviewsNo + "'>" 
					str += "<div class='row' style='border-bottom:1px solid; margin:10px;'> <div class='col-sm-3'><i class='fa fa-user'></i>" + list[i].reviewer + "</div>";
					str += "<div class='col-sm-4'></div>";
					str += "<div class='col-sm-3'><i class='fa fa-calendar-o'></i>" + reviewsService.displayTime(list[i].reviewDate) + "</div></div>";
					str += "<p>" + list[i].reviews + "</p>";
					str += "</li>";
				}
				
				reviewsList.html(str);
				//console.log(str);
				showReviewsPage(reviewsCnt);
			});
		} // /showList

		// 페이지 버튼
		reviewsPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			console.log("page click");
			
			var targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum : " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		}); // /reviewsPageFooter
		
		// 상품평 작성 변수
		var reviewsText = $("textarea[name='reviews']"); // 상품평
		var reviewerInput = $("input[name='reviewer']"); // 작성자
		
		// 모달 변수
		var modal = $(".modal");
		var modalInputReviews = modal.find("input[name='modalReviews']");
		var modalInputReviewer = modal.find("input[name='modalReviewer']");
		var modalInputReviewDate = modal.find("input[name='reviewDate']");
	
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");

		// 상품평 추가
		$("#addReviews").on("click", function(e) {
			e.preventDefault();
			console.log("add reviews");

			var reviews = {
				reviews: reviewsText.val(),
				reviewer: reviewerInput.val(),
				productsNo: productsNoValue
			}
			// reviews, reviewer, productsNo
			reviewsService.add(reviews, function(result) {
				alert("상품평 등록이 완료되었습니다.");
				reviewsText.val("");
				showList(1);
			});
		}); // /new
		
		// 모달 호출
		$(".reviewsList").on("click", "li", function(e) {
			var reviewsNo = $(this).data("reviewsno");
			
			console.log(reviewsNo);
			
			reviewsService.get(reviewsNo, function(reviews) {
				
				modalInputReviews.val(reviews.reviews);
				modalInputReviewer.val(reviews.reviewer).attr("readonly", "readonly");
				modalInputReviewDate.val(reviewsService.displayTime(reviews.reviewDate)).attr("readonly", "readonly");
				modal.data("reviewsNo", reviews.reviewsNo);

				$("#myModal").modal("show");
			});
		});
	
		// 수정
		modalModBtn.on("click", function(e) {
			var reviewsNo = modal.data("reviewsNo");
			var reviewer = reviewerInput.val(); // 로그인한 계정의 아이디
			var originalReviewer = modalInputReviewer.val(); // 상품평db에 등록된 작성자
			
			var reviews = {reviewsNo:reviewsNo, reviews:modalInputReviews.val(), reviewer: originalReviewer};

			if(!reviewer) {
				alert("로그인 후 수정이 가능합니다");
				modal.modal("hide");
				return;
			}
			
			console.log("ReviewsNo : " + reviewsNo);
			console.log("Reviewer : " + reviewer);
			console.log("Original Reviewer : " + originalReviewer);
			
			if(reviewer != originalReviewer) {
				alert("자신이 작성한 상품평만 수정이 가능합니다");
				modal.modal("hide");
				return;
			}
			
			reviewsService.update(reviews, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		// 삭제
		modalRemoveBtn.on("click", function(e) {
			var reviewsNo = modal.data("reviewsNo");
			var reviewer = reviewerInput.val(); // 로그인한 계정의 아이디
			var originalReviewer = modalInputReviewer.val(); // 상품평db에 등록된 작성자
			
			console.log("ReviewsNo : " + reviewsNo);
			console.log("Reviewer : " + reviewer);
			
			if(!reviewer) {
				alert("로그인 후 삭제가 가능합니다");
				modal.modal("hide");
				return;
			}
			
			console.log("Original Reviewer : " + originalReviewer);
			
			if(reviewer != originalReviewer) {
				alert("자신이 작성한 상품평만 삭제가 가능합니다");
				modal.modal("hide");
				return;
			}
			
			reviewsService.remove(reviewsNo, originalReviewer, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
	});
	
</script>