package com.example.kapture.board.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.board.mapper.RequestMapper;
import com.example.kapture.board.model.Request;

@Service
public class RequestService {

	@Autowired
	RequestMapper requestMapper;

	public HashMap<String, Object> getRequestList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Request> requestList = requestMapper.selectRequestList(map);
			resultMap.put("result", "success");
			resultMap.put("requestList", requestList);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> addRequest(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int num = requestMapper.insertRequest(map);
			resultMap.put("result", "success");
			resultMap.put("num", num);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
