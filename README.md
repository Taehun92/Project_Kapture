<a name="top"></a>

<div align="center">
  <img src="https://github.com/Taehun92/Project_Kapture/blob/main/kapture_Logo(1)_500x400.png" alt="Kapture Logo" width="300" />
</div>

# 🌏 Kapture

> **외국인을 위한 맞춤형 소규모 한국 여행 플랫폼**

---

## 📚 목차

1. [💡 프로젝트 소개](#💡-프로젝트-소개)
2. [🗓 개발 기간](#🗓-개발-기간)
3. [👨‍👩‍👦‍👦 팀원 구성](#👨‍👩‍👦‍👦-팀원-구성)
4. [🛠️ 사용 기술](#🛠️-사용-기술)
5. [📄 주요 기능](#📄-주요-기능)
6. [👨‍🔧 역할 분담](#👨‍🔧-역할-분담)
7. [📕 발표 PPT](#📕-발표-ppt)
8. [🎞 시연 영상](#🎞-시연-영상)
9. [🔚 맺음말](#🔚-맺음말)

---

## 💡 프로젝트 소개

Kapture는 한국을 방문하는 외국인을 위한 소규모 맞춤형 관광 쇼핑몰입니다.  
기존 패키지 여행의 단점을 보완하고, 다양한 테마/장소/가이드 선택을 통해 특별한 여행 경험을 제공합니다.

- 고객은 원하는 장소, 테마, 활동을 자유롭게 선택할 수 있고,  
- 가이드는 본인의 전공, 취미, 전문성을 바탕으로 상품을 등록할 수 있습니다.

[🔝맨 위로](#top)

---

## 🗓 개발 기간

| 구간 | 기간 | 주요 작업 |
|------|------|-----------|
| 기획 | 2025.03.10 ~ 03.19 | 컨셉 설정, DB 설계, 회의 |
| 개발 | 2025.03.20 ~ 03.31 | 기능 구현, 페이지 개발 |
| 개선 | 2025.04.01 ~ 04.14 | 보완 및 리팩터링 |

[🔝맨 위로](#top)

---

## 👨‍👩‍👦‍👦 팀원 구성

| 이름 | GitHub |
|------|--------|
| 이태훈 | [Taehun92](https://github.com/Taehun92) |
| 강재석 | [codingjs12](https://github.com/codingjs12) |
| 박건형 | [geon-hyung](https://github.com/geon-hyung) |
| 이재형 | [leejh8997](https://github.com/leejh8997) |

[🔝맨 위로](#top)

---

## 🛠️ 사용 기술

> 백엔드, 프론트엔드, DB, API 등을 조합하여 구성

![Spring Boot](https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![Vue.js](https://img.shields.io/badge/Vue.js-4FC08D?style=for-the-badge&logo=Vue.js&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=Java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jQuery&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=CSS3&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/tailwindcss-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=HTML5&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=black)
![RESTful API](https://img.shields.io/badge/RESTful-API-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![AJAX](https://img.shields.io/badge/AJAX-000000?style=for-the-badge&logo=javascript&logoColor=white)

[🔝맨 위로](#top)

---

## 📄 주요 기능

- **회원가입/로그인**: 이메일 인증, 소셜 로그인(Google 등)
- **상품 관련**: 장바구니 모달, Vue 별점 기능, 바로구매
- **마이페이지**: 여행 일정 달력으로 확인
- **결제 시스템**: 환율 API + 해외 결제(PayPal, 카드 등)
- **외부 API**:
  - 한국관광공사 OPEN API
  - 기상청 날씨 API
  - 챗봇 기능 API 연동

[🔝맨 위로](#top)

---

## 👨‍🔧 역할 분담

### 👤 이태훈

- **작업 페이지**: 로그인/회원가입, 요청 게시판, 가이드 마이페이지, 헤더/푸터
- **기능 구현**: 이메일 인증, 모달 구성, 유효성 검사, 아이디 중복 체크 등

---

### 👤 강재석

- **작업 페이지**: 메인 페이지, 상품 등록/수정, 관광지 페이지
- **기능 구현**: 장바구니, 상품 관리, 관광공사 & 기상청 API, 챗봇 연동 등

---

### 👤 박건형

- **작업 페이지**: 마이페이지(내정보, 비밀번호 변경), 공지사항
- **기능 구현**: 회원정보 수정, 휴대폰 인증, 공지사항 게시 기능

---

### 👤 이재형

- **작업 페이지**: 관리자 페이지, 유저 마이페이지, 상품 상세
- **기능 구현**: 여행 상품 필터(지역/날짜/테마), 유효성 검사, 페이징, 프로필 관리

[🔝맨 위로](#top)

---

## 📕 발표 PPT

▶ [Kapture 발표 자료 보기](https://drive.google.com/file/d/1S54vN3MGMAPsJRxfwo8K9Y5LPi9_-tiM/view?usp=drive_link)

---

## 🎞 시연 영상

▶ [Kapture 시연 영상 보기](https://youtu.be/nYb7iXMzafA)

[🔝맨 위로](#top)

---

## 🔚 맺음말

첫 팀 프로젝트이자 웹 개발의 흐름을 직접 경험한 귀중한 시간들이었습니다.  
설계, 구현, 협업, 발표까지 전 과정을 경험하며 **기술적 성장과 협업의 중요성**을 느꼈습니다.  
향후에는 더 나은 코드 품질과 사용자 경험을 위해 지속적으로 개선해 나가겠습니다.

[🔝맨 위로](#top)
