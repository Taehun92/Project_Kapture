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
			if(Boolean.parseBoolean((String) map.get("unregisterFlg"))) {
				resultMap.put("userInfo", userInfo);
	            resultMap.put("result", "success");
			}
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
	// 리뷰 등록 or 수정
	public HashMap<String, Object> reviewSave(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println("editFlg : " + Boolean.parseBoolean((String) map.get("editFlg")));
			boolean editFlg = Boolean.parseBoolean((String) map.get("editFlg"));
			if(!editFlg) {
				System.out.println("리뷰등록 맵: " + map);
	        	int result = myPageMapper.insertUserReview(map);
	        	resultMap.put("result", result > 0 ? "success" : "fail");
			}
			if(editFlg) {
				System.out.println("리뷰수정 맵: " + map);
				int result = myPageMapper.updateUserReview(map);
	        	resultMap.put("result", result > 0 ? "success" : "fail");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
	// 리뷰 삭제
	public HashMap<String, Object> userReviewRemove(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println("리뷰삭제 맵: " + map);
			int result = myPageMapper.deleteUserReview(map);
	        resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
	// 회원 탈퇴
	public HashMap<String, Object> userUnregister(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = myPageMapper.deleteUser(map);
	        resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------  
	public HashMap<String, Object> addTour(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		myPageMapper.insertTour(map);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	
	
	
}
