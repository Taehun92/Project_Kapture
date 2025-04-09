package com.example.kapture.common.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.common.model.Common;
import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Reviews;
import com.example.kapture.common.model.Theme;

@Mapper
public interface CommonMapper {
	
	List<Region> selectRegionList(HashMap<String, Object> map);
	
	List<Theme> selectThemeList(HashMap<String, Object> map);
	
	List<Reviews> selectReviewsList(HashMap<String, Object> map);
	
	List<Region> selectSiNameList(HashMap<String, Object> map);
	
	List<Region> selectGuNameList(HashMap<String, Object> map);

	List<Theme> selectThemeParentList(HashMap<String, Object> map);

	List<Theme> selectThemeNameList(HashMap<String, Object> map);
	
	Region selectSiName(HashMap<String, Object> map);
	
	Region selectGuName(HashMap<String, Object> map);
	
	Theme selectThemeParent(HashMap<String, Object> map);
	
	Theme selectThemeName(HashMap<String, Object> map);
	
	// 날씨 정보 가져오기
	List<Common> selectSi(HashMap<String, Object> map);
	
	List<Common> selectGu(HashMap<String, Object> map);
	
	List<Common> selectDong(HashMap<String, Object> map);
	
	Common selectXY(HashMap<String, Object> map);
}
