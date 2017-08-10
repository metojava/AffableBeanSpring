/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.affablebean.session;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

import com.affablebean.entity.Category;

@Repository
public class CategoryFacade extends AbstractFacade<Category> {
	@PersistenceContext(unitName = "emf")
	private EntityManager em;

	protected EntityManager getEntityManager() {
		return em;
	}

	public CategoryFacade() {
		super(Category.class);
	}

}