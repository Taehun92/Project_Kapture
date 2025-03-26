package com.example.kapture.login.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.login.model.Login;

@Mapper
public interface LoginMapper {

	Login getlogin(HashMap<String, Object> map);

	int insertUser(HashMap<String, Object> map);

	Login checkUser(HashMap<String, Object> map);

	List<String> selectUserEmail(HashMap<String, Object> map);

	int updateUserPassword(HashMap<String, Object> map);

	
}
