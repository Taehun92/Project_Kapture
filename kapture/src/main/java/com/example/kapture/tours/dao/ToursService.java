package com.example.kapture.tours.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.common.mapper.CommonMapper;
import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Theme;
import com.example.kapture.tours.mapper.ToursMapper;
import com.example.kapture.tours.model.Tours;

@Service
public class ToursService {
	// get, select
	// add, insert
	// edit, update
	// remove, delete
	
	@Autowired
	ToursMapper toursMapper;
	
	@Autowired
	CommonMapper commonMapper;

	public HashMap<String, Object> getToursList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Tours> toursList = toursMapper.selectToursList(map);
			List<Region> regionList = commonMapper.selectRegionList(map);
			List<Theme> themeList = commonMapper.selectThemeList(map);
			resultMap.put("result", "success");
			resultMap.put("toursList", toursList);
			resultMap.put("regionList", regionList);
			resultMap.put("themeList", themeList);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}

