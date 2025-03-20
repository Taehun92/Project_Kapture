package com.example.kapture.board.model;

import lombok.Data;

@Data
public class Board { 
	//기본적으로 카멜 표기법, "_" 언더바가 있을 경우 언더바 생략 후 카멜표기법으로!!
	private String boardNo;
	private String title;
	private String contents;
	private String userId;
	private String kind;
	private String favorite;
	private String cnt;
	private String subtitle;
	private String deleteYn;
	private String cdateTime;
	private String udateTime;
	private String test;
	
	
}
