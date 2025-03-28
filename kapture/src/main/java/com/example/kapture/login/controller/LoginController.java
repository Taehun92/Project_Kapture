package com.example.kapture.login.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

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

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    LoginService loginService;

    @Value("${twitter.client-id}")
    private String twitterClientId;
    @Value("${twitter.client-secret}")
    private String twitterClientSecret;
    @Value("${twitter.redirect-uri}")
    private String twitterRedirectUri;
    @Value("${twitter.scope}")
    private String twitterScope;
    @Value("${twitter.code-challenge-method}")
    private String twitterCodeChallengeMethod;

    @Value("${google.client.id}")
    private String googleClientId;
    @Value("${google.client.secret}")
    private String googleClientSecret;
    @Value("${google.redirect.url}")
    private String googleRedirectUri;

    private final ObjectMapper objectMapper = new ObjectMapper();

    // 로그인 페이지
    @RequestMapping("/login.do")
    public String login() {
        return "/login/login";
    }
    
    // 로그인
  	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  		resultMap = loginService.userLogin(map);
  		return new Gson().toJson(resultMap);
  	}

    // ✅ 로그아웃 처리
    @RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String logout(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        session.invalidate(); // 세션 초기화
        resultMap.put("result", "success");
        return new Gson().toJson(resultMap);
    }

    // ✅ 구글 로그인
    @RequestMapping("/google/login")
    public String googleLoginRedirect() {
        String loginUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + googleClientId
                + "&redirect_uri=" + googleRedirectUri
                + "&response_type=code"
                + "&scope=email%20profile";
        return "redirect:" + loginUrl;
    }

    @RequestMapping("/google/callback")
    public String googleCallback(@RequestParam("code") String code,
    		@RequestParam(value = "returnUrl", defaultValue = "/main.do")String returnUrl,
            HttpSession session) {
        try {
            HashMap<String, Object> userInfo = loginService.handleSocialLogin(
                    "google", code, null,
                    googleClientId, googleClientSecret,
                    googleRedirectUri, null, null);

            HashMap<String, Object> user = loginService.findUserByEmail((String) userInfo.get("email"));

            if (user == null) {
                user = loginService.createUserFromSocial(userInfo);
            }

            loginService.saveLoginSession(user);
            return "redirect:" + returnUrl;
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login.do";
        }
    }

    // ✅ 트위터 로그인
    @RequestMapping("/twitter/login")
    public String twitterLoginRedirect(HttpSession session) {
        String state = UUID.randomUUID().toString();
        String codeChallenge = "simpleChallenge";

        session.setAttribute("twitter_state", state);
        session.setAttribute("code_challenge", codeChallenge);

        String loginUrl = "https://twitter.com/i/oauth2/authorize"
                + "?response_type=code"
                + "&client_id=" + twitterClientId
                + "&redirect_uri=" + twitterRedirectUri
                + "&scope=" + twitterScope.replace(" ", "%20")
                + "&state=" + state
                + "&code_challenge=" + codeChallenge
                + "&code_challenge_method=" + twitterCodeChallengeMethod;

        return "redirect:" + loginUrl;
    }

    @RequestMapping("/oauth/twitter/callback")
    public String twitterCallback(@RequestParam(value = "code", required = false) String code,
                                  @RequestParam(value = "state", required = false) String state,
                                  @RequestParam(value = "returnUrl", defaultValue = "/main.do") String returnUrl,
                                  HttpSession session) {
        try {
            // 파라미터 유효성 확인
            if (code == null || state == null) {
                return "redirect:/login.do";
            }

            String savedState = (String) session.getAttribute("twitter_state");
            String codeChallenge = (String) session.getAttribute("code_challenge");

            if (!state.equals(savedState)) {
                throw new IllegalStateException("state mismatch!");
            }

            // 사용자 정보 요청
            HashMap<String, Object> userInfo = loginService.handleSocialLogin(
                    "twitter", code, codeChallenge,
                    twitterClientId, null,
                    twitterRedirectUri, twitterScope, twitterCodeChallengeMethod);

            HashMap<String, Object> user = loginService.findUserByEmail((String) userInfo.get("email"));
            if (user == null) {
                user = loginService.createUserFromSocial(userInfo);
            }

            loginService.saveLoginSession(user);

            // ✅ redirect 할 returnUrl로 이동
            return "redirect:" + returnUrl;

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login.do";
        }
    }




    // ✅ Vue에서 사용하는 트위터 로그인 URL 요청
    @RequestMapping(value = "/twitter/auth-code-url.dox", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getTwitterAuthCodeUrl(@RequestParam(value = "returnUrl", defaultValue = "/main.do") String returnUrl,
                                                     HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            String state = UUID.randomUUID().toString();
            String codeChallenge = "simpleChallenge";

            session.setAttribute("twitter_state", state);
            session.setAttribute("code_challenge", codeChallenge);
            session.setAttribute("returnUrl", returnUrl); // 저장해두기

            String loginUrl = "https://twitter.com/i/oauth2/authorize"
                    + "?response_type=code"
                    + "&client_id=" + twitterClientId
                    + "&redirect_uri=" + twitterRedirectUri
                    + "&scope=" + twitterScope.replace(" ", "%20")
                    + "&state=" + state
                    + "&code_challenge=" + codeChallenge
                    + "&code_challenge_method=" + twitterCodeChallengeMethod;

            resultMap.put("result", "success");
            resultMap.put("url", loginUrl);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "URL 생성 중 오류 발생");
        }
        return resultMap;
    }


    // ✅ 테스트용 메일 발송
    @RequestMapping("/test-mail")
    @ResponseBody
    public String testMail() {
        loginService.sendVerificationEmail("수신자메일@gmail.com", "ABC123");
        return "메일 전송 성공!";
    }
}
