package com.example.kapture.payment.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

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
	
	// 결제 데이터 저장
	public HashMap<String, Object> savePayment(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        List<String> selectedIdStrList = (List<String>) map.get("selectedIds");

	        // 문자열 리스트를 숫자로 변환
	        List<Integer> selectedIds = selectedIdStrList.stream()
	                .map(Integer::parseInt)
	                .collect(Collectors.toList());

	        int totalInserted = 0;
	        for (Integer basketNo : selectedIds) {
	            HashMap<String, Object> paymentData = new HashMap<>();
	            paymentData.put("userNo", map.get("userNo"));
	            paymentData.put("amount", map.get("amount"));
	            paymentData.put("method", map.get("method"));
	            paymentData.put("merchantId", map.get("merchantId"));
	            paymentData.put("basketNo", basketNo);
	            int inserted = paymentMapper.insertPayment(paymentData);
	            totalInserted += inserted;
	        }
	        resultMap.put("result", "success");
	        resultMap.put("inserted", totalInserted);
	    } catch (Exception e) { 
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	

	public void processPaymentSuccess(List<Payment> paymentList) {
	    if (paymentList == null || paymentList.isEmpty()) return;

	    // 1. TOUR 예약 완료 처리
	    for (Payment p : paymentList) {
	        paymentMapper.updateTourDeleteYn(p.getTourNo());
	    }

	    // 2. 장바구니 삭제 (basketNo 리스트 추출 후 삭제)
	    List<String> basketNoList = paymentList.stream().map(Payment::getBasketNo).filter(Objects::nonNull).distinct().collect(Collectors.toList());
	    if (!basketNoList.isEmpty()) {
	    	System.out.println("삭제할 장바구니 번호 목록: " + basketNoList);
	        paymentMapper.deleteBasketsByNo(basketNoList);
	    }
	}

	public List<Payment> getPaymentList(String merchantId) {
		// TODO Auto-generated method stub
		return paymentMapper.selectPayment(merchantId);
	}

}

