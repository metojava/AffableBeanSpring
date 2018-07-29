package com.affablebean.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.affablebean.entity.Customer;
import com.affablebean.entity.CustomerOrder;
import com.affablebean.session.CustomerFacade;
import com.affablebean.session.CustomerOrderFacade;
import com.affablebean.session.OrderManager;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private final static org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(AdminController.class);

	@Autowired
	private OrderManager orderManager;
	@Autowired
	private CustomerFacade customerFacade;
	@Autowired
	private CustomerOrderFacade customerOrderFacade;

	private String userPath;
	private Customer customer;
	private CustomerOrder order;
	private List orderList = new ArrayList();
	private List customerList = new ArrayList();

	@RequestMapping(value = { "/", "/index.jsp" }, method = RequestMethod.GET)
	public ModelAndView index() {

		ModelAndView mv = new ModelAndView("index");
		// mv.addObject("categories", categoryFacade.findAll());
		// logger.debug("added categories " + categoryFacade.findAll());
		// mv.addObject("surcharge", surcharge);
		mv.addObject("title", "AffableBean");
		return mv;
	}

	@RequestMapping(value = { "/admin/viewCustomers" })
	public ModelAndView viewCustomers() {
		ModelAndView mv = new ModelAndView("index");
		customerList = customerFacade.findAll();
		mv.addObject("customerList", customerList);
		return mv;
	}

	@RequestMapping(value = { "/admin/viewOrders" })
	public ModelAndView viewOrders() {
		ModelAndView mv = new ModelAndView("index");
		orderList = customerOrderFacade.findAll();
		mv.addObject("orderList", orderList);
		return mv;
	}

	@RequestMapping(value = { "/admin/customerRecord" })
	public ModelAndView customerRecord(@RequestParam("customerId") String customerId) {
		ModelAndView mv = new ModelAndView("index");
		// get customer details
		customer = customerFacade.find(Integer.parseInt(customerId));
		mv.addObject("customerRecord", customer);

		// get customer order details
		order = customerOrderFacade.findByCustomer(customer);
		mv.addObject("order", order);

		mv.addObject("orderList", orderList);
		return mv;
	}

	@RequestMapping(value = { "/admin/orderRecord" })
	public ModelAndView orderRecord(@RequestParam("orderId") String orderId) {
		ModelAndView mv = new ModelAndView("index");

		Map orderMap = orderManager.getOrderDetails(Integer.parseInt(orderId));

		// place order details in request scope
		mv.addObject("customer", orderMap.get("customer"));
		mv.addObject("products", orderMap.get("products"));
		mv.addObject("orderRecord", orderMap.get("orderRecord"));
		mv.addObject("orderedProducts", orderMap.get("orderedProducts"));

		return mv;
	}

	@RequestMapping(value = { "/admin/logout" })
	public String logout(HttpServletRequest request) {

		HttpSession session = request.getSession(true);
		session.invalidate(); // terminate session

		return "redirect:/admin";
	}
}
