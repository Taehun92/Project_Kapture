package com.example.kapture.login.dao;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.kapture.login.mapper.LoginMapper;
import com.example.kapture.login.model.Login;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;

@Service
public class LoginService {
	
	@Autowired
	LoginMapper loginMapper;
	
	@Autowired
	HttpSession session;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	private JavaMailSender mailSender;
	
	//로그인 시 비밀번호 비교
	public boolean checkPassword(String rawPw, String hashedPw) {
        return passwordEncoder.matches(rawPw, hashedPw);
    }
	
	//	로그인 
	public HashMap<String, Object> userLogin(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Login login = loginMapper.getlogin(map);
		boolean loginFlg = false;
		if(login != null) {
			loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());
		}
		if(loginFlg) {
			session.setAttribute("sessionId", login.getUserNo());
			session.setAttribute("sessionRole", login.getRole());
			session.setAttribute("sessionFirstName", login.getUserFirstName());
			session.setAttribute("sessionLastName", login.getUserLastName());
			resultMap.put("login", login);
			resultMap.put("result", "success");		
		} 
		else {
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
	
	
	
	//회원가입 
	public HashMap<String, Object> joinUser(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 비밀번호 해시화
	    String hashPwd = passwordEncoder.encode((String) map.get("password"));
	    map.put("password", hashPwd);

	    // 생년월일 문자열 (예: 24/07/09)
	    String birthdayStr = (String) map.get("birthday");
	    System.out.println("프론트에서 넘어온 생년월일: " + birthdayStr);

	    // 생년월일 날짜 변환
	    SimpleDateFormat sdf = new SimpleDateFormat("yy/MM/dd");
	    try {
	        Date birthday = sdf.parse(birthdayStr); // java.util.Date
	        map.put("birthday", new java.sql.Date(birthday.getTime())); // java.sql.Date로 변환
	    } catch (ParseException e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "잘못된 생년월일 형식입니다.");
	        return resultMap;
	    }

	    // DB 저장
	    int num = loginMapper.insertUser(map);
	    if (num > 0) {
	        resultMap.put("result", "success");
	        resultMap.put("num", num);
	    } else {
	        resultMap.put("result", "fail");
	    }

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

	
	// 이메일 인증 메일 전송
    public void sendVerificationEmail(String toEmail, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("[Kapture] 이메일 인증 코드");

            String html = loadEmailTemplate("verify.html", code);  // ✅ HTML 템플릿 불러오기
            helper.setText(html, true);  // ✅ HTML 형식 전송

            mailSender.send(message);
        } catch (MessagingException | IOException e) {
            e.printStackTrace();
        }
    }

    // 이메일 HTML 템플릿 읽어오기
    public String loadEmailTemplate(String fileName, String code) throws IOException {
        ClassPathResource resource = new ClassPathResource("templates/email/" + fileName);
        String template = new String(Files.readAllBytes(resource.getFile().toPath()), StandardCharsets.UTF_8);
        return template.replace("{{passcode}}", code);
    }

    // 이메일 인증 코드 생성 메서드도 같이
    public String generateVerificationCode() {
        int length = 6;
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = (int)(Math.random() * characters.length());
            code.append(characters.charAt(index));
        }
        return code.toString();
    }

	public HashMap<String, Object> getUserEmail(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String email = loginMapper.selectUserEmail(map);
			resultMap.put("result", "success");
			resultMap.put("email", email);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

}
