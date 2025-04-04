package com.example.kapture.mypage.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.kapture.common.model.Reviews;
import com.example.kapture.login.model.Login;
import com.example.kapture.mypage.mapper.MyPageMapper;
import com.example.kapture.mypage.model.Guide;
import com.example.kapture.mypage.model.Payments;
import com.example.kapture.tours.model.Tours;

import jakarta.servlet.http.HttpSession;

@Service
public class MyPageService {

	@Autowired
	MyPageMapper myPageMapper;
	
	@Autowired
    PasswordEncoder passwordEncoder;
	
	@Autowired
    HttpSession session;
	// 회원정보 리스트
	public HashMap<String, Object> getUserInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Login userInfo = myPageMapper.selectUser(map);
			resultMap.put("userInfo", userInfo);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "sqlFail");
		}
		return resultMap;
	}
	//비밀번호 체크
	public HashMap<String, Object> checkPassword(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Login userInfo = myPageMapper.selectUser(map);
			boolean loginFlg = false;
	        if (userInfo != null) {
	            loginFlg = passwordEncoder.matches((String) map.get("confirmPassword"), userInfo.getPassword());
	        }
	        if (loginFlg) {
	            resultMap.put("result", "success");        
	        } else {
	        	resultMap.put("result", "fail");
	        }
	        
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "sqlFail");
		}
		return resultMap;
	}
	// 회원정보 수정
	public HashMap<String, Object> userInfoEdit(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
	        myPageMapper.userInfoUpdate(map);
	        resultMap.put("result", "success");
	        
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 구매내역 리스트
	public HashMap<String, Object> getPayList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
	        List<Payments> payList = myPageMapper.selectPayList(map);
	        resultMap.put("payList", payList);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
		
	}
  // 구매한 상품에 대한 유저 리뷰 리스트
	public HashMap<String, Object> getUserReviews(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
	        List<Reviews> reviewsList = myPageMapper.selectUserReviewsList(map);
	        System.out.println(reviewsList);
	        resultMap.put("reviewsList", reviewsList);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	// 리뷰 등록 or 수정
	public HashMap<String, Object> reviewSave(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println("editFlg : " + Boolean.parseBoolean((String) map.get("editFlg")));
			boolean editFlg = Boolean.parseBoolean((String) map.get("editFlg"));
			if(!editFlg) {
				System.out.println("리뷰등록 맵: " + map);
	        	int result = myPageMapper.insertUserReview(map);
	        	resultMap.put("result", result > 0 ? "success" : "fail");
			}
			if(editFlg) {
				System.out.println("리뷰수정 맵: " + map);
				int result = myPageMapper.updateUserReview(map);
	        	resultMap.put("result", result > 0 ? "success" : "fail");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
	// 리뷰 삭제
	public HashMap<String, Object> userReviewRemove(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println("리뷰삭제 맵: " + map);
			int result = myPageMapper.deleteUserReview(map);
	        resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
	// 회원 탈퇴
	public HashMap<String, Object> userUnregister(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Login userInfo = myPageMapper.selectUser(map);
			boolean loginFlg = false;
			if (userInfo != null) {
            	loginFlg = passwordEncoder.matches((String) map.get("confirmPassword"), userInfo.getPassword());
        	}
			if(loginFlg) {
				int result = myPageMapper.unregisterUser(map);
	        	resultMap.put("result", result > 0 ? "success" : "unregisterFail");
	        	session.invalidate();
			} else {
				resultMap.put("result", "pwdCheckFail");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
	// 비밀번호 수정
	public HashMap<String, Object> changePassword(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("newPassword1"));
	        map.put("password", hashPwd);
			int result = myPageMapper.updatePassword(map);
	        resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "queryFail");
		}
		return resultMap;
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------  
	public HashMap<String, Object> addTour(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		System.out.println(map);
		myPageMapper.insertTour(map);
		Object tourNo = map.get("tourNo");
	    if (tourNo != null) {
	        resultMap.put("tourNo", tourNo); // 생성된 tourNo를 결과에 추가
	        resultMap.put("result", "success");
	    } else {
	        resultMap.put("result", "error");
	        resultMap.put("message", "tourNo 생성 실패");
	    }
		
		return resultMap;
	}
	
	public HashMap<String, Object> getGuideSchedule(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			System.out.println(map);
	        List<Guide> schedule = myPageMapper.selectGuideSchedule(map);
	        System.out.println("스케줄 " + schedule);
	        resultMap.put("schedule", schedule);
	        resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	public HashMap<String, Object> editTour(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<>();

		myPageMapper.updateTour(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> getTour(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		Tours tours = myPageMapper.selectTour(map);
		resultMap.put("tours", tours);
		
		return resultMap;
	}
	
	
	public HashMap<String, Object> addToursImg(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		myPageMapper.insertToursFile(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	public HashMap<String, Object> updateImg(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		myPageMapper.updateThumbnail(map);
		myPageMapper.updateToursFile(map);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public Map<String, Object> getTransactionListWithPaging(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();

        // 🔸 세션ID로 유저번호 매핑
        String sessionId = (String) param.get("sessionId");

        // 예: sessionId가 userNo를 직접 의미한다고 가정 (실제 구현에 맞게 바꿔도 됨)
        int userNo = 0;
        try {
            userNo = Integer.parseInt(sessionId);
        } catch (Exception e) {
            result.put("error", "세션 ID가 유효하지 않습니다.");
            return result;
        }
        param.put("userNo", userNo);

        // 🔸 페이징 처리
        int page = Integer.parseInt(param.getOrDefault("page", "1").toString());
        int size = Integer.parseInt(param.getOrDefault("size", "10").toString());
        param.put("start", (page - 1) * size + 1);
        param.put("end", page * size);

        // 🔸 DB 조회
        List<Map<String, Object>> list = myPageMapper.selectTransactionList(param);
        int totalCount = myPageMapper.selectTransactionTotalCount(param);

        result.put("list", list);
        result.put("totalCount", totalCount);
        return result;
    }
	public HashMap<String, Object> deleteTour(HashMap<String, Object> map) {
		
		HashMap<String, Object> resultMap = new HashMap<>();
		
		myPageMapper.deleteTour(map);
		myPageMapper.deleteTourImg(map);
		resultMap.put("result", "success");
		
		return resultMap;
		
	}
	
	
}
