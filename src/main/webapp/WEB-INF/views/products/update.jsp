<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<section>
    <div class="container">
        <div class="row">

            <%@include file="../includes/leftSideBar.jsp"%>

            <div class="col-sm-9 padding-right">
                <div class="product-information">
                    <!--/product-information-->
                    <form id='updateForm' action="/products/update" method="post">
                        <div class="form-group">
                            <input type="hidden" class="form-control" id='productsNo' name='productsNo' value='<c:out value="${products.productsNo}" /> '>
                        </div>

                        <div class="form-group">
                            <h2>
                                <b>카테고리</b>
                            </h2>
                            <select id='animalType' name='animalType'>
                                <option value="개" <c:if test='${products.animalType == "개" }'>selected</c:if>>개</option>
                                <option value="고양이" <c:if test='${products.animalType == "고양이" }'>selected</c:if>>고양이</option>
                                <option value="파충류" <c:if test='${products.animalType == "파충류" }'>selected</c:if>>파충류</option>
                                <option value="조류" <c:if test='${products.animalType == "조류" }'>selected</c:if>>조류</option>
                                <option value="기타" <c:if test='${products.animalType == "기타" }'>selected</c:if>>기타</option>
                            </select>
                            <select id='productsType' name='productsType'>
                                <option value="사료" <c:if test='${products.productsType == "사료" }'>selected</c:if>>사료</option>
                                <option value="장난감" <c:if test='${products.productsType == "장난감" }'>selected</c:if>>장난감</option>
                                <option value="배변 패드" <c:if test='${products.productsType == "배변 패드" }'>selected</c:if>>배변 패드</option>
                                <option value="건강 관리" <c:if test='${products.productsType == "건강 관리" }'>selected</c:if>>건강 관리</option>
                                <option value="미용/목욕" <c:if test='${products.productsType == "미용/목욕" }'>selected</c:if>>미용/목욕</option>
                                <option value="급식기/급수기" <c:if test='${products.productsType == "급식기/급수기" }'>selected</c:if>>급식기/급수기</option>
                                <option value="하우스/울타리" <c:if test='${products.productsType == "하우스/울타리" }'>selected</c:if>>하우스/울타리</option>
                                <option value="이동장" <c:if test='${products.productsType == "이동장" }'>selected</c:if>>이동장</option>
                                <option value="의류" <c:if test='${products.productsType == "의류" }'>selected</c:if>>의류</option>
                                <option value="기타" <c:if test='${products.productsType == "기타" }'>selected</c:if>>기타</option>
                            </select>
                            <select id='brand' name='brand'>
                                <option value="로열캐닌" <c:if test='${products.brand == "로열캐닌" }'>selected</c:if>>로열캐닌</option>
                                <option value="네츄럴코어" <c:if test='${products.brand == "네츄럴코어" }'>selected</c:if>>네츄럴코어</option>
                                <option value="CJ" <c:if test='${products.brand == "CJ" }'>selected</c:if>>CJ</option>
                                <option value="뉴트로초이스" <c:if test='${products.brand == "뉴트로초이스" }'>selected</c:if>>뉴트로초이스</option>
                                <option value="퓨리나" <c:if test='${products.brand == "퓨리나" }'>selected</c:if>>퓨리나</option>
                                <option value="동원" <c:if test='${products.brand == "동원" }'>selected</c:if>>동원</option>
                                <option value="네이쳐스 버라이어티" <c:if test='${products.brand == "네이쳐스 버라이어티" }'>selected</c:if>>네이쳐스 버라이어티</option>
                                <option value="기타" <c:if test='${products.brand == "기타" }'>selected</c:if>>기타</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <h2>
                                <b>상품명 : </b>
                            </h2>
                            <input class="form-control" name='productsName' value='<c:out value="${products.productsName}" />'>
                        </div>

                        <div class="form-group">
                            <h2>
                                <b>가격 : </b>
                            </h2>
                            <input class="form-control" name='price' value='<c:out value="${products.price}" />'>
                        </div>

                        <div class="form-group">
                            <h2>
                                <b>상품 설명</b>
                            </h2>
                            <textarea class="form-control" rows="3" name='explain'>
                            <c:out value="${products.explain}" /> 
                            </textarea>
                        </div>
                        
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <button data-oper='update' class="btn btn-default">수정</button>
                        <button data-oper='delete' class="btn btn-warning">삭제</button>
                        <button data-oper='list' class="btn btn-default">목록</button>

                        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}" />'> 
                        <input type='hidden' name='amount' value='<c:out value="${cri.amount}" />'>
                        <input type='hidden' name='type' value='<c:out value="${cri.type}" />' >
                        <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}" />' >
                    </form>
                </div>
                <!--/product-information-->
            </div>

            <div class="col-sm-9 padding-right">
                <div class="panel panel-default" style="margin-top:5px; border-radius:5px;">
                    <div class="panel-heading">파일 첨부</div>

                    <div class="panel-body">
                        <div class="form-group uploadDiv">
                            <input type="file" name='uploadFile' multiple>
                        </div>

                        <div class='uploadResult'>
                            <ul>

                            </ul>
                        </div>
                    </div>
                    <!-- ./panel-body -->
                </div>
                <!-- ./panel -->
            </div>

        </div>
    </div>
</section>

<script type="text/javascript">
    <!--

    -->

    $(document).ready(function() {

        var updateForm = $("#updateForm");

        $('button').on("click", function(e) {

            e.preventDefault();

            var operation = $(this).data("oper");

            console.log(operation);

            if(operation === 'delete') {
                updateForm.attr("action", "/products/delete");
            } else if(operation === 'list') {
                updateForm.attr("action", "/products/list").attr("method", "get");
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var typeTag = $("input[name='type']").clone();
				var keywordTag = $("input[name='keyword']").clone();
                
                updateForm.empty();
                updateForm.append(pageNumTag);
                updateForm.append(amountTag);
                updateForm.append(typeTag);
                updateForm.append(keywordTag);
            } else if(operation === 'update') {
            	
            	var str = "";
            	
            	$(".uploadResult ul li").each(function(i, obj) {
            		
            		var jobj = $(obj);
            		
            		console.dir("jobj : " + jobj);
            		
            		 str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data('filename') + "'>";
                     str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data('uuid') + "'>";
                     str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data('path') + "'>";
                     str += "<input type='hidden' name='attachList[" + i + "].imageType' value='" + jobj.data('type') + "'>";
                 });
            	
            	console.log("str = " + str);
								
            	updateForm.append(str).submit();

            }

            updateForm.submit();

        });
        
     	// getAttachList
     	(function() {
     		
     		var productsNo = '<c:out value="${products.productsNo}" />';
     		
     		$.getJSON("/products/getAttachList", {productsNo: productsNo}, function(obj) {

     			console.log(obj);
     			
     			var str = "";
     			
     			$(obj).each(function(i, obj) {
     				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
     				
     				if(obj.imageType) {
     					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" +
                        obj.uuid + "' data-filename='" + obj.fileName +
                        	"' data-type='" + obj.imageType + "' ><div>";
                    	str += "<span> " + obj.fileName + "</span>";
                    	str += "<button type='button' data-file=\'" + fileCallPath +
                        	"\' data-type='image' class='btn btn-warning btm-circle'> <i class='fa fa-times'></i></button><br>";
                    	str += "<img src='/display?fileName=" + fileCallPath + "'>";
                    	str += "</div>";
                    	str + "</li>";
     				} else {
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
                        var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                        str += "<li data-path='" + obj.uploadPath + "' data-uuid='" +
                            obj.uuid + "' data-filename='" + obj.fileName +
                            "' data-type='" + obj.imageType + "' ><div>";
                        str += "<span> " + obj.fileName + "</span>";
                        str += "<button type='button' data-file=\'" + fileCallPath +
                            "\' data-type='file' class='btn btn-warning btm-circle'> <i class='fa fa-times'></i></button><br>";
                        str += "<img src='../../resources/images/attach.png'>";
                        str += "</div>";
                        str + "</li>";
                    }
     			});
     			
     			$(".uploadResult ul").html(str);
     		});
     		
     	})();
     	// .getAttachList

     	// delete file
     	$(".uploadResult").on("click", "button", function(e) {

            console.log("delete file");

            if(confirm("이 파일을 삭제할까요?")) {
            	var targetLi = $(this).closest("li");
            	targetLi.remove();
            	$("#uploadInput").val("");
            }
        });
     	// .delete file
     	
     	// 파일 용량, 확장자 체크
        var regex = new RegExp("(.*?)\.(exe\sh\zip\alz)$");
        var maxSize = 5424880; //5MB

        function checkExtension(fileName, fileSize) {

            if (fileSize >= maxSize) {
                alert("파일 사이즈 초과");

                return false;
            }

            if (regex.test(fileName)) {
                alert("해당 종류의 파일은 업로드 할 수 없습니다");

                return false;
            }

            return true;
        }
        
     	// show upload result
        function showUploadResult(uploadResultArr) {

            if (!uploadResultArr || uploadResultArr.length == 0) {
                return;
            }

            var uploadUL = $(".uploadResult ul");

            var str = "";

            $(uploadResultArr).each(function(i, obj) {
                if (obj.imageType) {
                    var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" +
                        obj.uuid + "' data-filename='" + obj.fileName +
                        "' data-type='" + obj.imageType + "' ><div>";
                    str += "<span> " + obj.fileName + "</span>";
                    str += "<button type='button' data-file=\'" + fileCallPath +
                        "\' data-type='image' class='btn btn-warning btm-circle'> <i class='fa fa-times'></i></button><br>";
                    str += "<img src='/display?fileName=" + fileCallPath + "'>";
                    str += "</div>";
                    str + "</li>";
                } else {
                    var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" +
                        obj.uuid + "' data-filename='" + obj.fileName +
                        "' data-type='" + obj.imageType + "' ><div>";
                    str += "<span> " + obj.fileName + "</span>";
                    str += "<button type='button' data-file=\'" + fileCallPath +
                        "\' data-type='file' class='btn btn-warning btm-circle'> <i class='fa fa-times'></i></button><br>";
                    str += "<img src='../../resources/images/attach.png'>";
                    str += "</div>";
                    str + "</li>";
                }
            });

            uploadUL.append(str);
        }
     	// .show upload result
     	
     	var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

        $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
        
     	// file upload
     	$("input[type='file']").change(function(e) {

            var formData = new FormData();

            var inputFile = $("input[name='uploadFile']");

            var files = inputFile[0].files;

            console.log(files);

            for (var i = 0; i < files.length; i++) {

                if (!checkExtension(files[i].name, files[i].size)) {
                    return false;
                }

                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: '/uploadAjaxAction',
                processData: false,
                contentType: false,
                data: formData,
                type: 'POST',
                dataType: 'json',
                success: function(result) {
                    console.log("success" + result);
                    showUploadResult(result);
                }
            });

        });
     	// .file upload

    });
</script>

<%@include file="../includes/footer.jsp"%>