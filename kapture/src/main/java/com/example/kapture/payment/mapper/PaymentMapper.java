package com.example.kapture.payment.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMapper {

	void insertPayment(Map<String, Object> paymentData);

}
