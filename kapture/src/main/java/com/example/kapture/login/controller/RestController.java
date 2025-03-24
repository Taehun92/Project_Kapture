//package com.example.kapture.login.controller;
//
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Properties;
//import java.util.Random;
//
//import org.springframework.mail.SimpleMailMessage;
//import org.springframework.mail.javamail.JavaMailSenderImpl;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//public class RestController {
//	@ResponseBody
//	@PostMapping("/email")
//	public Map email(String email) {
//		
//		JavaMailSenderImpl mailSenderImpl = new JavaMailSenderImpl();
//		Properties prop = new Properties();
//		mailSenderImpl.setHost("smtp.gmail.com");
//		mailSenderImpl.setPort(587);
//		mailSenderImpl.setUsername("applicaion.properties에 입력한 지메일 입력");
//		mailSenderImpl.setPassword("2단계 인증 후 받은 앱  비밀번호 입력");
//		prop.put("mail.smtp.auth", true);
//		prop.put("mail.smtp.starttls.enable", true);
//        
//		mailSenderImpl.setJavaMailProperties(prop);
//		Map map = new HashMap<>();
//		MemberDto dto = loginService.getUser(email);
//        
//		if (dto != null) {
//			map.put("exist", "이미 존재하는 이메일입니다.");
//		} else {
//			Random random = new Random(); // 난수 생성을 위한 랜덤 클래스
//			String key = ""; // 인증번호 담을 String key 변수 생성
//            
//			SimpleMailMessage message = new SimpleMailMessage(); // 이메일 제목, 내용 작업 메서드
//			message.setTo(email); // 스크립트에서 보낸 메일을 받을 사용자 이메일 주소
//			
//			// 입력 키를 위한 난수 생성 코드 
//			for (int i = 0; i < 3; i++) {
//				int index = random.nextInt(26) + 65;
//				key += (char) index;
//			}
//			for (int i = 0; i < 6; i++) {
//				int numIndex = random.nextInt(10);
//				key += numIndex;
//			}
//			
//			String mail = "\n Plantiful 회원가입 이메일 인증.";
//			message.setSubject("회원가입을 위한 이메일 인증번호 메일입니다."); // 이메일 제목
//			message.setText("인증번호는 " + key + " 입니다." + mail); // 이메일 내용
//			
//            try {
//				mailSenderImpl.send(message);
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			map.put("key", key);
//			map.put("dto", dto);
//		}
//		return map;
//	}
//}
