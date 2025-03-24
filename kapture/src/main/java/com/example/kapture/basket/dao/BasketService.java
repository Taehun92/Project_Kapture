package com.example.kapture.basket.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.basket.mapper.BasketMapper;

@Service
public class BasketService {
	
	@Autowired
	BasketMapper basketMapper;

	
	// 장바구니 추가
	public HashMap<String, Object> addBasket(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		basketMapper.insertBasket(map);
		
		return resultMap;
	}

}
