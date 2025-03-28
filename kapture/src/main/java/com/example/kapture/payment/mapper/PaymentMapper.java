package com.example.kapture.payment.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.payment.model.Payment;

@Mapper
public interface PaymentMapper {

	List<Payment> selectBasketInfoList(HashMap<String, Object> map);

}
