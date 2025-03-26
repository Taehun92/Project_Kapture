package com.example.kapture.login.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
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
	
	@Value("${client_id}")
	private String client_id;

    @Value("${redirect_uri}")
    private String redirect_uri;

	@RequestMapping("/login.do") 
    public String login(Model model) throws Exception{
		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+client_id+"&redirect_uri="+redirect_uri;
//        model.addAttribute("location", location);
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
	
	// 로그아웃
	@RequestMapping(value = "/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String logout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = loginService.userLogout(map);
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
	
	
	
	
	//카카오 액세스 토큰 및 정보 조회 
	@RequestMapping(value = "/kakao.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String kakao(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", client_id);
        params.add("redirect_uri", redirect_uri);
        params.add("code", (String)map.get("code"));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);

        Map<String, Object> responseBody = response.getBody();
        resultMap = (HashMap<String, Object>)getUserInfo((String) responseBody.get("access_token"));
		System.out.println(resultMap);
		return new Gson().toJson(resultMap);
    }
	private Map<String, Object> getUserInfo(String accessToken) {
	    String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

	    RestTemplate restTemplate = new RestTemplate();
	    HttpHeaders headers = new HttpHeaders();
	    headers.setBearerAuth(accessToken);
	    HttpEntity<String> entity = new HttpEntity<>(headers);

	    ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

	    try {
	        ObjectMapper objectMapper = new ObjectMapper();
	        return objectMapper.readValue(response.getBody(), Map.class);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null; // 예외 발생 시 null 반환
	    }
	}
	
	@RequestMapping("/test-mail")
	@ResponseBody
	public String testMail() {
	    loginService.sendVerificationEmail("수신자메일@gmail.com", "ABC123");
	    return "메일 전송 성공!";
	}
	
}
