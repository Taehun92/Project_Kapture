package com.example.kapture.tours.model;

import lombok.Data;

@Data
public class Tours { 
	//기본적으로 카멜 표기법, "_" 언더바가 있을 경우 언더바 생략 후 카멜표기법으로!!
	private String tourNo;
	private String guideNo;
	private String title;
	private String description;
	private String duration;
	private String price;
	private String maxPeople;
	private String availableDates;
	private String createdAt;
	private String updatedAt;
	private String deleteYN;
	
}
