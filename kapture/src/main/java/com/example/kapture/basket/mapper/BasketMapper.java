package com.example.kapture.basket.mapper;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BasketMapper {

	// 장바구니 추가
	void insertBasket(HashMap<String, Object> map);
	
	int existsBasketItem(HashMap<String, Object> map);

	int selectCount(HashMap<String, Object> map);
	
	Date selectMinTourDate(HashMap<String, Object> map);

	List<Date> selectTourDateList(HashMap<String, Object> map);
}
