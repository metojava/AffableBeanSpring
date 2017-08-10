<%--
    Document   : cart
    Created on : Jun 9, 2010, 3:59:32 PM
    Author     : tgiunipero
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	href="/AffableBean/resources/img/favicon.ico">

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
<title><fmt:message key='title' /></title>
</head>
<body>
	<div id="main">
		<div id="header">
			<div id="widgetBar">

				<div class="headerWidget">

					<%-- If servlet path contains '/confirmation', do not display language toggle --%>
					<c:if
						test="${!fn:contains(pageContext.request.servletPath,'/confirmation')}">

						<%-- language selection widget --%>
						<c:choose>
							<%-- When user hasn't explicitly set language,
                             render toggle according to browser's preferred locale --%>
							<c:when
								test="${empty sessionScope['javax.servlet.jsp.jstl.fmt.locale.session']}">
								<c:choose>
									<c:when test="${pageContext.request.locale.language != 'cs'}">
                              english
                            </c:when>
									<c:otherwise>
										<c:url var="url" value="/affablebean/category/chooseLanguage">
											<c:param name="language" value="en" />
										</c:url>
										<div class="bubble">
											<a href="${url}">english</a>
										</div>
									</c:otherwise>
								</c:choose> |

                          <c:choose>
									<c:when test="${pageContext.request.locale.language eq 'cs'}">
                              Äesky
                            </c:when>
									<c:otherwise>
										<c:url var="url" value="/affablebean/category/chooseLanguage">
											<c:param name="language" value="cs" />
										</c:url>
										<div class="bubble">
											<a href="${url}">Äesky</a>
										</div>
									</c:otherwise>
								</c:choose>
							</c:when>

							<%-- Otherwise, render widget according to the set locale --%>
							<c:otherwise>
								<c:choose>
									<c:when
										test="${sessionScope['javax.servlet.jsp.jstl.fmt.locale.session'] ne 'cs'}">
                              english
                            </c:when>
									<c:otherwise>
										<c:url var="url" value="/affablebean/category/chooseLanguage">
											<c:param name="language" value="en" />
										</c:url>
										<div class="bubble">
											<a href="${url}">english</a>
										</div>
									</c:otherwise>
								</c:choose> |

                          <c:choose>
									<c:when
										test="${sessionScope['javax.servlet.jsp.jstl.fmt.locale.session'] eq 'cs'}">
                              Äesky
                            </c:when>
									<c:otherwise>
										<c:url var="url" value="/affablebean/category/chooseLanguage">
											<c:param name="language" value="cs" />
										</c:url>
										<div class="bubble">
											<a href="${url}">Äesky</a>
										</div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>

					</c:if>
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


				<%-- Set session-scoped variable to track the view user is coming from.
     This is used by the language mechanism in the Controller so that
     users view the same page when switching between English and Czech. --%>
				<c:set var='view' value='/cart' scope='session' />

				<div id="singleColumn">

					<c:choose>
						<c:when test="${cart.numberOfItems > 1}">
							<p>Your shopping cart contains ${cart.numberOfItems} items.</p>
						</c:when>
						<c:when test="${cart.numberOfItems == 1}">
							<p>Your shopping cart contains ${cart.numberOfItems} item.</p>
						</c:when>
						<c:otherwise>
							<p>Your shopping cart is empty.</p>
						</c:otherwise>
					</c:choose>

					<div id="actionBar">
						<%-- clear cart widget --%>
						<c:if test="${!empty cart && cart.numberOfItems != 0}">
							<a href="viewCart?clear=true" class="bubble hMargin">clear
								cart</a>
						</c:if>

						<%-- continue shopping widget --%>
						<c:set var="value">
							<c:choose>
								<%-- if 'selectedCategory' session object exists, send user to previously viewed category --%>
								<c:when test="${!empty selectedCategory}">
                    category/${selectedCategory}
                </c:when>
								<%-- otherwise send user to welcome page --%>
								<c:otherwise>
                    /AffableBean/affablebean/
                </c:otherwise>
							</c:choose>
						</c:set>

						<a href="${value}" class="bubble hMargin">continue shopping</a>

						<%-- checkout widget --%>
						<c:if test="${!empty cart && cart.numberOfItems != 0}">
							<a href="checkout" class="bubble hMargin">proceed to checkout
								&#x279f;</a>
						</c:if>
					</div>

					<c:if test="${!empty cart && cart.numberOfItems != 0}">

						<h4 id="subtotal">subtotal: &euro; ${cart.subtotal}</h4>

						<table id="cartTable">

							<tr class="header">
								<th>product</th>
								<th>name</th>
								<th>price</th>
								<th>quantity</th>
							</tr>

							<c:forEach var="cartItem" items="${cart.items}" varStatus="iter">

								<c:set var="product" value="${cartItem.product}" />

								<tr class="${((iter.index % 2) == 0) ? 'lightBlue' : 'white'}">
									<td><img
										src="${pageContext.request.contextPath}${initParam.productImagePath}${product.name}.png"
										alt="${product.name}"></td>

									<td>${product.name}</td>

									<td>&euro; ${cartItem.total} <br> <span
										class="smallText">( &euro; ${product.price} / unit )</span>
									</td>

									<td>
										<form action="updateCart" method="post">
											<input type="hidden" name="productId" value="${product.id}">
											<input type="text" maxlength="2" size="2"
												value="${cartItem.quantity}" name="quantity"
												style="margin: 5px"> <input type="submit"
												name="submit" value="update">
										</form>
									</td>
								</tr>

							</c:forEach>

						</table>

					</c:if>
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