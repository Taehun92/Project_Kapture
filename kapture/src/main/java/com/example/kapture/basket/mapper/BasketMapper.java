package com.example.kapture.basket.mapper;

import java.util.HashMap;
import java.sql.Date;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BasketMapper {

	// 장바구니 추가
	void insertBasket(HashMap<String, Object> map);
	
	int existsBasketItem(HashMap<String, Object> map);

	int selectCount(HashMap<String, Object> map);
	
	Date selectTourDate(HashMap<String, Object> map);
}
