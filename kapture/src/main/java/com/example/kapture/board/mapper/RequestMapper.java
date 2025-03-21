package com.example.kapture.board.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.board.model.Request;

@Mapper
public interface RequestMapper {

	List<Request> selectRequestList(HashMap<String, Object> map);

	int insertRequest(HashMap<String, Object> map);

}
