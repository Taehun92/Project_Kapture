package com.example.kapture.tours.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.tours.dao.ToursService;
import com.google.gson.Gson;

@Controller
public class ToursController {
	
	@Autowired
	ToursService toursService;

	@RequestMapping("/tours/list.do")
    public String toursList(Model model) throws Exception{
        return "/tours/tours-list";
    }
	@RequestMapping("/tours/test.do")
    public String test(Model model) throws Exception{
        return "/tours/test";
    }
	
	
//	@RequestMapping("/board/view.do")
//    public String view(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
//		System.out.println(map);
//		request.setAttribute("map", map);
//        return "/board/board-view";
//    }
	
	// 게시글 목록 조회
	@RequestMapping(value = "/tours/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toursList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = toursService.getToursList(map);
		return new Gson().toJson(resultMap);
	}
	
	
}
