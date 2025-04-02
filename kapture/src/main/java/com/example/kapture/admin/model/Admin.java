package com.example.kapture.admin.model;

import lombok.Data;

@Data
public class Admin {
	
	private int paymentNo;
	private int userNo;
	private int tourNo;
	private int amount;
	private String paymentDate;
	private String paymentStatus;
	private String method;
	private String merchantId;
	private int numPeople;
	private int basketNo;
	
}
