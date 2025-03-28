package com.example.kapture.common.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Theme;
import com.example.kapture.common.model.Reviews;

@Mapper
public interface CommonMapper {
	
	List<Region> selectRegionList(HashMap<String, Object> map);
	
	List<Theme> selectThemeList(HashMap<String, Object> map);
	
	List<Reviews> selectReviewsList(HashMap<String, Object> map);
	
	List<Region> selectSiNameList(HashMap<String, Object> map);
	
	List<Region> selectGuNameList(HashMap<String, Object> map);

	List<Theme> selectThemeParentList(HashMap<String, Object> map);

	List<Theme> selectThemeNameList(HashMap<String, Object> map);
}
