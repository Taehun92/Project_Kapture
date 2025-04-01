package com.example.kapture.payment.dao;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
	        List<Map<String, Object>> selectedItems = (List<Map<String, Object>>) map.get("selectedItems");

	        int totalInserted = 0;
	        for (Map<String, Object> item : selectedItems) {
	            // 👇 안전하게 문자열 변환 후 파싱
	            Integer basketNo = Integer.parseInt(item.get("basketNo").toString());
	            Integer numPeople = Integer.parseInt(item.get("numPeople").toString());

	            Basket basket = basketMapper.selectBasketByNo(basketNo);

	            HashMap<String, Object> paymentData = new HashMap<>();
	            paymentData.put("userNo", map.get("userNo"));
	            paymentData.put("amount", map.get("amount"));
	            paymentData.put("method", map.get("method"));
	            paymentData.put("merchantId", map.get("merchantId"));
	            paymentData.put("tourNo", basket.getTourNo());
	            paymentData.put("numPeople", numPeople);
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
	
	public HashMap<String, Object> getPaymentList(String merchantId) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		List<Payment> list = paymentMapper.selectPayment(merchantId);
		resultMap.put("result", "success");
		resultMap.put("paymentList", list);
	    return resultMap;
	}
	
	
	public void processPaymentSuccess(List<Payment> paymentList) {
	    if (paymentList == null || paymentList.isEmpty()) return;
	    // 1. TOUR 예약 완료 처리
	    for (Payment p : paymentList) {
	    	System.out.println("✅ paymentList 항목: " + p);
	        System.out.println("🧾 basketNo: " + p.getBasketNo());
	        paymentMapper.updateTourDeleteYn(p.getTourNo());
	    }

	    // 2. 장바구니 삭제 (basketNo 리스트 추출 후 삭제)
	    List<Integer> basketNoList = paymentList.stream().map(Payment::getBasketNo).filter(Objects::nonNull).distinct().collect(Collectors.toList());
	    System.out.println("🗑 삭제할 basketNo 목록: " + basketNoList);
	    if (!basketNoList.isEmpty()) {
	        paymentMapper.deleteBasketsByNo(basketNoList);
	    }
	    
	}

	public HashMap<String, Object> removeBasket(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<>();
		int num = paymentMapper.deleteBasket(map);
		resultMap.put("result", "success");
		resultMap.put("num", num);
	    return resultMap;
	}

	

}

