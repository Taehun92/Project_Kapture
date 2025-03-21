package com.example.kapture.board.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.board.dao.RequestService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class RequestController {

	@Autowired
	RequestService requestService;
	
	@RequestMapping("/request/list.do") 
	public String list(Model model) throws Exception{
    return "/board/request-list";
	}
	
	@RequestMapping("/request/add.do") 
	public String add(Model model) throws Exception{
    return "/board/request-add";
	}
	
	
	// 게시글 목록 조회
	@RequestMapping(value = "/request/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String requestList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = requestService.getRequestList(map);
		return new Gson().toJson(resultMap);
	}
	
	// 게시글 작성
	@RequestMapping(value = "/request/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String requestAdd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = requestService.addRequest(map);
		return new Gson().toJson(resultMap);
	}
	
	
}
