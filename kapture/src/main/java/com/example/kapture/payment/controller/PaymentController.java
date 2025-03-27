package com.example.kapture.payment.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.payment.dao.PaymentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService;
	
	@Value("${iamport.api.key}")
	private String apiKey;

	@Value("${iamport.api.secret}")
	private String apiSecret;

	
	@RequestMapping("/payment.do")
    public String payment(Model model) throws Exception{
        return "/payment/payment";
    }
	
	
	@RequestMapping(value = "/payment/complete.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> completePayment(@RequestBody Map<String, Object> payload, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        // 세션에서 로그인 사용자 번호 추출
	        String userNo = (String) session.getAttribute("USER_NO");
	        if (userNo == null) {
	            result.put("status", "fail");
	            result.put("message", "로그인이 필요합니다.");
	            return result;
	        }

	        // 필수 파라미터 체크
	        if (!payload.containsKey("impUid") || !payload.containsKey("merchantUid") ||
	            !payload.containsKey("paidAmount") || !payload.containsKey("method")) {
	            result.put("status", "fail");
	            result.put("message", "필수 정보 누락");
	            return result;
	        }

	        // 유저 번호 추가
	        payload.put("userNo", userNo);

	        // 결제 처리 서비스 호출
	        paymentService.processPayment(payload);

	        result.put("status", "success");
	    } catch (Exception e) {
	        result.put("status", "fail");
	        result.put("message", e.getMessage());
	    }

	    return result;
	}
	
	
	
}
