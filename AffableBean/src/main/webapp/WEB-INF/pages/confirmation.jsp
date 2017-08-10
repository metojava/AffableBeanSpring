<%--
    Document   : confirmation
    Created on : Sep 9, 2009, 12:20:30 AM
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

				<div id="singleColumn">

					<p id="confirmationText">
						<strong>Your order has been successfully processed and
							will be delivered within 24 hours.</strong> <br> <br> Please
						keep a note of your confirmation number: <strong>${orderRecord.confirmationNumber}</strong>
						<br> If you have a query concerning your order, feel free to
						<a href="#">contact us</a>. <br> <br> Thank you for
						shopping at the Affable Bean Green Grocer!
					</p>

					<div class="summaryColumn">

						<table id="orderSummaryTable" class="detailsTable">
							<tr class="header">
								<th colspan="3">order summary</th>
							</tr>

							<tr class="tableHeading">
								<td>product</td>
								<td>quantity</td>
								<td>price</td>
							</tr>

							<c:forEach var="orderedProduct" items="${orderedProducts}"
								varStatus="iter">

								<tr class="${((iter.index % 2) != 0) ? 'lightBlue' : 'white'}">
									<td>${products[iter.index].name}</td>
									<td class="quantityColumn">${orderedProduct.quantity}</td>
									<td class="confirmationPriceColumn">&euro;
										${products[iter.index].price * orderedProduct.quantity}</td>
								</tr>

							</c:forEach>

							<tr class="lightBlue">
								<td colspan="3" style="padding: 0 20px"><hr></td>
							</tr>

							<tr class="lightBlue">
								<td colspan="2" id="deliverySurchargeCellLeft"><strong>delivery
										surcharge:</strong></td>
								<td id="deliverySurchargeCellRight">&euro;
									${initParam.deliverySurcharge}</td>
							</tr>

							<tr class="lightBlue">
								<td colspan="2" id="totalCellLeft"><strong>total:</strong></td>
								<td id="totalCellRight">&euro; ${orderRecord.amount}</td>
							</tr>

							<tr class="lightBlue">
								<td colspan="3" style="padding: 0 20px"><hr></td>
							</tr>

							<tr class="lightBlue">
								<td colspan="3" id="dateProcessedRow"><strong>date
										processed:</strong> ${orderRecord.dateCreated}</td>
							</tr>
						</table>

					</div>

					<div class="summaryColumn">

						<table id="deliveryAddressTable" class="detailsTable">
							<tr class="header">
								<th colspan="3">delivery address</th>
							</tr>

							<tr>
								<td colspan="3" class="lightBlue">${customer.name}<br>
									${customer.address} <br> Prague ${customer.cityRegion} <br>
									<hr> <strong>email:</strong> ${customer.email} <br> <strong>phone:</strong>
									${customer.phone}
								</td>
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