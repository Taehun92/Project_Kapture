package com.example.kapture.tours.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.tours.model.Tours;

@Mapper
public interface ToursMapper {

	List<Tours> selectToursList(HashMap<String, Object> map);

	

}
