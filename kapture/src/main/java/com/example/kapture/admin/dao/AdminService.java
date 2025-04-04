package com.example.kapture.admin.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.kapture.admin.mapper.AdminMapper;
import com.example.kapture.mypage.model.Guide;

@Service
public class AdminService {

    @Autowired
    AdminMapper adminMapper;
    
    @Autowired
    PasswordEncoder passwordEncoder;

    public HashMap<String, Object> getChartByTypeAndYear(HashMap<String, Object> map) {
        String type = (String) map.get("type");
        String year = (String) map.get("year");

        if (type == null || year == null) {
            throw new RuntimeException("type 또는 year 누락됨");
        }

        HashMap<String, Object> result = new HashMap<>();

        // 📅 월별 매출
        if ("month".equals(type)) {
            Map<String, Object> raw = adminMapper.getMonthChartByYear(map);

            String[] months = { "01월", "02월", "03월", "04월", "05월", "06월",
                                "07월", "08월", "09월", "10월", "11월", "12월" };

            List<Map<String, Object>> list = new ArrayList<>();
            for (String month : months) {
                Map<String, Object> row = new HashMap<>();
                row.put("LABEL", month);
                row.put("TOTAL", raw.getOrDefault(month, 0));
                list.add(row);
            }

            result.put("list", list);
        }

        // 지역 + 테마별 + 타이틀
        else if ("themeByRegion".equals(type)) {
            List<Map<String, Object>> raw = adminMapper.getThemeSalesByRegion(map);

            Set<String> regions = new LinkedHashSet<>();
            Set<String> themes = new LinkedHashSet<>();
            Map<String, Map<String, Integer>> grouped = new LinkedHashMap<>();

            for (Map<String, Object> row : raw) {
                String region = (String) row.get("REGION");
                String theme = (String) row.get("THEME");
                int total = ((Number) row.get("TOTAL")).intValue();
                
                if (region == null || theme == null) continue;
                
                regions.add(region);
                themes.add(theme);

                grouped.putIfAbsent(theme, new HashMap<>());
                grouped.get(theme).put(region, total);
            }

            List<Map<String, Object>> series = new ArrayList<>();
            for (String theme : themes) {
                Map<String, Object> data = new HashMap<>();
                data.put("name", theme);

                List<Integer> values = new ArrayList<>();
                for (String region : regions) {
                    values.add(grouped.get(theme).getOrDefault(region, 0));
                }

                data.put("data", values);
                series.add(data);
            }
            
            result.put("series", series); // ✅ stacked chart용
            result.put("categories", new ArrayList<>(regions)); // ✅ x축 지역
        }
            
        // 📆 일별 매출
        else if ("day".equals(type)) {
            List<Map<String, Object>> raw = adminMapper.getDayChartByYearMonth(map);

            String selectedYear = map.get("year").toString();
            String selectedMonth = map.get("month").toString();

            int lastDay = getLastDayOfMonth(Integer.parseInt(selectedYear), Integer.parseInt(selectedMonth));

            // 1~마지막 일까지 0으로 초기화
            Map<String, Integer> chartMap = new LinkedHashMap<>();
            for (int i = 1; i <= lastDay; i++) {
                String dayLabel = String.format("%02d일", i);
                chartMap.put(dayLabel, 0);
            }

            // DB 데이터로 갱신
            for (Map<String, Object> row : raw) {
                String day = (String) row.get("DAY");
                // 👇 포맷 통일: "1일" → "01일"
                String formattedDay = String.format("%02d일", Integer.parseInt(day.replace("일", "")));
                int total = ((Number) row.get("TOTAL")).intValue();
                chartMap.put(formattedDay, total);
            }

            List<Map<String, Object>> list = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : chartMap.entrySet()) {
                Map<String, Object> item = new HashMap<>();
                item.put("LABEL", entry.getKey());
                item.put("TOTAL", entry.getValue());
                list.add(item);
            }

            result.put("list", list);
        }

        else {
            result.put("list", Collections.emptyList());
        }

        return result;
    }

    private int getLastDayOfMonth(int year, int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month - 1, 1);
        return calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
    }
    
    public HashMap<String, Object> getSummary(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        
        int totalAmount = adminMapper.selectTotalAmount();
        int yesterdayAmount = adminMapper.selectYesterdayAmount();
        int totalUsers = adminMapper.selectTotalUsers();
        int approved = adminMapper.selectApprovedCount();
        int rejected = adminMapper.selectRejectedCount();

        result.put("totalAmount", totalAmount);
        result.put("yesterdayAmount", yesterdayAmount);
        result.put("totalUsers", totalUsers);
        result.put("approved", approved);
        result.put("rejected", rejected);
        

        return result;
    }
    
    public List<String> getAllRegionNames() {
        return adminMapper.getRegionList();
    }

	public HashMap<String, Object> getGuidesList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Guide> guidesList = adminMapper.selectguidesList(map);
			resultMap.put("result", "success");
			resultMap.put("guidesList", guidesList);
			
		} catch (Exception e) {
      System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	public HashMap<String, Object> editGuide(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("password"));
	        map.put("password", hashPwd);
			int guideInfo = adminMapper.updateGuideInfo(map);
			int userInfo = adminMapper.updateUserInfo(map);
			String result;
			if(guideInfo > 0 && userInfo > 0) {
				result = "success";
			} else {
				result = "fail";
			}
			resultMap.put("result", result);
			
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", e.getMessage());
		}
		return resultMap;
	}
	public HashMap<String, Object> getTransactionList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    
	    int page = Integer.parseInt(String.valueOf(map.get("page")));
	    int size = Integer.parseInt(String.valueOf(map.get("size")));

	    int start = (page - 1) * size + 1;
	    int end = page * size;

	    map.put("start", start);
	    map.put("end", end);
	    
	    List<HashMap<String, Object>> list = adminMapper.selectTransactionList(map);
	    int totalCount = adminMapper.selectTransactionTotalCount(map);
	    
	    resultMap.put("list", list); // 프론트에 넘길 데이터 key
	    resultMap.put("totalCount", totalCount);
	    
	    return resultMap;
	}

	public HashMap<String, Object> addGuideProfile(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println(map);
			int result = adminMapper.insertGuideProfile(map);
			System.out.println(result);
			resultMap.put("result", result > 0 ? "success" : "fail");			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", e.getMessage());
		}
		return resultMap;
	}


	public HashMap<String, Object> getAllReviewList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    List<HashMap<String, Object>> list = adminMapper.selectAllReviews();
	    resultMap.put("list", list);
	    return resultMap;
	}
}