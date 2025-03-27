package com.example.kapture.mypage.model;

import lombok.Data;

@Data
public class Payments {
	private String paymentNo;
	private String userNo;
	private String tourNo;
	private String amount;
	private String paymentDate;
	private String paymentStatus;
	private String method;
	private String title;
	private String duration;
	private String tourDate;
}
