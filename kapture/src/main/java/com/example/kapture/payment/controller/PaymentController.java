package com.example.kapture.payment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.kapture.payment.dao.PaymentService;
import com.example.kapture.payment.model.Payment;
import com.google.gson.Gson;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService;
	
	@Value("${iamport.api.key}")
	private String apiKey;

	@Value("${iamport.api.secret}")
	private String apiSecret;
	
	@Value("${exchange.api.key}")
	private String exchangeApiKey;
	
	@Autowired
	private Environment env;

	
	@RequestMapping("/payment.do")
    public String payment(Model model) throws Exception{
        return "/payment/payment";
    }
	
	@RequestMapping("/payment/success.do")
	public String showPaymentSuccess(@RequestParam("merchantId") String merchantId, Model model) {
	    // 1. 결제 정보 조회 (여러 건일 수 있으므로 List 사용)
	    List<Payment> paymentList = paymentService.getPaymentList(merchantId);
	    // 2. 결제된 상품 예약 상태 처리 + 장바구니 삭제 처리
	    paymentService.processPaymentSuccess(paymentList);
	    // 3. 화면에 결제 정보 전달
	    model.addAttribute("paymentList", paymentList);
	    return "/payment/success"; 
	}
	
	// 결제 목록 조회
	@RequestMapping(value = "/payment/getBasketInfoList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String basketInfoList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getBasketInfoList(map);
		return new Gson().toJson(resultMap);
	}
	
	
	// 결제 정보 저장
	@RequestMapping(value = "/payment/save.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String savePayment(@RequestBody HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = paymentService.savePayment(map);
	    return new Gson().toJson(resultMap);
	}
	
	
	
	// 환율 계산 API
	@RequestMapping("/exchangeRate/USD")
	@ResponseBody
    public Map<String, Object> getUsdExchangeRate() throws Exception {
        String apiKey = env.getProperty("exchange.api.key"); // application.properties에 저장한 키
        String urlStr = "https://v6.exchangerate-api.com/v6/" + apiKey + "/pair/USD/KRW";

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(urlStr, String.class);

        JSONObject json = new JSONObject(response.getBody());
        double rate = json.getDouble("conversion_rate");

        Map<String, Object> result = new HashMap<>();
        result.put("rate", rate);
        return result;
    }
}
