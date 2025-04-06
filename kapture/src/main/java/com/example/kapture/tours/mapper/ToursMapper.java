package com.example.kapture.tours.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.tours.model.Tours;
import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Theme;

@Mapper
public interface ToursMapper {

	List<Tours> selectToursList(HashMap<String, Object> map);

	List<Tours> selectAll(HashMap<String, Object> map);
  
	Tours selectTourInfo(HashMap<String, Object> map);

	void updateDeleteYn(int tourNo, String string);

	void insertToursFile(HashMap<String, Object> map);

	
	

}