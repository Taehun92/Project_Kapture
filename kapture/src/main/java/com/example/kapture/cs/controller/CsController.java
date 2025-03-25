package com.example.kapture.cs.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.cs.dao.CsService;
import com.google.gson.Gson;

@Controller
public class CsController {

	@Autowired
	CsService csService;
	
	@RequestMapping("/cs/faq.do")
    public String login(Model model) throws Exception{
        return "cs/faq";
    }
	@RequestMapping("/cs/notice.do")
    public String notice(Model model) throws Exception{
        return "cs/notice";
    }
	@RequestMapping("/cs/qna.do")
    public String qna(Model model) throws Exception{
        return "cs/qna";
    }
	
	
	// 게시글 목록
		@RequestMapping(value = "/cs/main.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String csMain(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = csService.csMain(map);
			return new Gson().toJson(resultMap);
		}
		
		// 공지사항
		@RequestMapping(value = "/cs/notice.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String notice(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
					
			resultMap = csService.csNotice(map);
			return new Gson().toJson(resultMap);
				}
		
}
