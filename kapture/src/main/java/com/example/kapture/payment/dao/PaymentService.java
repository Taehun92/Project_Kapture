package com.example.kapture.payment.dao;


import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.basket.mapper.BasketMapper;
import com.example.kapture.basket.model.Basket;
import com.example.kapture.payment.mapper.PaymentMapper;
import com.example.kapture.payment.model.Payment;


@Service
public class PaymentService {
	
	@Autowired
	PaymentMapper paymentMapper;
	
	@Autowired
	BasketMapper basketMapper;

	//결제 목록 조회
	public HashMap<String, Object> getBasketInfoList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Basket> basketList = basketMapper.selectBasketList(map);
//			List<Payment> paymentList = paymentMapper.selectPaymentList(map);
			resultMap.put("result", "success");
			resultMap.put("basketList", basketList);
//			resultMap.put("paymentList", paymentList);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	// 결제 정보 저장
	public HashMap<String, Object> savePayment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int num = paymentMapper.insertPayment(map);
			resultMap.put("result", "success");
			resultMap.put("num", num);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	
}

