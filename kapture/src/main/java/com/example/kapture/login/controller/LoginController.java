package com.example.kapture.login.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
    @Value("${client_id}")
 	private String client_id;
 


    private final ObjectMapper objectMapper = new ObjectMapper();

    @RequestMapping("/login.do") 
    public String login(Model model) throws Exception{

        return "/login/login"; 
    }
    
    @RequestMapping("/join.do")
    public String goJoinPage(Model model) throws Exception{
        return "/login/join";

    }
	@RequestMapping("/find-id.do") 
		public String findId(Model model) throws Exception{
	    return "/login/find-id";
	}
    
    // 로그인
   	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   	@ResponseBody
   	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
   		HashMap<String, Object> resultMap = new HashMap<String, Object>();
   		resultMap = loginService.userLogin(map);
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
    
 // 회원가입
  	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String join(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
  	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
  
  	    // 이메일 인증 여부 확인
  	    Boolean verified = (Boolean) session.getAttribute("emailVerified");
  	    if (verified == null || !verified) {
  	        resultMap.put("result", "fail");
  	        resultMap.put("message", "Email not verified.");
  	        return new Gson().toJson(resultMap);
  	    }
  
  	    // 회원가입 처리
  	    resultMap = loginService.joinUser(map);
  
  	    // 세션 정리
  	    session.removeAttribute("emailVerified");
  	    session.removeAttribute("email_code");
  	    session.removeAttribute("email_target");
  	    session.removeAttribute("email_time");
  
  	    return new Gson().toJson(resultMap);
  	}
 // id 중복체크
  	@RequestMapping(value = "/check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String check(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  
  		resultMap = loginService.checkUser(map); 
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
 // 이메일 인증 코드 발송
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
  	        e.printStackTrace();
  	        result.put("result", "fail");
  	        result.put("message", "메일 전송 중 오류 발생: " + e.getMessage());
  	    }
  
  	    return result; // ✅ 여기선 Map 그대로 반환해도 JSON으로 자동 변환됨
  	}
  
  
  
  	//이메일로 전송한 인증코드 확인 
  	@RequestMapping(value = "/login/email/verify.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String verifyEmailCode(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
  	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
  
  	    String email = (String) map.get("email");
  	    String code = (String) map.get("code");
  
  	    String savedCode = (String) session.getAttribute("email_code");
  	    String savedEmail = (String) session.getAttribute("email_target");
  	    Long sentTime = (Long) session.getAttribute("email_time");
  
  	    // 1. 세션 정보 없음
  	    if (savedCode == null || savedEmail == null || sentTime == null) {
  	        resultMap.put("result", "fail");
  	        resultMap.put("message", "인증 요청 기록이 없습니다. 다시 시도해주세요.");
  	        return new Gson().toJson(resultMap);
  	    }
  
  	    // 2. 10분 초과 (600,000ms)
  	    if (System.currentTimeMillis() - sentTime > 600_000) {
  	        resultMap.put("result", "fail");
  	        resultMap.put("message", "인증번호가 만료되었습니다.");
  	        return new Gson().toJson(resultMap);
  	    }
  
  	    // 3. 이메일 또는 인증번호 불일치
  	    if (!savedEmail.equals(email) || !savedCode.equalsIgnoreCase(code)) {
  	        resultMap.put("result", "fail");
  	        resultMap.put("message", "이메일 또는 인증번호가 일치하지 않습니다.");
  	        return new Gson().toJson(resultMap);
  	    }
  
  	    // 4. 성공 - 이메일 인증 완료 플래그 설정
  	    session.setAttribute("emailVerified", true);
  
  	    resultMap.put("result", "success");
  	    resultMap.put("message", "이메일 인증이 완료되었습니다.");
  	    return new Gson().toJson(resultMap);
  	}
  
  	// 이메일 찾기
  	@RequestMapping(value = "/find-email.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String findEmail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  		resultMap = loginService.getUserEmail(map);
  		return new Gson().toJson(resultMap);
  	}
  
  	// 비밀번호 변경
  	@RequestMapping(value = "/login/reset-password.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  	@ResponseBody
  	public String resetPassword(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
  		System.out.println("🔐 받은 비밀번호: " + map.get("password"));
  		HashMap<String, Object> resultMap = new HashMap<String, Object>();
  		resultMap = loginService.updatePassword(map);
  		return new Gson().toJson(resultMap);
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
                    + "&redirect_uri=" + facebookRedirectUri  // ✅ 인코딩 없이 그대로!
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