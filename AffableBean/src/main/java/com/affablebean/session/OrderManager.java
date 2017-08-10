/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.affablebean.session;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.affablebean.cart.ShoppingCart;
import com.affablebean.cart.ShoppingCartItem;
import com.affablebean.entity.Customer;
import com.affablebean.entity.CustomerOrder;
import com.affablebean.entity.OrderedProduct;
import com.affablebean.entity.OrderedProductPK;
import com.affablebean.entity.Product;

/**
 *
 * @author tgiunipero
 */
@Component
@Transactional
public class OrderManager {

	@PersistenceContext(unitName = "emf")
	private EntityManager em;
	@Resource
	private ServletContext context;
	
	@Autowired
	private ProductFacade productFacade;
	@Autowired
	private CustomerOrderFacade customerOrderFacade;
	@Autowired
	private OrderedProductFacade orderedProductFacade;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int placeOrder(String name, String email, String phone, String address, String cityRegion, String ccNumber,
			ShoppingCart cart) {

		try {
			Customer customer = addCustomer(name, email, phone, address, cityRegion, ccNumber);
			CustomerOrder order = addOrder(customer, cart);
			addOrderedItems(order, cart);
			return order.getId();
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly(); // or
																					// rollbackFor
																					// =
																					// Exception.class
			return 0;
		}
	}

	private Customer addCustomer(String name, String email, String phone, String address, String cityRegion,
			String ccNumber) {

		Customer customer = new Customer();
		customer.setName(name);
		customer.setEmail(email);
		customer.setPhone(phone);
		customer.setAddress(address);
		customer.setCityRegion(cityRegion);
		customer.setCcNumber(ccNumber);

		em.persist(customer);
		return customer;
	}

	private CustomerOrder addOrder(Customer customer, ShoppingCart cart) {

		// set up customer order
		CustomerOrder order = new CustomerOrder();
		order.setCustomer(customer);
		order.setAmount(BigDecimal.valueOf(cart.getTotal()));

		// create confirmation number
		Random random = new Random();
		int i = random.nextInt(999999999);
		order.setConfirmationNumber(i);

		em.persist(order);
		return order;
	}

	private void addOrderedItems(CustomerOrder order, ShoppingCart cart) {

		em.flush();

		List<ShoppingCartItem> items = cart.getItems();

		// iterate through shopping cart and create OrderedProducts
		for (ShoppingCartItem scItem : items) {

			int productId = scItem.getProduct().getId();

			// set up primary key object
			OrderedProductPK orderedProductPK = new OrderedProductPK();
			orderedProductPK.setCustomerOrderId(order.getId());
			orderedProductPK.setProductId(productId);

			// create ordered item using PK object
			OrderedProduct orderedItem = new OrderedProduct(orderedProductPK);

			// set quantity
			orderedItem.setQuantity(scItem.getQuantity());

			em.persist(orderedItem);
		}
	}

	public Map getOrderDetails(int orderId) {

		Map orderMap = new HashMap();

		// get order
		CustomerOrder order = customerOrderFacade.find(orderId);

		// get customer
		Customer customer = order.getCustomer();

		// get all ordered products
		List<OrderedProduct> orderedProducts = orderedProductFacade.findByOrderId(orderId);

		// get product details for ordered items
		List<Product> products = new ArrayList<Product>();

		for (OrderedProduct op : orderedProducts) {

			Product p = (Product) productFacade.find(op.getOrderedProductPK().getProductId());
			products.add(p);
		}

		// add each item to orderMap
		orderMap.put("orderRecord", order);
		orderMap.put("customer", customer);
		orderMap.put("orderedProducts", orderedProducts);
		orderMap.put("products", products);

		return orderMap;
	}

}