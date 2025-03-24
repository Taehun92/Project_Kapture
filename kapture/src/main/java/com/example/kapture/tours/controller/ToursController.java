package com.example.kapture.tours.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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

import jakarta.servlet.http.HttpServletRequest;

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
	@RequestMapping("/tours/tour-info.do")
    public String detailTour(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/tour-info";
    }
	
	@RequestMapping("/tours/test-info.do")
    public String testDetailTour(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/test-info";
    }
	
	@RequestMapping("/tours/date-picker-test.do")
    public String testDatePicker(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/date-picker-test";
    }
	
	@RequestMapping("/tours/regionalTours.do")
    public String regionalTours(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/regional-tours";
    }
	@RequestMapping("/tours/test-regional.do")
    public String testRegional(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/tours/test-regional";
    }
	
//---------------------------------------------------------dox---------------------------------------------------------------------------
		
	// 상품 목록 조회
	@RequestMapping(value = "/tours/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toursList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		if(map.get("selectedDates") != null) { // 선택된 테마 리스트가 널이 아니면 맵에 추가
			
			String json = map.get("selectedDates").toString(); 
			ObjectMapper mapper = new ObjectMapper();
			List<Object> selectedDates = mapper.readValue(json, new TypeReference<List<Object>>(){});
			List<String> formattedDates = new ArrayList<>();

			for (Object date : selectedDates) {
			    String dateStr = date.toString().substring(0, 10); // "2025-03-25T06:39:00.000Z" → "2025-03-25"
			    formattedDates.add(dateStr);
			}
			
			map.put("selectedDates", formattedDates);
			}
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
	
	// 상품 상세페이지
	@RequestMapping(value = "/tours/tour-info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String tourInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = toursService.getTourInfo(map);
		
		return new Gson().toJson(resultMap); //받는 타입을 json으로 정의해서 json 형태로 변환
	}
	
	
}
