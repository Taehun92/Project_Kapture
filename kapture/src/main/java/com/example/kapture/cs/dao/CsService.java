package com.example.kapture.cs.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.cs.mapper.CsMapper;
import com.example.kapture.cs.model.Cs;

@Service
public class CsService {

	@Autowired
	CsMapper csMapper;

	public HashMap<String, Object> csFaq(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cs> list = csMapper.faqCs(map);
			
			int count = csMapper.faqCsCnt(map);

			resultMap.put("count", count);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
}

	public HashMap<String, Object> csNotice(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Cs> list = csMapper.csNotice(map);
			
			int count = csMapper.noticeCsCnt(map);

			resultMap.put("count", count);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> qnaAdd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		csMapper.insertQna(map);
		resultMap.put("result", "success");
		return resultMap;
	}

	
	public HashMap<String, Object> searchAll(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        List<HashMap<String, Object>> faqList = csMapper.searchFaq(map);
        List<HashMap<String, Object>> qnaList = csMapper.searchQna(map);
        
        result.put("faqList", faqList);
        result.put("qnaList", qnaList);
        return result;
    }

	public HashMap<String, Object> savePartnership(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int num = csMapper.insertPartnership(map);
			resultMap.put("num", num);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}