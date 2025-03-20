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

@Controller
public class LoginController {

	@Autowired
	LoginService loginService;
	
	@Value("${client_id}")
	private String client_id;

    @Value("${redirect_uri}")
    private String redirect_uri;

	@RequestMapping("/login/main.do") 
	    public String login(Model model) throws Exception{
			String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+client_id+"&redirect_uri="+redirect_uri;
	        model.addAttribute("location", location);
	
	        return "/login/login-main"; 
	    }


		@RequestMapping("/login/add.do") 
			public String add(Model model) throws Exception{
			
		    return "/login/login-add"; 
		}
	
	
	
		@RequestMapping("/login/search.do") 
	    public String search(Model model) throws Exception{
	//		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+client_id+"&redirect_uri="+redirect_uri;
	//        model.addAttribute("location", location);
	
	        return "/login/search-main"; 
	    }
	
	
	
	 //로그인
		@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = loginService.userLogin(map);
			return new Gson().toJson(resultMap);
		}
		
		// 회원가입
		@RequestMapping(value = "/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			
			resultMap = loginService.addUser(map);
			return new Gson().toJson(resultMap);
		}
		
//		//카카오 액세스 토큰 및 정보 조회 
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
//		        return (String) responseBody.get("access_token");

			System.out.println((String) responseBody.get("access_token"));
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
}
