/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.affablebean.session;

import com.affablebean.entity.Product;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

@Repository
public class ProductFacade extends AbstractFacade<Product> {
	@PersistenceContext(unitName = "emf")
	private EntityManager em;

	protected EntityManager getEntityManager() {
		return em;
	}

	public ProductFacade() {
		super(Product.class);
	}

}