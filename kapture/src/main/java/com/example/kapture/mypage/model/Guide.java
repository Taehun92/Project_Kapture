package com.example.kapture.mypage.model;

import lombok.Data;

@Data
public class Guide {
	private int guideNo;
	private int userNo;
	private int tourNo;
	private String title;
	private String duration;
	private int maxPeople;
	private String tourDate;
	private int themeNo;
	private String deleteyn;
	private String userFirstName;
	private String userLastName;
	private String email;
	private String password;
	private String phone;
	
	
	private String language;
	private String experience;
	private String profileImage;
	private String gCreatedAt;
	private String gUpdatedAt;
	
	
}
