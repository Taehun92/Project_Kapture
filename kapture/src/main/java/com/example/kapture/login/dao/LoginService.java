package com.example.kapture.login.dao;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    
    // 로그인 시 비밀번호 비교
    public boolean checkPassword(String rawPw, String hashedPw) {
        return passwordEncoder.matches(rawPw, hashedPw);
    }
    
    // 로그인
    public HashMap<String, Object> userLogin(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        Login login = loginMapper.getlogin(map);
        boolean loginFlg = false;
        if (login != null) {
            loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());
        }
        if (loginFlg) {
            session.setAttribute("sessionId", login.getUserNo());
            session.setAttribute("sessionRole", login.getRole());
            session.setAttribute("sessionFirstName", login.getUserFirstName());
            session.setAttribute("sessionLastName", login.getUserLastName());
            resultMap.put("login", login);
            resultMap.put("result", "success");        
        } else {
            resultMap.put("result", "fail");
        }
        return resultMap;
    }
    
    // 회원가입
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
        
        // 
        if (map.containsKey("lastName")) {
        	String lastName = (String) map.get("lastName");
        	if (lastName == null || lastName.trim().isEmpty()) {
        	    map.put("lastName", "");
        	}
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
    
    // 로그아웃
    public HashMap<String, Object> userLogout(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        session.invalidate();
        resultMap.put("result", "success");
        return resultMap;
    }
    
    // ID 중복체크
    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        Login login = loginMapper.checkUser(map);
        int count = login != null ? 1 : 0;
        resultMap.put("count", count);
        return resultMap;
    }
    
    // 이메일 인증 메일 전송
    public void sendVerificationEmail(String toEmail, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
    
            helper.setTo(toEmail);
            helper.setSubject("[Kapture] 이메일 인증 코드");
    
            String html = loadEmailTemplate("verify.html", code);  // HTML 템플릿 불러오기
            helper.setText(html, true);  // HTML 형식 전송
    
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
    
    // 이메일 인증 코드 생성 메서드
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
    
    // 구글 소셜 로그인 후 신규 가입 또는 기존 사용자 로그인 처리
    // @Transactional을 붙여 insert 작업이 제대로 commit되도록 함.
    @Transactional
    public Map<String, Object> createUserFromSocial(Map<String, Object> param) {
        // 컨트롤러에서 param에 "email", "userFirstName", "userLastName", "socialType" 등의 키가 포함되어 있어야 함.
        String email = (String) param.get("email");
        // DB에서 해당 이메일을 가진 사용자가 있는지 확인
        Map<String, Object> existingUser = loginMapper.selectUserByEmail(email);
        if (existingUser == null) {
            // 신규 회원가입 진행
            int result = loginMapper.insertSocialUser(param);
            if(result > 0) {
                existingUser = loginMapper.selectUserByEmail(email);
            }
        }
        // 이미 가입된 사용자가 있다면 그대로 반환
        return existingUser;
    }
    
    // 이메일로 사용자 정보 조회 (selectUserByEmail 호출)
    public Map<String, Object> findUserByEmail(String email) {
        return loginMapper.selectUserByEmail(email);
    }
    
    // 이메일 목록 조회 (예: 아이디 찾기 기능)
    public HashMap<String, Object> getUserEmail(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<String> emailList = loginMapper.selectUserEmail(map);
            resultMap.put("result", "success");
            resultMap.put("emailList", emailList);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
        }
        return resultMap;
    }
    
    // 비밀번호 변경
    public HashMap<String, Object> updatePassword(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String hashPwd = passwordEncoder.encode((String) map.get("password"));
        map.put("password", hashPwd);
        int updated = loginMapper.updateUserPassword(map);
        if (updated > 0) {
            resultMap.put("result", "success");
        } else {
            resultMap.put("result", "fail");
            resultMap.put("message", "비밀번호 변경 실패");
        }
        return resultMap;
    }
}
