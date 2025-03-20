package com.example.kapture.common.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.common.mapper.CommonMapper;

@Service
public class CommonService {

	@Autowired
	CommonMapper commonMapper;
}
