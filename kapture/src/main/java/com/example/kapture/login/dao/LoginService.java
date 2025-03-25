package com.example.kapture.login.dao;

import java.util.HashMap;
import java.util.Random;

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
//		boolean loginFlg = false;
		if(login != null) {
//			loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());
			System.out.println("성공");
			session.setAttribute("sessionId", login.getUserNo());
			session.setAttribute("sessionRole", login.getRole());
			session.setAttribute("sessionFirstName", login.getUserFirstName());
			session.setAttribute("sessionLastName", login.getUserLastName());
			resultMap.put("login", login);
			resultMap.put("result", "success");
		}
//		if(loginFlg) {
//					
//		} 
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
	
	//	로그아웃
	public HashMap<String, Object> userLogout(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		session.invalidate();
		resultMap.put("result", "success");
		return resultMap;
	}
	//ID 중복체크 
	public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Login login = loginMapper.checkUser(map);
		
		int count = login != null ? 1 : 0 ;
		resultMap.put("count", count);
//		int count = 0;
//		if(member != null) {
//			count = 1;
//		} else {
//			count = 0;
//		}
		
		return resultMap;
	}

	public String generateVerificationCode() {
	    int length = 6;
	    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	    StringBuilder code = new StringBuilder();
	    Random random = new Random();
	    for (int i = 0; i < length; i++) {
	        code.append(characters.charAt(random.nextInt(characters.length())));
	    }
	    return code.toString();
	}
	
	public void sendVerificationEmail(String to, String code) {
	    System.out.println("[인증 이메일 전송] 받는 사람: " + to + " | 인증번호: " + code);
	    // 실제 전송은 나중에 연동 or EmailJS 사용 시 프론트에서 처리
	}
	
	
	
	

}
