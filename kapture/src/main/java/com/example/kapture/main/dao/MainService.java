package com.example.kapture.main.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.kapture.main.mapper.MainMapper;

@Service
public class MainService {

	@Autowired
	MainMapper mainMapper;
}
