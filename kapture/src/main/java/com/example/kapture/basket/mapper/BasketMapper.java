package com.example.kapture.basket.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BasketMapper {

	// 장바구니 추가
	void insertBasket(HashMap<String, Object> map);

}
