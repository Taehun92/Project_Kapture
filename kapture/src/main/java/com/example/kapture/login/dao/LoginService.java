package com.example.kapture.login.dao;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
	
//	@Value("${client_id}")
//	private String client_id;

	@Autowired
	private ObjectMapper objectMapper;
	
	@Autowired
	private RestTemplate restTemplate ;
	
	// 로그인
	public HashMap<String, Object> userLogin(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		Login login = loginMapper.getlogin(map); // DB에서 사용자 정보 조회

		// 1. 사용자 없음
		if (login == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 사용자입니다.");
			return resultMap;
		}

		// 2. 탈퇴한 회원
		if ("Y".equals(login.getUnregisterYN())) {
			resultMap.put("result", "fail");
			resultMap.put("message", "This account is no longer active.");
			return resultMap;
		}

		// 3. 비밀번호 일치 확인
		boolean loginFlg = passwordEncoder.matches((String) map.get("password"), login.getPassword());

		if (loginFlg) {
			// 4. 로그인 성공
			session.setAttribute("sessionId", login.getUserNo());
			session.setAttribute("sessionRole", login.getRole());
			session.setAttribute("sessionFirstName", login.getUserFirstName());
			session.setAttribute("sessionLastName", login.getUserLastName());

			loginMapper.updateLastLogin(login.getUserNo());
			
			// 리뷰 알림 처리
		    List<Integer> reviewTargetTours = loginMapper.selectReviewTargets(login.getUserNo());
		    System.out.println("📌 리뷰 알림 대상 투어 목록: " + reviewTargetTours);
		    System.out.println("🧪 사용자 번호: " + login.getUserNo());
		    for (Integer tourNo : reviewTargetTours) {
		        HashMap<String, Object> alarmMap = new HashMap<>();
		        alarmMap.put("targetUserNo", login.getUserNo());
		        alarmMap.put("referenceType", "TOUR");
		        alarmMap.put("referenceId", tourNo);
		        alarmMap.put("urlParam", null);

		        loginMapper.insertAlarm(alarmMap);
		    }

			
			resultMap.put("login", login);
			resultMap.put("result", "success");
			resultMap.put("message", "로그인 성공");
		} else {
			// 5. 비밀번호 불일치
			resultMap.put("result", "fail");
			resultMap.put("message", "비밀번호가 일치하지 않습니다.");
		}

		return resultMap;
	}

	// 회원가입
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

		if (map.containsKey("lastName")) {
			String lastName = (String) map.get("lastName");
			if (lastName == null || lastName.trim().isEmpty()) {
				map.put("lastName", "");
			}
		}

		int num = loginMapper.insertUser(map);
		resultMap.put("result", num > 0 ? "success" : "fail");
		resultMap.put("num", num);
		return resultMap;
	}

	// 로그아웃
	public HashMap<String, Object> userLogout(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		session.invalidate();
		resultMap.put("result", "success");
		return resultMap;
	}

	// DB 유저 유무 체크
	public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		Login login = loginMapper.checkUser(map);
		resultMap.put("count", login != null ? 1 : 0);
		return resultMap;
	}

	// 인증 e-mail 전송
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
			code.append(characters.charAt((int) (Math.random() * characters.length())));
		}
		return code.toString();
	}

	// 정보로 유저 e-mail 조회
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

	// 비밀번호 변경
	public HashMap<String, Object> updatePassword(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		String hashPwd = passwordEncoder.encode((String) map.get("password"));
		map.put("password", hashPwd);
		int updated = loginMapper.updateUserPassword(map);
		resultMap.put("result", updated > 0 ? "success" : "fail");
		if (updated <= 0)
			resultMap.put("message", "비밀번호 변경 실패");
		return resultMap;
	}

	/** 1. 랜덤 state 생성 및 세션 저장 */
	public String generateState(HttpSession session) {
		String state = UUID.randomUUID().toString();
		session.setAttribute("oauth_state", state);
		return state;
	}

	/** 2. 구글 로그인 URL 생성 */
	public String buildGoogleLoginUrl(String state) {
		return "https://accounts.google.com/o/oauth2/v2/auth" + "?client_id=" + googleClientId + "&redirect_uri="
				+ googleRedirectUri + "&response_type=code" + "&scope=openid%20email%20profile" + "&state=" + state;
	}

	/** 3. 구글 콜백 전체 처리 */
	public void processGoogleCallback(HttpSession session, String code, String state) throws Exception {
		// 3-1. state 검증
		String sessionState = (String) session.getAttribute("oauth_state");
		if (sessionState == null || !sessionState.equals(state)) {
			throw new RuntimeException("Invalid state parameter");
		}

		// 3-2. 소셜 로그인 처리 (AccessToken + 사용자 정보)
		HashMap<String, Object> userInfo = handleSocialLogin("google", code, null, googleClientId, googleClientSecret,
				googleRedirectUri, null, null);

		// 3-3. 이메일 기준으로 기존 사용자 조회
		HashMap<String, Object> user = findUserByEmail((String) userInfo.get("email"));

		// 3-4. 없으면 신규 회원 생성
		if (user == null) {
			user = createUserFromSocial(userInfo);
		}

		// 3-5. 로그인 세션 저장
		saveLoginSession(user);
	}

	/** 4. 소셜 로그인 실제 통신 처리 (기존에 만든 부분 그대로 활용) */
	public HashMap<String, Object> handleSocialLogin(String type, String code, String codeChallenge, String clientId,
			String clientSecret, String redirectUri, String scope, String codeChallengeMethod) throws Exception {
		HashMap<String, Object> userInfo = new HashMap<>();

		if ("google".equals(type)) {
			// 1. Access Token 요청
			MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
			params.add("grant_type", "authorization_code");
			params.add("client_id", clientId);
			params.add("client_secret", clientSecret);
			params.add("redirect_uri", redirectUri);
			params.add("code", code);

			JsonNode tokenJson = sendPostRequest("https://oauth2.googleapis.com/token", params);
			String accessToken = tokenJson.get("access_token").asText();

			// 2. 사용자 정보 요청
			JsonNode user = sendGetRequest("https://www.googleapis.com/oauth2/v2/userinfo", accessToken);

			// 3. 결과 정리
			userInfo.put("email", getSafeField(user, "email"));
			userInfo.put("userFirstName", getSafeField(user, "name"));
			userInfo.put("userLastName", "");
			userInfo.put("socialType", "GOOGLE");

		} else if ("twitter".equals(type)) {
			MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
			params.add("grant_type", "authorization_code");
			params.add("client_id", clientId);
			params.add("redirect_uri", redirectUri);
			params.add("code_verifier", codeChallenge);
			params.add("code", code);

			JsonNode tokenJson = sendPostRequest("https://api.twitter.com/2/oauth2/token", params);
			String accessToken = tokenJson.get("access_token").asText();

			JsonNode user = sendGetRequest(
					"https://api.twitter.com/2/users/me?user.fields=profile_image_url,name,username", accessToken);
			String username = user.get("data").get("username").asText();
			String email = username + "@twitter.com";

			userInfo.put("email", email);
			userInfo.put("userFirstName", getSafeField(user.get("data"), "name"));
			userInfo.put("userLastName", "");
			userInfo.put("socialType", "TWITTER");

		} else if ("facebook".equals(type)) {
			String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token" + "?client_id=" + clientId
					+ "&redirect_uri=" + redirectUri + "&client_secret=" + clientSecret + "&code=" + code;

			JsonNode tokenJson = sendGetRequest(tokenUrl, null); // 페이스북은 GET 요청
			String accessToken = tokenJson.get("access_token").asText();

			JsonNode user = sendGetRequest(
					"https://graph.facebook.com/me?fields=id,name,email&access_token=" + accessToken, null);

			userInfo.put("email", getSafeField(user, "email"));
			userInfo.put("userFirstName", getSafeField(user, "name"));
			userInfo.put("userLastName", "");
			userInfo.put("socialType", "FACEBOOK");
		}

		return userInfo;
	}

	/** 5. 이메일로 유저 찾기 */
	public HashMap<String, Object> findUserByEmail(String email) {
		return (HashMap<String, Object>) loginMapper.selectUserByEmail(email);
	}

	/** 6. 신규 유저 생성 */
	public HashMap<String, Object> createUserFromSocial(HashMap<String, Object> userInfo) {
		String email = (String) userInfo.get("email");
		HashMap<String, Object> existingUser = findUserByEmail(email);
		if (existingUser == null) {
			loginMapper.insertSocialUser(userInfo);
			existingUser = findUserByEmail(email);
		}
		return existingUser;
	}

	/** 7. 로그인 세션 저장 */
	public void saveLoginSession(HashMap<String, Object> user) {
		session.setAttribute("user", user);
		session.setAttribute("sessionId", user.get("USERNO"));
		session.setAttribute("sessionRole", user.get("ROLE"));
		session.setAttribute("sessionFirstName", user.get("USERFIRSTNAME"));
		session.setAttribute("sessionLastName", user.get("USERLASTNAME"));
	}

	
	// Twitter 로그인 URL 생성
	public String buildTwitterLoginUrl(HttpSession session) {
		String state = UUID.randomUUID().toString();
		String codeChallenge = "simpleChallenge";

		session.setAttribute("twitter_state", state);
		session.setAttribute("code_challenge", codeChallenge);

		String loginUrl = "https://twitter.com/i/oauth2/authorize" + "?response_type=code" + "&client_id="
				+ twitterClientId + "&redirect_uri=" + twitterRedirectUri + "&scope=" + twitterScope.replace(" ", "%20")
				+ "&state=" + state + "&code_challenge=" + codeChallenge + "&code_challenge_method="
				+ twitterCodeChallengeMethod;

		return loginUrl;
	}

	// Twitter 콜백 처리
	public void processTwitterCallback(HttpSession session, String code, String state) throws Exception {
		if (code == null || state == null) {
			throw new IllegalArgumentException("code 또는 state가 없습니다.");
		}

		String savedState = (String) session.getAttribute("twitter_state");
		String codeChallenge = (String) session.getAttribute("code_challenge");

		if (!state.equals(savedState)) {
			throw new IllegalStateException("state mismatch!");
		}

		// 소셜 로그인 처리
		HashMap<String, Object> userInfo = handleSocialLogin("twitter", code, codeChallenge, twitterClientId, null,
				twitterRedirectUri, twitterScope, twitterCodeChallengeMethod);

		HashMap<String, Object> user = findUserByEmail((String) userInfo.get("email"));
		if (user == null) {
			user = createUserFromSocial(userInfo);
		}

		saveLoginSession(user);
	}

	// Twitter 로그인 URL 비동기 생성
	public Map<String, Object> getTwitterAuthCodeUrl(HttpSession session, String returnUrl) {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			String state = UUID.randomUUID().toString();
			String codeChallenge = "simpleChallenge";

			session.setAttribute("twitter_state", state);
			session.setAttribute("code_challenge", codeChallenge);
			session.setAttribute("returnUrl", returnUrl);

			String loginUrl = "https://twitter.com/i/oauth2/authorize" + "?response_type=code" + "&client_id="
					+ twitterClientId + "&redirect_uri=" + twitterRedirectUri + "&scope="
					+ twitterScope.replace(" ", "%20") + "&state=" + state + "&code_challenge=" + codeChallenge
					+ "&code_challenge_method=" + twitterCodeChallengeMethod;

			resultMap.put("result", "success");
			resultMap.put("url", loginUrl);
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "Twitter 로그인 URL 생성 중 오류 발생");
		}
		return resultMap;
	}

	// Facebook 로그인 URL 비동기 생성
	public Map<String, Object> getFacebookAuthCodeUrl(HttpSession session, String redirectUri, String returnUrl) {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			session.setAttribute("returnUrl", returnUrl);

			String loginUrl = "https://www.facebook.com/v18.0/dialog/oauth" + "?client_id=" + facebookClientId
					+ "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8") + "&response_type=code"
					+ "&scope=email,public_profile" + "&auth_type=reauthenticate";

			resultMap.put("result", "success");
			resultMap.put("url", loginUrl);
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "Facebook 로그인 URL 생성 중 오류 발생");
		}
		return resultMap;
	}

	// Facebook 콜백 처리
	public void processFacebookCallback(HttpSession session, String code) throws Exception {
		if (code == null) {
			throw new IllegalArgumentException("code가 없습니다.");
		}

		HashMap<String, Object> userInfo = handleSocialLogin("facebook", code, null, facebookClientId,
				facebookClientSecret, facebookRedirectUri, null, null);

		HashMap<String, Object> user = findUserByEmail((String) userInfo.get("email"));
		if (user == null) {
			user = createUserFromSocial(userInfo);
		}

		saveLoginSession(user);
	}

	/** POST 요청 공통 메서드 */
	private JsonNode sendPostRequest(String url, MultiValueMap<String, String> params) throws Exception {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
		if (!response.getStatusCode().is2xxSuccessful()) {
			throw new RuntimeException("POST 요청 실패: " + url);
		}
		return objectMapper.readTree(response.getBody());
	}

	/** GET 요청 공통 메서드 */
	private JsonNode sendGetRequest(String url, String accessToken) throws Exception {
		HttpHeaders headers = new HttpHeaders();
		if (accessToken != null) {
			headers.setBearerAuth(accessToken);
		}
		HttpEntity<Void> request = new HttpEntity<>(headers);

		ResponseEntity<JsonNode> response = restTemplate.exchange(url, HttpMethod.GET, request, JsonNode.class);
		if (!response.getStatusCode().is2xxSuccessful()) {
			throw new RuntimeException("GET 요청 실패: " + url);
		}
		return response.getBody();
	}

	/** 안전하게 Json 필드 가져오기 */
	private String getSafeField(JsonNode node, String fieldName) {
		JsonNode field = node.get(fieldName);
		return field != null ? field.asText() : "";
	}
}
