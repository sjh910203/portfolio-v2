<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

<script type="text/javascript">
	var message = '${msg}'; 
	var returnUrl = '${url}'; 

	alert(message); 
	
	document.location.href = returnUrl; 
	

</script>

<%@include file="../includes/footer.jsp" %>