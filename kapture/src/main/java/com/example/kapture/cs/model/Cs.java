package com.example.kapture.cs.model;

import lombok.Data;

@Data
public class Cs {
	
	private int inquiryNo;
	private int userNo;
	private String category;
	private String question;
	private String answer;
	private String inqCreatedAt;
	private String inqUpdatedAt;
}
