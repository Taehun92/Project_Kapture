package com.example.kapture.admin.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.cs.model.Cs;
import com.example.kapture.login.model.Login;
import com.example.kapture.mypage.model.Guide;

@Mapper
public interface AdminMapper {
	
	  Map<String, Object> monthChart();
	  
	  	// 📅 월별 매출 (12개월 컬럼으로 한 줄 반환)
	    Map<String, Object> getMonthChartByYear(HashMap<String, Object> map);

	    // 지역 + 테마별 매출 
	    List<Map<String, Object>> getThemeSalesByRegion(HashMap<String, Object> map);
	    
	    // 3. 📆 일별 매출 (선택한 연도와 월 기준)
	    List<Map<String, Object>> getDayChartByYearMonth(Map<String, Object> map);	   
	    
	    int selectTotalAmount();         // 총 거래 금액
	    int selectYesterdayAmount();     // 어제 거래 금액
	    int selectTotalUsers();          // 총 이용 인원
	    int selectApprovedCount();       // 승인 건수
	    int selectRejectedCount();       // 취소 건수
	    // 가이드관리 정보 조회
		List<Guide> selectguidesList(HashMap<String, Object> map);
		// 가이드관리 가이드정보 수정
		int updateGuideInfo(HashMap<String, Object> map);
		// 가이드관리 유저정보 수정
		int updateUserInfo(HashMap<String, Object> map);

		List<HashMap<String, Object>> selectTransactionList(HashMap<String, Object> map);

		int selectTransactionTotalCount(HashMap<String, Object> map);
		
		List<String> getRegionList();
		// 가이드관리 프로필 이미지 저장
		int insertGuideProfile(HashMap<String, Object> map);
		// 회원관리 회원정보 조회
		List<Login> selectUsersList(HashMap<String, Object> map);
		// 회원관리 회원정보 수정
		int updateUser(HashMap<String, Object> map);
		// 회원관리 회원 탈퇴 처리(삭제)
		int deleteUser(HashMap<String, Object> map);
		// 역할 수정시 가이드 생성
		int insertGuide(HashMap<String, Object> map);
		// 가이드관리 삭제,역할 수정시 가이드 삭제
		int deleteGuide(HashMap<String, Object> map);
		// 고객 문의 리스트 조회
		List<Cs> selectInquiriesList(HashMap<String, Object> map);
		// 고객 문의 답변 저장
		int updateInquiryAnswer(HashMap<String, Object> map);
		// 고객 문의 삭제
		int deleteInquiry(HashMap<String, Object> map);
		// 환불 처리
		int updateRefunded(HashMap<String, Object> map);




		


		
}
