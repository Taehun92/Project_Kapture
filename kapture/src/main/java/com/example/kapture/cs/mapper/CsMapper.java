package com.example.kapture.cs.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.cs.model.Cs;

@Mapper
public interface CsMapper {

	List<Cs> faqCs(HashMap<String, Object> map);

	int faqCsCnt(HashMap<String, Object> map);

	List<Cs> csNotice(HashMap<String, Object> map);

	int noticeCsCnt(HashMap<String, Object> map);

	void insertQna(HashMap<String, Object> map);

	List<HashMap<String, Object>> searchFaq(HashMap<String, Object> map);

	List<HashMap<String, Object>> searchQna(HashMap<String, Object> map);

	int insertPartnership(HashMap<String, Object> map);
}
