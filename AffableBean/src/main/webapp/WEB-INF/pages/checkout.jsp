<%--
    Document   : checkout
    Created on : Jun 9, 2010, 3:59:32 PM
    Author     : tgiunipero
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%--<sql:query var="categories" dataSource="jdbc/affablebean">
    SELECT * FROM category
</sql:query>

<sql:query var="selectedCategory" dataSource="jdbc/affablebean">
    SELECT name FROM category WHERE id = ?
    <sql:param value="${pageContext.request.queryString}"/>
</sql:query>

<sql:query var="categoryProducts" dataSource="jdbc/affablebean">
    SELECT * FROM product WHERE category_id = ?
    <sql:param value="${pageContext.request.queryString}"/>
</sql:query>--%>

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
	href="${pageContext.request.contextPath}/AffableBean/resources/img/favicon.ico">

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
									<c:when test="${pageContext.request.locale.language == 'cs'}">
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
										test="${sessionScope['javax.servlet.jsp.jstl.fmt.locale.session'] != 'cs'}">
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
										test="${sessionScope['javax.servlet.jsp.jstl.fmt.locale.session'] == 'cs'}">
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
				<c:set var='view' value='/checkout' scope='session' />

				<script src="js/jquery.validate.js" type="text/javascript"></script>

				<script type="text/javascript">
					$(document).ready(function() {
						$("#checkoutForm").validate({
							rules : {
								name : "required",
								email : {
									required : true,
									email : true
								},
								phone : {
									required : true,
									number : true,
									minlength : 9
								},
								address : {
									required : true
								},
								creditcard : {
									required : true,
									creditcard : true
								}
							}
						});
					});
				</script>


				<div id="singleColumn">

					<h2>checkout</h2>

					<p>In order to purchase the items in your shopping cart, please
						provide us with the following information:</p>

					<c:if test="${!empty orderFailureFlag}">
						<p class="error">We were unable to process your order. Please
							try again!</p>
					</c:if>

					<form id="checkoutForm" action="<c:url value='purchase'/>"
						method="post">
						<table id="checkoutTable">
							<c:if test="${!empty validationErrorFlag}">
								<tr>
									<td colspan="2" style="text-align: left"><span
										class="error smallText">Please provide valid entries
											for the following field(s): <c:if test="${!empty nameError}">
												<br>
												<span class="indent"><strong>name</strong> (e.g.,
													Bilbo Baggins)</span>
											</c:if> <c:if test="${!empty emailError}">
												<br>
												<span class="indent"><strong>email</strong> (e.g.,
													b.baggins@hobbit.com)</span>
											</c:if> <c:if test="${!empty phoneError}">
												<br>
												<span class="indent"><strong>phone</strong> (e.g.,
													222333444)</span>
											</c:if> <c:if test="${!empty addressError}">
												<br>
												<span class="indent"><strong>address</strong> (e.g.,
													Korunní 56)</span>
											</c:if> <c:if test="${!empty cityRegionError}">
												<br>
												<span class="indent"><strong>city region</strong>
													(e.g., 2)</span>
											</c:if> <c:if test="${!empty ccNumberError}">
												<br>
												<span class="indent"><strong>credit card</strong>
													(e.g., 1111222233334444)</span>
											</c:if>

									</span></td>
								</tr>
							</c:if>
							<tr>
								<td><label for="name">name:</label></td>
								<td class="inputField"><input type="text" size="31"
									maxlength="45" id="name" name="name" value="${param.name}">
								</td>
							</tr>
							<tr>
								<td><label for="email">email:</label></td>
								<td class="inputField"><input type="text" size="31"
									maxlength="45" id="email" name="email" value="${param.email}">
								</td>
							</tr>
							<tr>
								<td><label for="phone">phone:</label></td>
								<td class="inputField"><input type="text" size="31"
									maxlength="16" id="phone" name="phone" value="${param.phone}">
								</td>
							</tr>
							<tr>
								<td><label for="address">address:</label></td>
								<td class="inputField"><input type="text" size="31"
									maxlength="45" id="address" name="address"
									value="${param.address}"> <br> prague <select
									name="cityRegion">
										<c:forEach begin="1" end="10" var="regionNumber">
											<option value="${regionNumber}"
												<c:if test="${param.cityRegion eq regionNumber}">selected</c:if>>${regionNumber}</option>
										</c:forEach>
								</select></td>
							</tr>
							<tr>
								<td><label for="creditcard">credit card number:</label></td>
								<td class="inputField"><input type="text" size="31"
									maxlength="19" id="creditcard" name="creditcard"
									value="${param.creditcard}"></td>
							</tr>
							<tr>
								<td colspan="2"><input type="submit"
									value="submit purchase"></td>
							</tr>
						</table>
					</form>

					<div id="infoBox">

						<ul>
							<li>Next-day delivery is guaranteed</li>
							<li>A &euro; ${initParam.deliverySurcharge} delivery
								surcharge is applied to all purchase orders</li>
						</ul>

						<table id="priceBox">
							<tr>
								<td>subtotal:</td>
								<td class="checkoutPriceColumn">&euro; ${cart.subtotal}</td>
							</tr>
							<tr>
								<td>delivery surcharge:</td>
								<td class="checkoutPriceColumn">&euro;
									${initParam.deliverySurcharge}</td>
							</tr>
							<tr>
								<td class="total">total:</td>
								<td class="total checkoutPriceColumn">&euro; ${cart.total}</td>
							</tr>
						</table>
					</div>
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