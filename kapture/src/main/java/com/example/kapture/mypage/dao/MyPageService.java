package com.example.kapture.mypage.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.kapture.login.model.Login;
import com.example.kapture.mypage.mapper.MyPageMapper;

@Service
public class MyPageService {

	@Autowired
	MyPageMapper myPageMapper;
	
	@Autowired
    PasswordEncoder passwordEncoder;

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
}
