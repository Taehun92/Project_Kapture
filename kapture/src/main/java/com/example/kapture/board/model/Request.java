package com.example.kapture.board.model;

import lombok.Data;

@Data
public class Request {
	
	private int requestNo;
	private int userNo;
	private String title;
	private String description;
	private String region;
	private int budget;
	private String status;
	private String createdAt;
	private String updatedAt;
	private String userFirstName;
	private String userLastName;
	private String commentNo;
	private String message;
	private String parentCommentNo;
}
