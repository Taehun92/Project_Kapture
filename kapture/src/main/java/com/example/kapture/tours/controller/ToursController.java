package com.example.kapture.tours.controller;

import java.util.HashMap;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.tours.dao.ToursService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class ToursController {
	
	@Autowired
	ToursService toursService;
	
	// 상품 페이지 dept(1) 주소
	@RequestMapping("/tours/list.do")
    public String toursList(Model model) throws Exception{
        return "/tours/tours-list";
    }
	
	@RequestMapping("/tours/test-list.do")
    public String testList(Model model) throws Exception{
        return "/tours/test-list";
    }
	// 상품 상세페이지 주소
	@RequestMapping("/tours/detailTour.do")
    public String detailTour(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/detailTour";
    }
	
	@RequestMapping("/tours/test-detailTour.do")
    public String testDetailTour(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/test-detailTour";
    }
	
	
//---------------------------------------------------------dox---------------------------------------------------------------------------
		
	// 상품 목록 조회
	@RequestMapping(value = "/tours/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toursList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		if(map.get("selectedThemes") != null) { // 선택된 테마 리스트가 널이 아니면 맵에 추가
		String json = map.get("selectedThemes").toString(); 
		ObjectMapper mapper = new ObjectMapper();
		List<Object> selectedThemes = mapper.readValue(json, new TypeReference<List<Object>>(){});
		map.put("selectedThemes", selectedThemes);
		}
		if(map.get("selectedLanguages") != null) { // 선택된 가이드언어 리스트가 널이 아니면 맵에 추가
			String json = map.get("selectedLanguages").toString(); 
			ObjectMapper mapper = new ObjectMapper();
			List<Object> selectedLanguages = mapper.readValue(json, new TypeReference<List<Object>>(){});
			map.put("selectedLanguages", selectedLanguages);
		}
		if(map.get("selectedRegions") != null) { // 선택된 지역 리스트가 널이 아니면 맵에 추가
			String json = map.get("selectedRegions").toString(); 
			ObjectMapper mapper = new ObjectMapper();
			List<Object> selectedRegions = mapper.readValue(json, new TypeReference<List<Object>>(){});
			map.put("selectedRegions", selectedRegions);
		}
		System.out.println(map);
		resultMap = toursService.getToursList(map);
		return new Gson().toJson(resultMap);
	}
	
	
}
