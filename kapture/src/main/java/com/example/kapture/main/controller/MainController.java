package com.example.kapture.main.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
	@RequestMapping("/main.do")
    public String boardList(Model model) throws Exception{
        return "/main/main";
    }

	
}
