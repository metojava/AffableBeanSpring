/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.affablebean.session;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

import com.affablebean.entity.OrderedProduct;

@Repository
public class OrderedProductFacade extends AbstractFacade<OrderedProduct> {
	@PersistenceContext(unitName = "emf")
	private EntityManager em;

	protected EntityManager getEntityManager() {
		return em;
	}

	public OrderedProductFacade() {
		super(OrderedProduct.class);
	}

	// manually created
	public List<OrderedProduct> findByOrderId(Object id) {
		return em.createNamedQuery("OrderedProduct.findByCustomerOrderId").setParameter("customerOrderId", id)
				.getResultList();
	}

}