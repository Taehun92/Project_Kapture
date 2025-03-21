package com.example.kapture.common.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.common.model.Region;
import com.example.kapture.common.model.Theme;

@Mapper
public interface CommonMapper {
	
	List<Region> selectRegionList(HashMap<String, Object> map);
	
	List<Theme> selectThemeList(HashMap<String, Object> map);
}
