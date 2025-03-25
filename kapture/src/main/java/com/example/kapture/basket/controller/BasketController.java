package com.example.kapture.basket.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.basket.dao.BasketService;
import com.google.gson.Gson;

@Controller
public class BasketController {
	
	@Autowired
	BasketService basketService;
	
	// 장바구니 추가
	@RequestMapping(value = "/basket/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = basketService.addBasket(map);
		return new Gson().toJson(resultMap);
	}
	
	// 장바구니 담은 갯수 구하기
	@RequestMapping(value = "/basket/getCount.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCount(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = basketService.getCount(map);
		return new Gson().toJson(resultMap);
	}
	
	

}
