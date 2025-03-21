package com.example.kapture.common.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.example.kapture.common.dao.CommonService;

@Controller
public class CommonController {

		@Autowired
		CommonService commonService;
}
