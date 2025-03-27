package com.example.kapture.payment.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.basket.mapper.BasketMapper;
import com.example.kapture.payment.mapper.PaymentMapper;
import com.example.kapture.tours.mapper.ToursMapper;

@Service
public class PaymentService {
	
	@Autowired
	PaymentMapper paymentMapper;
	
	@Autowired
    BasketMapper basketMapper;

    @Autowired
    ToursMapper toursMapper;

    public void completePayment(Map<String, Object> data) {
        List<Map<String, Object>> items = (List<Map<String, Object>>) data.get("items");
        int userNo = (int) data.get("userNo");
        String method = (String) data.get("method");

        for (Map<String, Object> item : items) {
            int tourNo = (int) item.get("tourNo");
            int amount = (int) item.get("amount");

            Map<String, Object> paymentData = new HashMap<>();
            paymentData.put("userNo", userNo);
            paymentData.put("tourNo", tourNo);
            paymentData.put("amount", amount);
            paymentData.put("paymentStatus", "PAID");
            paymentData.put("method", method);

            // 결제 정보 저장
            paymentMapper.insertPayment(paymentData);

            // 해당 투어 예약 완료 처리
            toursMapper.updateDeleteYn(tourNo, "Y");

            // 장바구니 삭제
            basketMapper.deleteBasketItem(userNo, tourNo);
        }
    } 

	public void processPayment(Map<String, Object> payload) {
		// TODO Auto-generated method stub
		
	}
}

