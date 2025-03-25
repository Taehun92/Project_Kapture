package com.example.kapture.cs.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.cs.mapper.CsMapper;
import com.example.kapture.cs.model.Cs;

@Service
public class CsService {

	@Autowired
	CsMapper csMapper;

	public HashMap<String, Object> csMain(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cs> list = csMapper.mainCs(map);
			
			int count = csMapper.mainCsCnt(map);

			resultMap.put("count", count);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
}

	public HashMap<String, Object> csNotice(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cs> list = csMapper.csNotice(map);
			
			int count = csMapper.noticeCsCnt(map);

			resultMap.put("count", count);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
}
}