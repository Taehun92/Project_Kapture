package com.example.kapture.admin.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.admin.mapper.AdminMapper;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

	public HashMap<String, Object> getTourList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		
		return resultMap;
	}

}
