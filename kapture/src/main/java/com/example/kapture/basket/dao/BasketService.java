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
		
		HashMap<String, Object> resultMap = new HashMap<>();
	    
	    // 중복 체크
	    int count = basketMapper.existsBasketItem(map);
	    
	    if (count > 0) {
	        // 이미 존재하면 중복 알림 처리
	        resultMap.put("result", "duplicate");
	    } else {
	        // 존재하지 않으면 삽입 진행
	        basketMapper.insertBasket(map);
	        resultMap.put("result", "success");
	    }
		return resultMap;
	}


	public HashMap<String, Object> getCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		int count = basketMapper.selectCount(map);
		
		resultMap.put("count", count);
		
		resultMap.put("result", "success");
		
		return resultMap;
	}

}
