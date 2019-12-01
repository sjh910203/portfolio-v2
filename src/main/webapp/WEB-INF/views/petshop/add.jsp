<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

<section>
    <div class="container">
        <div class="row">

            <%@include file="../includes/leftSideBar.jsp" %>

            <div class="col-sm-9 padding-right">
                <div class="product-information">
                    <!--/product-information-->
                    <form id="addForm" action="/petshop/add" method="post">
                        <h2><b>카테고리</b></h2>
                        <div class="row">

                            <div class="form-group col-sm-2">
                                <select id="animalType" name="animalType">
                                    <option value="개">개</option>
                                    <option value="고양이">고양이</option>
                                    <option value="파충류">파충류</option>
                                    <option value="조류">조류</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>

                            <div class="form-group col-sm-2">
                                <select id="productsType" name="productsType">
                                    <option value="사료">사료</option>
                                    <option value="장난감">장난감</option>
                                    <option value="배변 패드">배변 패드</option>
                                    <option value="건강 관리">건강 관리</option>
                                    <option value="미용/목욕">미용/목욕</option>
                                    <option value="급식기/급수기">급식기/급수기</option>
                                    <option value="하우스/울타리">하우스/울타리</option>
                                    <option value="이동장">이동장</option>
                                    <option value="의류">의류</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>

                            <div class="form-group col-sm-2">
                                <select id="brand" name="brand">
                                    <option value="로열캐닌">로열캐닌</option>
                                    <option value="네츄럴코어">네츄럴코어</option>
                                    <option value="CJ">CJ</option>
                                    <option value="뉴트로초이스">뉴트로초이스</option>
                                    <option value="퓨리나">퓨리나</option>
                                    <option value="동원">동원</option>
                                    <option value="네이쳐스 버라이어티">네이쳐스 버라이어티</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <h2><b>상품명 : </b></h2>
                            <input class="form-control" name='productsName'>
                        </div>

                        <div class="form-group">
                            <h2><b>가격 : </b></h2>
                            <input class="form-control" name='price'>
                        </div>

                        <div class="form-group">
                            <h2><b>상품 설명</b></h2>
                            <textarea class="form-control" rows="3" name='explain'></textarea>
                        </div>
                        
                        <div class="form-group">
                        	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </div>

                        <button id="addBtn" type="submit" class="btn btn-default">등록</button>
                        <button type="reset" class="btn btn-default">초기화</button>

                        <!-- 
                        <input type='hidden' id="animalTypeHidden" name='animalType' value='<c:out value="${products.animalType}" />' >
                		<input type='hidden' id="productsTypeHidden" name='productsType' value='<c:out value="${products.productsType}" />' >
                		<input type='hidden' id="brandHidden" name='brand' value='<c:out value="${products.brand}" />' >
                					 -->
                    </form>
                </div>
                <!--/product-information-->
            </div>

            <div class="col-sm-9 padding-right">
                <div class="panel panel-default" style="margin-top:5px; border-radius:5px;">
                    <div class="panel-heading">파일 첨부</div>

                    <div class="panel-body">
                        <div class="form-group uploadDiv">
                            <input type="file" name='uploadFile' id="uploadInput" multiple>
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

    //-->

    $(document).ready(function(e) {

        var formObj = $("#addForm");

        $("#addBtn").on("click", function(e) {

            e.preventDefault();

            console.log("submit clicked");

            var str = "";

            $(".uploadResult ul li").each(function(i, obj) {

                var jobj = $(obj);

                console.dir(jobj);
                console.log(jobj.data("filename"));

                str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data('filename') + "'>";
                str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data('uuid') + "'>";
                str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data('path') + "'>";
                str += "<input type='hidden' name='attachList[" + i + "].imageType' value='" + jobj.data('type') + "'>";
            });

            console.log(str);

            formObj.append(str).submit();

            console.log(formObj);
        });

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

        // 파일 업로드 결과
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

        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";
        
        $(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});

        $(".uploadResult").on("click", "button", function(e) {

            console.log("delete file");

            var targetFile = $(this).data("file");
            var type = $(this).data("type");

            var targetLi = $(this).closest("li");

            $.ajax({
                url: '/deleteFile',
                data: {
                    fileName: targetFile,
                    type: type
                },
                dataType: 'text',
                type: 'POST',
                success: function(result) {
                    alert(result);
                    targetLi.remove();
                    $("#uploadInput").val("");
                }
            });
            // $.ajax
        });
        
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

    });
</script>

<%@include file="../includes/footer.jsp" %>