<%--
    Document   : index
    Created on : Jun 9, 2010, 3:59:32 PM
    Author     : tgiunipero
--%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%--<sql:query var="categories" dataSource="jdbc/affablebean">
    SELECT * FROM category
</sql:query>--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link href="<c:url value="/resources/css/affablebean.css" />"
	rel="stylesheet">
<%--  <script src="<c:url value="/resources/js/jquery.1.10.2.min.js" />"></script>
    <script src="<c:url value="/resources/js/main.js" />"></script> --%>

<link rel="shortcut icon" href="img/favicon.ico">
<script
	src="<c:url value="${pageContext.request.contextPath}/AffableBean/resources/js/jquery.1.10.2.min.js" />"></script>
<script
	src="${pageContext.request.contextPath}/AffableBean/resources/js/jquery-ui-1.8.4.custom.min.js"
	type="text/javascript"></script>
<script
	src="<c:url value="${pageContext.request.contextPath}/AffableBean/resources/js/jquery.validate.js" />"></script>


<script type="text/javascript">
	$(document).ready(function() {
		$('a.categoryButton').hover(function() {
			$(this).animate({
				backgroundColor : '#b2d2d2'
			})
		}, function() {
			$(this).animate({
				backgroundColor : '#d3ede8'
			})
		});

		$('div.categoryBox').hover(over, out);

		function over() {
			var span = this.getElementsByTagName('span');
			$(span[0]).animate({
				opacity : 0.3
			});
			$(span[1]).animate({
				color : 'white'
			});

		}

		function out() {
			var span = this.getElementsByTagName('span');
			$(span[0]).animate({
				opacity : 0.7
			});
			$(span[1]).animate({
				color : '#444'
			});
		}
	});
</script>
<title>The Affable Bean</title>
</head>
<body>
	<div id="main">
		<div id="header">
			<div id="widgetBar">

				<div class="headerWidget">[ language toggle ]</div>

				<div class="headerWidget">[ checkout button ]</div>

				<div class="headerWidget">[ shopping cart widget ]</div>

			</div>

			<a href="index.jsp"> <img src="/resources/img/logo.png" id="logo"
				alt="Affable Bean logo">
			</a> <img src="/resources/img/logoText.png" id="logoText"
				alt="the affable bean">
		</div>
		<div id="indexLeftColumn">
			<div id="welcomeText">
				<p style="font-size: larger">Welcome to the online home of the
					Affable Bean Green Grocer.</p>

				<p>Enjoy browsing and learning more about our unique home
					delivery service bringing you fresh organic produce, dairy, meats,
					breads and other delicious and healthy items to your doorstep.</p>
			</div>
		</div>

		<div id="indexRightColumn">
			<c:forEach var="category" items="${categories}">
				<div class="categoryBox">
					<a href="category?${category.id}"> <span class="categoryLabel"></span>
						<span class="categoryLabelText">${category.name}</span> <img
						src="${initParam.categoryImagePath}${category.name}.jpg"
						alt="${category.name}" class="categoryImage">
					</a>
				</div>
			</c:forEach>
		</div>

		<div id="footer">
			<br>
			<hr>
			<p id="footerText" class="reallySmallText">
				<a href="#">Privacy Policy</a> &nbsp;&nbsp;::&nbsp;&nbsp; <a
					href="#">Contact</a> &nbsp;&nbsp;&copy;&nbsp;&nbsp; 2010 the
				affable bean
			</p>
		</div>
	</div>
</body>
</html>