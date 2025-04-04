package com.example.kapture.admin.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

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


		List<Guide> selectguidesList(HashMap<String, Object> map);


		int updateGuideInfo(HashMap<String, Object> map);


		int updateUserInfo(HashMap<String, Object> map);


		List<HashMap<String, Object>> selectTransactionList(HashMap<String, Object> map);


		int selectTransactionTotalCount(HashMap<String, Object> map);


		List<String> getRegionList();


		int insertGuideProfile(HashMap<String, Object> map);


		List<HashMap<String, Object>> selectAllReviews();


		


		
}
