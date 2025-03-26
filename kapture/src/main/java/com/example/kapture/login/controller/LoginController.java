package com.example.kapture.login.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.example.kapture.login.dao.LoginService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class LoginController {

    @Autowired
    LoginService loginService;

    @Value("${client_id}")
    private String client_id;

    @Value("${redirect_uri}")
    private String redirect_uri;

    @Value("${google.client.id}")
    private String googleClientId;

    @Value("${google.client.secret}")
    private String googleClientSecret;

    @Value("${google.redirect.url}")
    private String googleRedirectUri;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @RequestMapping("/login.do")
    public String login() {
        return "/login/login";
    }

    @RequestMapping("/join.do")
    public String goJoinPage() {
        return "/login/join";
    }

    @RequestMapping("/find-password.do")
    public String findPassword() {
        return "/login/findPassword";
    }

    @RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String login(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = loginService.userLogin(map);
        if ("success".equals(resultMap.get("result"))) {
            session.setAttribute("user", resultMap.get("login"));
        }
        return new Gson().toJson(resultMap);
    }

    @RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String logout(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        session.invalidate();
        HashMap<String, Object> resultMap = loginService.userLogout(map);
        return new Gson().toJson(resultMap);
    }

    @RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String join(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();
        Boolean verified = (Boolean) session.getAttribute("emailVerified");
        if (verified == null || !verified) {
            resultMap.put("result", "fail");
            resultMap.put("message", "Email not verified.");
            return new Gson().toJson(resultMap);
        }

        resultMap = loginService.joinUser(map);

        session.removeAttribute("emailVerified");
        session.removeAttribute("email_code");
        session.removeAttribute("email_target");
        session.removeAttribute("email_time");

        return new Gson().toJson(resultMap);
    }

    @RequestMapping(value = "/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String check(@RequestParam HashMap<String, Object> map) throws Exception {
        return new Gson().toJson(loginService.checkUser(map));
    }

    @RequestMapping(value = "/login/email/send.dox", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> sendVerificationEmail(@RequestParam HashMap<String, Object> map, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            String email = (String) map.get("email");
            if (email == null || email.trim().isEmpty()) {
                result.put("result", "fail");
                result.put("message", "이메일이 비어 있습니다.");
                return result;
            }

            String code = loginService.generateVerificationCode();

            session.setAttribute("email_code", code);
            session.setAttribute("email_target", email);
            session.setAttribute("email_time", System.currentTimeMillis());

            loginService.sendVerificationEmail(email, code);

            result.put("result", "success");
            result.put("code", code);
            result.put("message", "인증 코드가 전송되었습니다.");
        } catch (Exception e) {
            result.put("result", "fail");
            result.put("message", "메일 전송 중 오류 발생: " + e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/login/email/verify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String verifyEmailCode(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String email = (String) map.get("email");
        String code = (String) map.get("code");

        String savedCode = (String) session.getAttribute("email_code");
        String savedEmail = (String) session.getAttribute("email_target");
        Long sentTime = (Long) session.getAttribute("email_time");

        if (savedCode == null || savedEmail == null || sentTime == null) {
            resultMap.put("result", "fail");
            resultMap.put("message", "인증 요청 기록이 없습니다. 다시 시도해주세요.");
        } else if (System.currentTimeMillis() - sentTime > 600_000) {
            resultMap.put("result", "fail");
            resultMap.put("message", "인증번호가 만료되었습니다.");
        } else if (!savedEmail.equals(email) || !savedCode.equalsIgnoreCase(code)) {
            resultMap.put("result", "fail");
            resultMap.put("message", "이메일 또는 인증번호가 일치하지 않습니다.");
        } else {
            session.setAttribute("emailVerified", true);
            resultMap.put("result", "success");
            resultMap.put("message", "이메일 인증이 완료되었습니다.");
        }

        return new Gson().toJson(resultMap);
    }

    @GetMapping("/google/login")
    public String googleLoginRedirect() {
        String googleLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + googleClientId
                + "&redirect_uri=" + googleRedirectUri
                + "&response_type=code"
                + "&scope=email%20profile";
        System.out.println("👉 [리다이렉트 URL] " + googleLoginUrl);
        return "redirect:" + googleLoginUrl;
    }

    @GetMapping("/google/callback")
    public String googleCallback(@RequestParam("code") String code, HttpSession session) {
        try {
            System.out.println("✅ STEP 1: 구글에서 받은 code = " + code);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("grant_type", "authorization_code");
            params.add("client_id", googleClientId);
            params.add("client_secret", googleClientSecret);
            params.add("redirect_uri", googleRedirectUri);
            params.add("code", code);

            RestTemplate restTemplate = new RestTemplate();
            HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(params, headers);
            ResponseEntity<String> tokenResponse = restTemplate.postForEntity("https://oauth2.googleapis.com/token", tokenRequest, String.class);

            JsonNode tokenJson = objectMapper.readTree(tokenResponse.getBody());
            String accessToken = tokenJson.get("access_token").asText();

            HttpHeaders userHeaders = new HttpHeaders();
            userHeaders.setBearerAuth(accessToken);
            HttpEntity<Void> userRequest = new HttpEntity<>(userHeaders);
            ResponseEntity<JsonNode> userResponse = restTemplate.exchange("https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, userRequest, JsonNode.class);

            JsonNode userInfo = userResponse.getBody();
            String email = userInfo.get("email").asText();
            String name = userInfo.get("name").asText();

            Map<String, Object> user = loginService.findUserByEmail(email);
            if (user != null) {
                session.setAttribute("user", user);
            } else {
                Map<String, Object> param = new HashMap<>();
                param.put("email", email);
                param.put("userFirstName", name);
                param.put("userLastName", "");
                param.put("socialType", "google");

                loginService.createUserFromSocial(param);
                user = loginService.findUserByEmail(email);
                if (user != null) {
                    session.setAttribute("user", user);
                }
            }

            return "redirect:/main.do";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login.do";
        }
    }

    @RequestMapping("/test-mail")
    @ResponseBody
    public String testMail() {
        loginService.sendVerificationEmail("수신자메일@gmail.com", "ABC123");
        return "메일 전송 성공!";
    }
}
