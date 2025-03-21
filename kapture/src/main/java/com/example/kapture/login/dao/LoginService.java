package com.example.kapture.login.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
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
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	
//	로그인 
	public HashMap<String, Object> userLogin(HashMap<String, Object> map) {
			// TODO Auto-generated method stub
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			Login login = loginMapper.getlogin(map);
//			boolean loginFlg = false;
			if(login != null) {
//					loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());
				System.out.println("성공");
				session.setAttribute("sessionId", login.getUserNo());
				session.setAttribute("sessionRole", login.getRole());
				
				resultMap.put("login", login);
				resultMap.put("result", "success");
				}
				
//				if(loginFlg) {
//					
//				} 
				else {
					System.out.println("실패");
					resultMap.put("result", "fail");
				}
				
				return resultMap;
			}
//회원가입 
		public HashMap<String, Object> joinUser(HashMap<String, Object> map) {
				HashMap<String, Object> resultMap = new HashMap<String, Object>();
//				String hashPwd = passwordEncoder.encode((String) map.get("password"));
//				map.put("password", hashPwd);
				
				int num = loginMapper.insertUser(map);
				resultMap.put("result", "success");
				// if num > 0 데이터 삽입 잘 된거 
				// 아니면 뭔가 문제 있는거
				return resultMap;
			}

}
