/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.affablebean.session;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

import com.affablebean.entity.Customer;

@Repository
public class CustomerFacade extends AbstractFacade<Customer> {
    @PersistenceContext(unitName = "emf")
    private EntityManager em;

    protected EntityManager getEntityManager() {
        return em;
    }

    public CustomerFacade() {
        super(Customer.class);
    }

}