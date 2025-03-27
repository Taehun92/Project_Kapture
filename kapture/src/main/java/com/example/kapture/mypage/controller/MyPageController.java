package com.example.kapture.mypage.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.mypage.dao.MyPageService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MyPageController {

		@Autowired
		MyPageService myPageService;
		// 유저 마이페이지 주소
		@RequestMapping("/mypage/user-mypage.do")
		public String testRegional(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
			request.setAttribute("map", map);
			return "/mypage/user-mypage";
		}
		
//---------------------------------------------------------dox---------------------------------------------------------------------------
		// 유저 정보 가져오기
		@RequestMapping(value = "/mypage/user-info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String getUserInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = myPageService.getUserInfo(map);
			return new Gson().toJson(resultMap);
		}
		// 정보수정
		@RequestMapping(value = "/mypage/info-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String userInfoEdit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = myPageService.userInfoEdit(map);
			return new Gson().toJson(resultMap);
		}
}
