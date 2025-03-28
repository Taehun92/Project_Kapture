package com.example.kapture.common.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.common.dao.CommonService;
import com.google.gson.Gson;

@Controller
public class CommonController {

	@Autowired
	CommonService commonService;
		
	// 시 이름 가져오기
	@RequestMapping(value = "/common/getSiList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSiList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getSiList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 구 이름 가져오기
	@RequestMapping(value = "/common/getGuList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getGuList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getGuList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상위테마 이름 가져오기
	@RequestMapping(value = "/common/getThemeParentList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getThemeParentList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getThemeParentList(map);
		return new Gson().toJson(resultMap);
	}
}
