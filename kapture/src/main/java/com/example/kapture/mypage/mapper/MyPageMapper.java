package com.example.kapture.mypage.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.common.model.Reviews;
import com.example.kapture.login.model.Login;
import com.example.kapture.mypage.model.Guide;
import com.example.kapture.mypage.model.Payments;


@Mapper
public interface MyPageMapper {

	Login selectUser(HashMap<String, Object> map);

	void userInfoUpdate(HashMap<String, Object> map);

	List<Payments> selectPayList(HashMap<String, Object> map);

	void insertTour(HashMap<String, Object> map);

	List<Reviews> selectUserReviewsList(HashMap<String, Object> map);

	List<Guide> selectGuideSchedule(HashMap<String, Object> map);
	
}
