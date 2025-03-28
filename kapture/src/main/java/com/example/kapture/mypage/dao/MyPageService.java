package com.example.kapture.mypage.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.kapture.common.model.Reviews;
import com.example.kapture.login.model.Login;
import com.example.kapture.mypage.mapper.MyPageMapper;
import com.example.kapture.mypage.model.Payments;

@Service
public class MyPageService {

	@Autowired
	MyPageMapper myPageMapper;
	
	@Autowired
    PasswordEncoder passwordEncoder;
	// 회원정보 리스트
	public HashMap<String, Object> getUserInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Login userInfo = myPageMapper.selectUser(map);
	        boolean loginFlg = false;
	        if (userInfo != null) {
	            loginFlg = passwordEncoder.matches((String) map.get("confirmPassword"), userInfo.getPassword());
	        }
	        if (loginFlg) {
	        	resultMap.put("userInfo", userInfo);
	            resultMap.put("result", "success");        
	        } else {
	        	resultMap.put("result", "fail");
	        }
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "sqlFail");
		}
		return resultMap;
	}
	// 회원정보 수정
	public HashMap<String, Object> userInfoEdit(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
	        myPageMapper.userInfoUpdate(map);
	        resultMap.put("result", "success");
	        
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 구매내역 리스트
	public HashMap<String, Object> getPayList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
	        List<Payments> payList = myPageMapper.selectPayList(map);
	        resultMap.put("payList", payList);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
		
	}
	// 구매한 상품에 대한 유저 리뷰 리스트
	public HashMap<String, Object> getUserReviews(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
	        List<Reviews> reviewsList = myPageMapper.selectUserReviewsList(map);
	        System.out.println(reviewsList);
	        resultMap.put("reviewsList", reviewsList);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
