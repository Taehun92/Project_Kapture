package com.example.kapture.login.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.kapture.login.mapper.LoginMapper;
import com.example.kapture.login.model.Login;

import jakarta.servlet.http.HttpSession;

@Service
public class LoginService {
	
	@Autowired
	LoginMapper loginMapper;
	
	@Autowired
	HttpSession session;
	
	
//	@Autowired
//	PasswordEncoder passwordEncoder;

//	public HashMap<String, Object> userLogin(HashMap<String, Object> map) {
//			// TODO Auto-generated method stub
//			HashMap<String, Object> resultMap = new HashMap<String, Object>();
//			Login login = loginMapper.getlogin(map);
//			boolean loginFlg = false;
//			if(login != null) {
////				loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());
//				
//			}
//			
//			if(loginFlg) {
//				System.out.println("성공");
//				session.setAttribute("sessionId", login.getUserNo());
//				session.setAttribute("sessionName", login.getUserFirstName());
//				session.setAttribute("sessionName", login.getUserLastName());
//				session.setAttribute("sessionStatus", login.getRole());
//				
//				resultMap.put("login", login);
//				resultMap.put("result", "success");
//			} else {
//				System.out.println("실패");
//				resultMap.put("result", "fail");
//			}
//			
//			return resultMap;
//		}
}
