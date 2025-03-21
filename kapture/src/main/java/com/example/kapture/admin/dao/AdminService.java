package com.example.kapture.admin.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.admin.mapper.AdminMapper;

@Service
public class AdminService {
	
	@Autowired
	AdminMapper adminMapper;

}
