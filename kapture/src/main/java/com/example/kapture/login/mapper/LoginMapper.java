package com.example.kapture.login.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.kapture.login.model.Login;

@Mapper
public interface LoginMapper {

	Login getlogin(HashMap<String, Object> map);

	int insertUser(HashMap<String, Object> map);

	
}
