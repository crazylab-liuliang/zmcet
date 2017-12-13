<%--
	若当前登录用户无在学习课程时，跳转到 add_course.jsp页面
	否则 跳转到 当前课程页面 course.jsp
	当前页面显示所有已选择课程。
	
	学习完成显示彩色，根据课程测试结果显示金边，星级。
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>智盟</title>
</head>
<body>
<jsp:forward page="student/course.jsp?id=1&user=2" />
</body>
</html>