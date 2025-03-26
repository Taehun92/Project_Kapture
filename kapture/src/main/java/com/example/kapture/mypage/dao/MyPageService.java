package com.example.kapture.mypage.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.mypage.mapper.MyPageMapper;
import com.example.kapture.login.model.Login;

@Service
public class MyPageService {

	@Autowired
	MyPageMapper myPageMapper;

	public HashMap<String, Object> getUserInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Login userInfo = myPageMapper.selectUser(map);
			resultMap.put("result", "success");
			resultMap.put("userInfo", userInfo);
			
		} catch (Exception e) {
      System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
