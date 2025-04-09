package com.example.kapture.payment.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.kapture.payment.model.Payment;

@Mapper
public interface PaymentMapper {

	List<Payment> selectPaymentList(HashMap<String, Object> map);

	int insertPayment(HashMap<String, Object> map);
	
	List<Payment> selectPaymentDetails(int paymentNo);

	void updateTourDeleteYn(int tourNo);
	
	List<Payment> selectPayment(String merchantId);
	
	void deleteBasketsByNo(@Param("basketNoList") List<Integer> basketNoList);

	int deleteBasket(HashMap<String, Object> map);

	void updateRequestMessage(Map<String, Object> request);

}
