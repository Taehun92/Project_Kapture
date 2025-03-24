package com.example.kapture.admin.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.kapture.admin.dao.AdminService;
import com.google.gson.Gson;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	// 관리자 페이지 메인
	@RequestMapping("/admin.do")
    public String main(Model model) throws Exception{
        return "/admin/admin";
    }
	
	// 상품 관리
	@RequestMapping("/admin/tours.do")
	public String tour(Model model) throws Exception{
		return "/admin/admin-tours";
	}
	
	// 가이드 관리
	@RequestMapping("/admin/guide.do")
	public String guide(Model model) throws Exception{
		return "/admin/admin-guide";
	}
	
	// 주문 및 예약 관리
	@RequestMapping("/admin/order.do")
	public String order(Model model) throws Exception{
		return "/admin/admin-order";
	}
	
	// 결제 및 수익 관리
	@RequestMapping("/admin/pay.do")
	public String pay(Model model) throws Exception{
		return "/admin/admin-pay";
	}
	
	// 고객 관리 
	@RequestMapping("/admin/customer.do")
	public String customer(Model model) throws Exception{
		return "/admin/admin-customer";
	}
	
	// 마케팅 및 프로모션 관리
	@RequestMapping("/admin/promotion.do")
	public String promotion(Model model) throws Exception{
		return "/admin/admin-promotion";
	}
	
	// 운영 및 설정 관리
	@RequestMapping("/admin/setting.do")
	public String setting(Model model) throws Exception{
		return "/admin/admin-setting";
	}
	
}
