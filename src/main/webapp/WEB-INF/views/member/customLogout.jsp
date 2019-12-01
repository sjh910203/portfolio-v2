<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>

<body>
	<form action="/member/customLogout" method="get" id="logoutForm">
		
	</form>
</body>

<script type="text/javascript">
$("document").ready(function() {
	var logoutForm = $("#logoutForm");
	
	logoutForm.submit();
});
</script>

<%@include file="../includes/footer.jsp" %>