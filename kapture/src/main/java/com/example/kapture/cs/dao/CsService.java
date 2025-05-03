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
		Object inquiryNo = map.get("inquiryNo");  // 시퀀스로 생성된 값이 자동으로 들어옴
		resultMap.put("result", "success");
		resultMap.put("inquiryNo", inquiryNo);    // 알림 등록 시 참조용으로 사용 가능
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
//	// 문의시 알림 정보 저장
//	public void registerAdminQnaAlarm(HashMap<String, Object> map) {
//	    List<HashMap<String, Object>> adminList = csMapper.selectAdminUserList();
//	    for (HashMap<String, Object> admin : adminList) {
//	        HashMap<String, Object> alarmMap = new HashMap<>();
//	        alarmMap.put("targetUserNo", admin.get("USER_NO"));
//	        alarmMap.put("referenceType", "QNA");
//	        alarmMap.put("referenceId", inquiryNo);
//	        alarmMap.put("urlParam", null);
//	        csMapper.insertQnaAlarm(alarmMap);
//	    }
//	}
//	public void registerAdminQnaAlarm(HashMap<String, Object> map) {
//	    Object inquiryNo = map.get("referenceId"); // 또는 map.get("inquiryNo") 사용 가능
//
//	    if (inquiryNo == null) {
//	        System.out.println("🚨 referenceId(inquiryNo) 가 null 입니다. 알림 저장 취소");
//	        return;
//	    }
//
//	    List<HashMap<String, Object>> adminList = csMapper.selectAdminUserList();
//	    for (HashMap<String, Object> admin : adminList) {
//	        HashMap<String, Object> alarmMap = new HashMap<>();
//	        alarmMap.put("targetUserNo", admin.get("USER_NO"));
//	        alarmMap.put("referenceType", map.get("referenceType")); // "QNA"
//	        alarmMap.put("referenceId", inquiryNo);
//	        alarmMap.put("urlParam", map.get("urlParam")); // 보통 inquiryNo 또는 null
//	        csMapper.insertQnaAlarm(alarmMap);
//	    }
//	}
}