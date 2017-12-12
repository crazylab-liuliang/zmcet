<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	try{
		int money = 100;
		int number = 0;
		request.setAttribute("result", "AAAA");	
	}catch(Exception e){
		request.setAttribute("result", "dfdfdf");
	}
%>

<jsp:forward page="test2.jsp" />

</body>
</html>