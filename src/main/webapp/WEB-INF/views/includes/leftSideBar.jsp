<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

     <div class="col-sm-3">
                    <div class="left-sidebar">
                    <form id="listForm" action="/products/list" method="get">
                    	<div class="brands_products">
                    		<!--category-products-->
                        	<h2>CATEGORY</h2>
                            <div class="brands-name">
                                <ul class="nav nav-pills nav-stacked" id="p">
                                    <li><a href="#">사료</a></li>
                                    <li><a href="#">장난감</a></li>
                                    <li><a href="#">배변 패드</a></li>
                                    <li><a href="#">건강 관리</a></li>
                                    <li><a href="#">미용/목욕</a></li>
                                    <li><a href="#">급식기/급수기</a></li>
                                    <li><a href="#">하우스/울타리</a></li>
                                    <li><a href="#">이동장</a></li>
                                    <li><a href="#">기타</a></li>
                                </ul>
                            </div>
                        </div>
                        <!--/category-products-->

                        <div class="brands_products">
                            <!--brands_products-->
                            <h2>BRANDS</h2>
                            <div class="brands-name">
                                <ul class="nav nav-pills nav-stacked" id="b">
                                    <li><a href="#">로열캐닌</a></li>
                                    <li><a href="#">네츄럴코어</a></li>
                                    <li><a href="#">CJ</a></li>
                                    <li><a href="#">뉴트로초이스</a></li>
                                    <li><a href="#">퓨리나</a></li>
                                    <li><a href="#">동원</a></li>
                                    <li><a href="#">기타</a></li>
                                </ul>
                            </div>
                        </div>
                        <!--/brands_products-->

						<input type="hidden" name="type" value="">
						<input type="hidden" name="keyword" value="">
					</form>
                    </div>
                </div>
                
<script type="text/javascript">
	$(document).ready(function() {
		var listForm = $("#listForm");
		
		$('.left-sidebar li').on('click', function(e) {
			
			e.preventDefault();
			
			var type = $(this).parents().attr('id');
			var keyword = $(this).text();
			
			$("input[name=type]").val(type);
			$("input[name=keyword]").val(keyword);
			
			listForm.submit();
		});
	});
</script>