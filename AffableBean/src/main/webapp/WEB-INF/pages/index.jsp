<%--
    Document   : index
    Created on : Jun 9, 2010, 3:59:32 PM
    Author     : tgiunipero
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%-- Set language based on user's choice --%>
<c:if test="${!empty language}">
	<fmt:setLocale value="${language}" scope="session" />
</c:if>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link href="<c:url value="/resources/css/affablebean.css" />"
	rel="stylesheet">

<link type="text/css"
	href="<%=request.getContextPath()%>/resources/css/affablebean.css"
	rel="stylesheet">
<%--  <script src="<c:url value="/resources/js/jquery.1.10.2.min.js" />"></script>
    <script src="<c:url value="/resources/js/main.js" />"></script> --%>

<link rel="shortcut icon"
	href="<%=request.getContextPath()%>/resources/img/favicon.ico">

<script src="<c:url value="/resources/js/jquery-1.4.2.js" />"></script>
<script
	src="<c:url value="/resources/js/jquery-ui-1.8.4.custom.min.js" />"></script>
<script src="<c:url value="/resources/js/jquery.validate.js" />"></script>


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

<title><fmt:message key='title' /></title>
</head>
<body>
	<div id="main">
		<div id="header">
			<div id="widgetBar">

				<div class="headerWidget">
					Language : <a href="?language=en">English</a> | <a
						href="?language=cs">Czech</a>

				</div>

				<%-- checkout widget --%>
				<div class="headerWidget">

					<%-- tests for the following:
                            * if cart exists and is not empty
                            * if the servlet path does not contain '/checkout'
                            * if the requested view is not checkout
                            * if the servlet path does not contain '/cart'
                            * if the requested view is not cart
                            * if the checkout view is returned with order failure message flagged
                            * if the checkout view is returned with server-side validation errors detected

                            <c:if test="${!empty sessionScope.cart}">
                                CART EXISTS AND IS NOT NULL
                            </c:if>
                                <BR>
                            <c:if test="${sessionScope.cart.numberOfItems != 0}">
                                NUMBER OF ITEMS IN CART IS NOT 0
                            </c:if>
                                <BR>
                            <c:if test="${fn:contains(pageContext.request.servletPath,'/checkout')}">
                                SERVLET PATH CONTAINS '/checkout'
                            </c:if>
                                <BR>
                            <c:if test="${requestScope['javax.servlet.forward.servlet_path'] ne '/checkout'}">
                                REQUEST IS NOT CHECKOUT
                            </c:if>
                                <BR>
                            <c:if test="${requestScope.validationErrorFlag ne true}">
                                VALIDATION ERROR IS NOT FLAGGED
                            </c:if>
                                <BR>
                            <c:if test="${requestScope.orderFailureFlag ne true}">
                                ORDER FAILURE ERROR IS NOT FLAGGED
                            </c:if> --%>

					<c:if
						test="${!empty cart && cart.numberOfItems != 0 &&

                                  !fn:contains(pageContext.request.servletPath,'/checkout') &&
                                  requestScope['javax.servlet.forward.servlet_path'] ne '/checkout' &&

                                  !fn:contains(pageContext.request.servletPath,'/cart') &&
                                  requestScope['javax.servlet.forward.servlet_path'] ne '/cart' &&

                                  validationErrorFlag ne true &&
                                  orderFailureFlag ne true}">

						<a href="<c:url value='checkout'/>" class="bubble"> <fmt:message
								key="proceedCheckout" />
						</a>
					</c:if>
				</div>

				<%-- shopping cart widget --%>
				<div class="headerWidget" id="viewCart">

					<img
						src="${pageContext.request.contextPath}/resources/img/cart.gif"
						alt="shopping cart icon" id="cart">

					<%-- If 'numberOfItems' property doesn't exist, or if number of items
                       in cart is 0, output '0', otherwise output 'numberOfItems' --%>
					<span class="horizontalMargin"> <c:choose>
							<c:when test="${cart.numberOfItems == null}">
                          0
                        </c:when>
							<c:otherwise>
                          ${cart.numberOfItems}
                        </c:otherwise>
						</c:choose> <%-- Handle singular/plural forms of 'item' --%> <c:choose>
							<c:when test="${cart.numberOfItems == 1}">
								<fmt:message key="item" />
							</c:when>
							<c:when
								test="${cart.numberOfItems == 2 ||
                                        cart.numberOfItems == 3 ||
                                        cart.numberOfItems == 4}">
								<fmt:message key="items2-4" />
							</c:when>
							<c:otherwise>
								<fmt:message key="items" />
							</c:otherwise>
						</c:choose>
					</span>

					<c:if
						test="${!empty cart && cart.numberOfItems != 0 &&

                                  !fn:contains(pageContext.request.servletPath,'/cart') &&
                                  requestScope['javax.servlet.forward.servlet_path'] ne '/cart'}">

						<a href="<c:url value='viewCart'/>" class="bubble"> <fmt:message
								key="cart" />
						</a>
					</c:if>
				</div>
			</div>

			<a href="index.jsp"> <img
				src="${pageContext.request.contextPath}/resources/img/logo.png"
				id="logo" alt="Affable Bean logo">
			</a> <img
				src="${pageContext.request.contextPath}/resources/img/logoText.png"
				id="logoText" alt="the affable bean">
		</div>
		<%-- Set session-scoped variable to track the view user is coming from.
     This is used by the language mechanism in the Controller so that
     users view the same page when switching between English and Czech. --%>
		<c:set var='view' value='/index' scope='session' />

		<div id="indexLeftColumn">
			<div id="welcomeText">
				<p style="font-size: larger">
					<spring:message code='greeting' />
				</p>

				<p>
					<spring:message code='introText' />
				</p>
			</div>
		</div>
		locale language - ${pageContext.request.locale.language}
		<div id="indexRightColumn">
			<c:forEach var="category" items="${categories}">
				<div class="categoryBox">
					<a href="<c:url value='category/${category.id}'/>"> <span
						class="categoryLabel"></span> <span class="categoryLabelText"><fmt:message
								key='${category.name}' /></span> <img
						src="${pageContext.request.contextPath}${initParam.categoryImagePath}${category.name}.jpg"
						alt="<spring:message code='${category.name}'/>"
						class="categoryImage">
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