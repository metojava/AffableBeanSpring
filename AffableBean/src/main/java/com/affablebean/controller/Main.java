package com.affablebean.controller;

import java.util.Locale;

import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {

	public static void main(String[] args) {
		ApplicationContext context = 
	    		new ClassPathXmlApplicationContext(new String[] {"servlet.xml"});
		
		MessageSource ms = (MessageSource)context.getBean("messageSource");
		String title = ms.getMessage("greeting", new String[]{}, Locale.SIMPLIFIED_CHINESE);
		System.out.println(title);
	}

}
