package com.example.kapture.login.dao;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService  {

	@Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        System.out.println("✅ [구글 로그인 사용자 정보]");
        System.out.println("Access Token: " + userRequest.getAccessToken().getTokenValue());
        System.out.println("Client Registration: " + userRequest.getClientRegistration().getClientName());
        System.out.println("Attributes: " + oAuth2User.getAttributes());

        return oAuth2User;
    }
	
}
