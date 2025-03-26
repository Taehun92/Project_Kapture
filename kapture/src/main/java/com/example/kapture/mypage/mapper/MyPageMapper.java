package com.example.kapture.mypage.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.login.model.Login;


@Mapper
public interface MyPageMapper {

	Login selectUser(HashMap<String, Object> map);

	void userInfoUpdate(HashMap<String, Object> map);
	
}
