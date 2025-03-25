package com.example.kapture.cs.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.cs.model.Cs;

@Mapper
public interface CsMapper {

	List<Cs> mainCs(HashMap<String, Object> map);

	int mainCsCnt(HashMap<String, Object> map);

	List<Cs> csNotice(HashMap<String, Object> map);

	int noticeCsCnt(HashMap<String, Object> map);

}
