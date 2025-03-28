package com.example.kapture.payment.dao;


import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.payment.mapper.PaymentMapper;
import com.example.kapture.payment.model.Payment;


@Service
public class PaymentService {
	
	@Autowired
	PaymentMapper paymentMapper;

	public HashMap<String, Object> savePayment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Payment> requestList = paymentMapper.selectBasketInfoList(map);
			resultMap.put("result", "success");
			resultMap.put("requestList", requestList);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}

