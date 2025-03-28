package com.example.kapture.login.dao;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.example.kapture.login.mapper.LoginMapper;
import com.example.kapture.login.model.Login;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

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

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();

    public boolean checkPassword(String rawPw, String hashedPw) {
        return passwordEncoder.matches(rawPw, hashedPw);
    }

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

    public HashMap<String, Object> joinUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String hashPwd = passwordEncoder.encode((String) map.get("password"));
        map.put("password", hashPwd);
        String birthdayStr = (String) map.get("birthday");
        try {
            Date birthday = new SimpleDateFormat("yy/MM/dd").parse(birthdayStr);
            map.put("birthday", new java.sql.Date(birthday.getTime()));
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
        resultMap.put("result", num > 0 ? "success" : "fail");
        resultMap.put("num", num);
        return resultMap;
    }

    public HashMap<String, Object> userLogout(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        session.invalidate();
        resultMap.put("result", "success");
        return resultMap;
    }

    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        Login login = loginMapper.checkUser(map);
        resultMap.put("count", login != null ? 1 : 0);
        return resultMap;
    }

    public void sendVerificationEmail(String toEmail, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(toEmail);
            helper.setSubject("[Kapture] 이메일 인증 코드");
            String html = loadEmailTemplate("verify.html", code);
            helper.setText(html, true);
            mailSender.send(message);
        } catch (MessagingException | IOException e) {
            e.printStackTrace();
        }
    }

    public String loadEmailTemplate(String fileName, String code) throws IOException {
        ClassPathResource resource = new ClassPathResource("templates/email/" + fileName);
        String template = new String(Files.readAllBytes(resource.getFile().toPath()), StandardCharsets.UTF_8);
        return template.replace("{{passcode}}", code);
    }

    public String generateVerificationCode() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(characters.charAt((int)(Math.random() * characters.length())));
        }
        return code.toString();
    }

    @Transactional
    public HashMap<String, Object> createUserFromSocial(HashMap<String, Object> param) {
        String email = (String) param.get("email");
        HashMap<String, Object> existingUser = findUserByEmail(email);
        if (existingUser == null) {
            loginMapper.insertSocialUser(param);
            existingUser = findUserByEmail(email);
        }
        return existingUser;
    }

    public HashMap<String, Object> findUserByEmail(String email) {
        return (HashMap<String, Object>) loginMapper.selectUserByEmail(email);
    }

    public HashMap<String, Object> getUserEmail(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<String> emailList = loginMapper.selectUserEmail(map);
            resultMap.put("result", "success");
            resultMap.put("emailList", emailList);
        } catch (Exception e) {
            resultMap.put("result", "fail");
        }
        return resultMap;
    }

    public HashMap<String, Object> updatePassword(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String hashPwd = passwordEncoder.encode((String) map.get("password"));
        map.put("password", hashPwd);
        int updated = loginMapper.updateUserPassword(map);
        resultMap.put("result", updated > 0 ? "success" : "fail");
        if (updated <= 0) resultMap.put("message", "비밀번호 변경 실패");
        return resultMap;
    }

    public HashMap<String, Object> handleSocialLogin(String type, String code, String codeChallenge,
                                                     String clientId, String clientSecret,
                                                     String redirectUri, String scope,
                                                     String codeChallengeMethod) throws Exception {
        HashMap<String, Object> userInfo = new HashMap<>();

        if ("google".equals(type)) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("grant_type", "authorization_code");
            params.add("client_id", clientId);
            params.add("client_secret", clientSecret);
            params.add("redirect_uri", redirectUri);
            params.add("code", code);
            HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(params, headers);
            ResponseEntity<String> tokenResponse = restTemplate.postForEntity("https://oauth2.googleapis.com/token", tokenRequest, String.class);
            JsonNode tokenJson = objectMapper.readTree(tokenResponse.getBody());
            String accessToken = tokenJson.get("access_token").asText();
            HttpHeaders userHeaders = new HttpHeaders();
            userHeaders.setBearerAuth(accessToken);
            HttpEntity<Void> userRequest = new HttpEntity<>(userHeaders);
            ResponseEntity<JsonNode> userResponse = restTemplate.exchange("https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, userRequest, JsonNode.class);
            JsonNode user = userResponse.getBody();
            userInfo.put("email", user.get("email").asText());
            userInfo.put("userFirstName", user.get("name").asText());
            userInfo.put("userLastName", "");
            userInfo.put("socialType", "google");
        } else if ("twitter".equals(type)) {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("grant_type", "authorization_code");
            params.add("client_id", clientId);
            params.add("redirect_uri", redirectUri);
            params.add("code_verifier", codeChallenge);
            params.add("code", code);
            HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(params, headers);
            ResponseEntity<String> tokenResponse = restTemplate.postForEntity("https://api.twitter.com/2/oauth2/token", tokenRequest, String.class);
            JsonNode tokenJson = objectMapper.readTree(tokenResponse.getBody());
            String accessToken = tokenJson.get("access_token").asText();
            HttpHeaders userHeaders = new HttpHeaders();
            userHeaders.setBearerAuth(accessToken);
            HttpEntity<Void> userRequest = new HttpEntity<>(userHeaders);
            ResponseEntity<JsonNode> userResponse = restTemplate.exchange("https://api.twitter.com/2/users/me?user.fields=profile_image_url,name,username", HttpMethod.GET, userRequest, JsonNode.class);
            JsonNode user = userResponse.getBody();
            String username = user.get("data").get("username").asText();
            String email = username + "@twitter.com";
            userInfo.put("email", email);
            userInfo.put("userFirstName", user.get("data").get("name").asText());
            userInfo.put("userLastName", "");
            userInfo.put("socialType", "twitter");
        }

        return userInfo;
    }

    public void saveLoginSession(HashMap<String, Object> user) {
        session.setAttribute("user", user);
        session.setAttribute("sessionId", user.get("USERNO"));
        session.setAttribute("sessionRole", user.get("ROLE"));
        session.setAttribute("sessionFirstName", user.get("USERFIRSTNAME"));
        session.setAttribute("sessionLastName", user.get("USERLASTNAME"));
    }
} 
