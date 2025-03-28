package com.example.kapture.login.controller;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.kapture.login.dao.LoginService;
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

    @Value("${facebook.client-id}")
    private String facebookClientId;
    @Value("${facebook.client-secret}")
    private String facebookClientSecret;
    @Value("${facebook.redirect-uri}")
    private String facebookRedirectUri;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @RequestMapping("/login.do")
    public String login() {
        return "/login/login";
    }

    @RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String loginProc(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String email = (String) map.get("email");
            String password = (String) map.get("password");

            if (email == null || password == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "이메일 또는 비밀번호가 누락되었습니다.");
                return new Gson().toJson(resultMap);
            }

            HashMap<String, Object> user = loginService.findUserByEmail(email);

            if (user == null) {
                resultMap.put("result", "fail");
                resultMap.put("message", "존재하지 않는 사용자입니다.");
                return new Gson().toJson(resultMap);
            }

            if (!password.equals(user.get("PASSWORD"))) {
                resultMap.put("result", "fail");
                resultMap.put("message", "비밀번호가 일치하지 않습니다.");
                return new Gson().toJson(resultMap);
            }

            loginService.saveLoginSession(user);
            resultMap.put("result", "success");
            resultMap.put("login", user);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "서버 오류 발생");
            e.printStackTrace();
        }

        return new Gson().toJson(resultMap);
    }

    @RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String logout(HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();
        session.invalidate();
        resultMap.put("result", "success");
        return new Gson().toJson(resultMap);
    }

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
                                  @RequestParam(value = "returnUrl", defaultValue = "/main.do") String returnUrl,
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
            if (code == null || state == null) {
                return "redirect:/login.do";
            }

            String savedState = (String) session.getAttribute("twitter_state");
            String codeChallenge = (String) session.getAttribute("code_challenge");

            if (!state.equals(savedState)) {
                throw new IllegalStateException("state mismatch!");
            }

            HashMap<String, Object> userInfo = loginService.handleSocialLogin(
                    "twitter", code, codeChallenge,
                    twitterClientId, null,
                    twitterRedirectUri, twitterScope, twitterCodeChallengeMethod);

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
            session.setAttribute("returnUrl", returnUrl);

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

    @RequestMapping(value = "/facebook/login-url.dox", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getFacebookAuthCodeUrl(@RequestParam(value = "returnUrl", defaultValue = "/main.do") String returnUrl,
                                                      HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            session.setAttribute("returnUrl", returnUrl);
            String loginUrl = "https://www.facebook.com/v18.0/dialog/oauth"
                    + "?client_id=" + facebookClientId
                    + "&redirect_uri=" + URLEncoder.encode(facebookRedirectUri, "UTF-8")
                    + "&response_type=code"
                    + "&scope=email,public_profile";
            resultMap.put("result", "success");
            resultMap.put("url", loginUrl);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("message", "URL 생성 중 오류 발생");
        }
        return resultMap;
    }

    @RequestMapping("/oauth/facebook/callback")
    public String facebookCallback(@RequestParam("code") String code,
                                   @RequestParam(value = "returnUrl", defaultValue = "/main.do") String returnUrl,
                                   HttpSession session) {
        try {
            HashMap<String, Object> userInfo = loginService.handleSocialLogin(
                "facebook", code, null,
                facebookClientId, facebookClientSecret,
                facebookRedirectUri, null, null
            );

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

    @RequestMapping("/test-mail")
    @ResponseBody
    public String testMail() {
        loginService.sendVerificationEmail("수신자메일@gmail.com", "ABC123");
        return "메일 전송 성공!";
    }
}
