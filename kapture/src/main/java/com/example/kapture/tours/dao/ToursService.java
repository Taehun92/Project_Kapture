package com.example.kapture.tours.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.tours.mapper.ToursMapper;
import com.example.kapture.tours.model.Tours;

@Service
public class ToursService {
	
	@Autowired
	ToursMapper toursMapper;

	public HashMap<String, Object> getToursList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Tours> toursList = toursMapper.selectToursList(map);
			resultMap.put("result", "success");
			resultMap.put("toursList", toursList);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}

// get, select
// add, insert
// edit, update
// remove, delete