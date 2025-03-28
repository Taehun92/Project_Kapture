package com.example.kapture.common.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.common.mapper.CommonMapper;
import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Theme;

@Service
public class CommonService {

	@Autowired
	CommonMapper commonMapper;

	public HashMap<String, Object> getSiList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		List<Region> siList = commonMapper.selectSiNameList(map);
		
		resultMap.put("siList", siList);
		resultMap.put("result", "success");
		
		return resultMap;
	}

	public HashMap<String, Object> getGuList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		List<Region> guList = commonMapper.selectGuNameList(map);
		
		resultMap.put("guList", guList);
		resultMap.put("result", "success");
		
		return resultMap;
	}

	public HashMap<String, Object> getThemeParentList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		
		List<Theme> themeParentList = commonMapper.selectThemeParentList(map);
		
		resultMap.put("themeParentList", themeParentList);
		resultMap.put("result", "success");
		
		return resultMap;
	}

	public HashMap<String, Object> getThemeList(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		List<Theme> themeNameList = commonMapper.selectThemeNameList(map);
		
		resultMap.put("themeNameList", themeNameList);
		resultMap.put("result", "success");
		
		return resultMap;
		
	}
	
	
	
}
