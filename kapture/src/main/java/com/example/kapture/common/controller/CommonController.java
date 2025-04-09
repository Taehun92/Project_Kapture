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
	
	// 하위테마 이름 가져오기
	@RequestMapping(value = "/common/getThemeList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getThemeList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getThemeList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 시 이름 No로 가져오기
	@RequestMapping(value = "/common/getSi.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSi(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getSi(map);
		return new Gson().toJson(resultMap);
	}
	
	// 구 이름 No로 가져오기
	@RequestMapping(value = "/common/getGu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getGu(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getGu(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상위테마 이름 No로 가져오기
	@RequestMapping(value = "/common/getThemeParent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getThemeParent(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getThemeParent(map);
		return new Gson().toJson(resultMap);
	}
	
	// 상위테마 이름 No로 가져오기
	@RequestMapping(value = "/common/getTheme.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getTheme(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.getTheme(map);
		return new Gson().toJson(resultMap);
	}
	
	// 날씨 정보
	@RequestMapping(value = "/common/selectSi.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectSi(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.selectSi(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/common/selectGu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectGu(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.selectGu(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/common/selectDong.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectDong(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.selectDong(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/common/selectXY.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectXY(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = commonService.selectXY(map);
		return new Gson().toJson(resultMap);
	}
	
	
	
	
	
	
	
}
