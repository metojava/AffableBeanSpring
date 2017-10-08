<%--
    Document   : category
    Created on : Jun 9, 2010, 3:59:32 PM
    Author     : tgiunipero
--%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <link rel="stylesheet" type="text/css" href="css/affablebean.css"> -->
<link href="<c:url value="/resources/css/affablebean.css" />"
	rel="stylesheet">
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/resources/img/favicon.ico">

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
                            </c:if> --%>

					<c:if
						test="${!empty cart && cart.numberOfItems != 0 &&

                                      !fn:contains(pageContext.request.servletPath,'/checkout') &&
                                      requestScope['javax.servlet.forward.servlet_path'] ne '/checkout' &&

                                      !fn:contains(pageContext.request.servletPath,'/cart') &&
                                      requestScope['javax.servlet.forward.servlet_path'] ne '/cart'}">

						<a href="checkout" class="bubble"> proceed to checkout
							&#x279f; </a>
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
                          item
                        </c:when>
							<c:otherwise>
                          items
                        </c:otherwise>
						</c:choose>
					</span>

					<c:if
						test="${!empty cart && cart.numberOfItems != 0 &&

                                  !fn:contains(pageContext.request.servletPath,'/cart') &&
                                  requestScope['javax.servlet.forward.servlet_path'] ne '/cart'}">

						<a href="viewCart" class="bubble"> view cart </a>
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
		<c:set var='view' value='/category' scope='session' />

		<c:set var='categoryIdIs' value='${selectedCategory.id}'
			scope='session' />

		<div id="categoryLeftColumn">

			<c:forEach var="category" items="${categories}">

				<c:choose>
					<c:when test="${category.name == selectedCategory.name}">
						<div class="categoryButton" id="selectedCategory">
							<span class="categoryText"> <spring:message
									code="${category.name}" />
							</span>
						</div>
					</c:when>
					<c:otherwise>
						<a href="<c:url value='category?${category.id}'/>"
							class="categoryButton"> <span class="categoryText"> <spring:message
									code="${category.name}" />
						</span>
						</a>
					</c:otherwise>
				</c:choose>

			</c:forEach>

		</div>
		-- ${pageContext.response.locale} --
		<div id="categoryRightColumn">

			<p id="categoryTitle">${selectedCategory.name}</p>

			<table id="productTable">

				<c:forEach var="product" items="${categoryProducts}"
					varStatus="iter">

					<tr class="${((iter.index % 2) == 0) ? 'lightBlue' : 'white'}">
						<td><img
							src="${pageContext.request.contextPath}${initParam.productImagePath}${product.name}.png"
							alt="${product.name}"></td>
						<td>${product.name}<br> <span class="smallText">${product.description}</span>
						</td>
						<td>&euro; ${product.price} / unit</td>
						<td><a href="addToCart/${product.id}">add to cart</a>
							<form action="addToCart" method="get">
								<input type="hidden" name="productId" value="${product.id}">
								<input type="hidden" name="categoryId"
									value="${selectedCategory.id}"> <input type="submit"
									value="add to cart">
							</form></td>
					</tr>

				</c:forEach>

			</table>
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