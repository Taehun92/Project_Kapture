package com.example.kapture.payment.model;

import lombok.Data;

@Data
public class Payment {

	private int paymentNo;  
	private int userNo; 
	private int tourNo; 
	private int amount; 
	private String paymentDate; 
	private String paymentStatus; 
	private String method;
	
	private String basketNo;
	private String numPeople;
	
	
}
