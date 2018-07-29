package com.affablebean.controller;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.servlet.ModelAndView;

import com.affablebean.cart.ShoppingCart;
import com.affablebean.entity.Category;
import com.affablebean.entity.Product;
import com.affablebean.session.CategoryFacade;
import com.affablebean.session.OrderManager;
import com.affablebean.session.ProductFacade;
import com.affablebean.validator.Validator;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Controller
@EnableSwagger2
@Api(value = "/*", description = "main controller of affablebean application")
public class MainCotroller implements ServletContextAware, MessageSourceAware {

	private final static org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(MainCotroller.class);

	@Autowired
	CategoryFacade categoryFacade;

	@Autowired
	ProductFacade productFacade;

	@Autowired
	private Validator validator;

	@Autowired
	private OrderManager orderManager;

	private ServletContext servletContext;

	private String surcharge;

	Category selectedCategory;
	Collection<Product> categoryProducts;

	@PostConstruct
	public void init() {

		surcharge = servletContext.getInitParameter("deliverySurcharge");
		// servletContext.setAttribute("categories", categoryFacade.findAll());
		// // :)
	}

	@ApiOperation(value = "displays index page with product types")
	@RequestMapping(value = { "/", "/index.jsp" }, method = RequestMethod.GET)
	public ModelAndView index() {

		ModelAndView mv = new ModelAndView("index");
		mv.addObject("categories", categoryFacade.findAll());
		logger.debug("added categories " + categoryFacade.findAll());
		mv.addObject("surcharge", surcharge);
		mv.addObject("title", "AffableBean");
		return mv;
	}

	@ApiOperation(value = "displays category page with selected category products")
	@RequestMapping(value = "/category/{categoryId}", method = RequestMethod.GET)
	public ModelAndView category(@PathVariable("categoryId") String categoryId, HttpServletRequest request,
			HttpServletResponse response) {
		HttpSession session = request.getSession();

		ModelAndView mv = new ModelAndView("category");
		mv.addObject("categories", categoryFacade.findAll());
		if (categoryId != null) {
			// get selected category
			selectedCategory = categoryFacade.find(Short.parseShort(categoryId));
			mv.addObject("selectedCategory", selectedCategory);
			// get all products for selected category
			categoryProducts = selectedCategory.getProductCollection();// productFacade.findAll();
			// place category products in request scope
			mv.addObject("categoryProducts", categoryProducts);
			session.setAttribute("categoryProducts", categoryProducts);
		}
		// log.info("selected " + categories.size() + " videos");
		return mv;
	}

	@ApiOperation(value = "displays viewcart page with user selected products")
	@RequestMapping(value = "/category/viewCart", method = RequestMethod.GET)
	public String viewCart(HttpServletRequest request, HttpServletResponse response) {

		String clear = request.getParameter("clear");
		HttpSession session = request.getSession();

		if ((clear != null) && clear.equals("true")) {

			ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");
			cart.clear();
		}
		return "/cart";
	}

	@RequestMapping(value = "/category/checkout", method = RequestMethod.GET)
	public String checkout(HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();

		ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

		// calculate total
		if (cart != null && !CollectionUtils.isEmpty(cart.getItems()))
			cart.calculateTotal(surcharge);

		return "/checkout";
	}

	@RequestMapping(value = "/category/chooseLanguage", method = RequestMethod.GET)
	public String chooseLanguage(HttpServletRequest request, HttpServletResponse response) {

		String language = request.getParameter("language");
		String userPath = "";
		// place in request scope
		request.setAttribute("language", language);
		HttpSession session = request.getSession();
		String userView = (String) session.getAttribute("view");

		if ((userView != null) && (!userView.equals("/index"))) {
			userPath = userView;
		} else {

			return "redirect:/";
		}

		if ("/category".equals(userView)) {
			Short categoryIdIs = (Short) session.getAttribute("categoryIdIs");
			String url = new StringBuilder("redirect:/affablebean").append(userView).append("/").append(categoryIdIs)
					.toString();
			return url;
		}
		String url = new StringBuilder("redirect:/" + userView).toString(); // append("/").append(categoryIdIs).toString();
		return url;
	}

	// post requests

	@RequestMapping(value = "/category/addToCart", method = RequestMethod.GET)
	public String addToCart(@RequestParam("productId") String productId, @RequestParam("categoryId") String categoryId,
			HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

		if (cart == null) {

			cart = new ShoppingCart();
			session.setAttribute("cart", cart);
		}

		// get user input from request
		// String productId = request.getParameter("productId");

		if (!productId.isEmpty()) {

			Product product = productFacade.find(Integer.parseInt(productId));
			cart.addItem(product);
		}
		// StringBuilder sb = new
		// StringBuilder("redirect:/affablebean/category/");
		String url = new StringBuilder("redirect:/category/").append(categoryId).toString();
		return url;
	}

	@RequestMapping(value = "/category/{categoryId}/addToCart/{productId}", method = RequestMethod.GET)
	public String addtoCart(@PathVariable("categoryId") Integer categoryId,
			@PathVariable("productId") Integer productId, HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

		if (cart == null) {

			cart = new ShoppingCart();
			session.setAttribute("cart", cart);
		}

		// get user input from request
		// String productId = request.getParameter("productId");

		if (productId != null) {

			Product product = productFacade.find(productId);
			cart.addItem(product);
		}
		// StringBuilder sb = new
		// StringBuilder("redirect:/affablebean/category/");
		String url = new StringBuilder("redirect:/category/").append(categoryId).toString();
		return url;
	}

	@RequestMapping(value = "/category/purchase", method = RequestMethod.POST)
	public String purchase(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");
		String userPath = request.getServletPath();
		if (cart != null) {

			// extract user data from request
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String address = request.getParameter("address");
			String cityRegion = request.getParameter("cityRegion");
			String ccNumber = request.getParameter("creditcard");

			// validate user data
			boolean validationErrorFlag = false;
			validationErrorFlag = validator.validateForm(name, email, phone, address, cityRegion, ccNumber, request);

			// if validation error found, return user to checkout
			if (validationErrorFlag == true) {
				request.setAttribute("validationErrorFlag", validationErrorFlag);
				userPath = "/checkout";

				// otherwise, save order to database
			} else {

				int orderId = orderManager.placeOrder(name, email, phone, address, cityRegion, ccNumber, cart);

				// if order processed successfully send user to confirmation
				// page
				if (orderId != 0) {

					// dissociate shopping cart from session
					cart = null;

					// end session
					session.invalidate();

					// get order details
					Map orderMap = orderManager.getOrderDetails(orderId);

					// place order details in request scope
					request.setAttribute("customer", orderMap.get("customer"));
					request.setAttribute("products", orderMap.get("products"));
					request.setAttribute("orderRecord", orderMap.get("orderRecord"));
					request.setAttribute("orderedProducts", orderMap.get("orderedProducts"));

					userPath = "/confirmation";

					// otherwise, send back to checkout page and display error
				} else {
					userPath = "/checkout";
					request.setAttribute("orderFailureFlag", true);

				}
			}
		}

		return userPath;
	}

	@RequestMapping(value = "/category/updateCart", method = RequestMethod.POST)
	public String updateCart(HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

		String productId = request.getParameter("productId");
		String quantity = request.getParameter("quantity");

		boolean invalidEntry = validator.validateQuantity(productId, quantity);

		if (!invalidEntry) {

			Product product = productFacade.find(Integer.parseInt(productId));
			cart.update(product, quantity);
		}

		return "/cart";
	}

	// @RequestMapping(value = "/maintenance")
	// public String getMaintenance() {
	// return "/maintenance";
	// }

	// doesn't working :)
	@ModelAttribute
	public List<Category> getCategories() {
		return categoryFacade.findAll();
	}

	@Override
	public void setServletContext(ServletContext context) {

		this.servletContext = context;
	}

	private MessageSource messageSource;

	@Override
	public void setMessageSource(MessageSource messageSource) {

		this.messageSource = messageSource;
	}
}
