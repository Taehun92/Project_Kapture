<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>푸터</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="../../css/footer.css">
</head>
<body>
	<div id="footer">
		<!-- 상단 텍스트 링크 -->
		<div class="footer-links">
		  <a href="#">공지사항</a>
		  <a href="#">이용약관</a>
		  <a href="#">개인정보 처리방침</a>
		</div>
	  
		<!-- 메인 내용 -->
		<div class="footer-content">
		  <!-- 왼쪽: 회사 정보 -->
		  <div class="company-info">
			상호 : (주) 캡쳐여행사 | 대표 : 이태훈<br>
			주소 : 인천광역시 부평구 경원대로 1366 7층 더조은컴퓨터아카데미<br>
			사업자등록번호 : 999-99-00001 | 통신판매업신고번호 : 제 2025-90000 호<br>
			이메일 : taehun92@gmail.com<br>
			Copyright ⓒ 캡쳐여행사 All Rights Reserved. Powered by K-apture Corp.
		  </div>
	  
		  <!-- 오른쪽: 아이콘 정렬 -->
		  <div class="footer-icons">
			<div class="sns-icons">
			  <!-- <img src="/images/icon-twitter.svg" alt="Twitter">
			  <img src="/images/icon-facebook.svg" alt="Facebook">
			  <img src="/images/icon-instagram.svg" alt="Instagram">
			</div>
			<div class="payment-icons">
			  <img src="/images/pay-visa.png" alt="Visa">
			  <img src="/images/pay-mastercard.png" alt="MasterCard">
			  <img src="/images/pay-paypal.png" alt="PayPal">
			  <img src="/images/pay-applepay.png" alt="Apple Pay">
			  <img src="/images/pay-gpay.png" alt="Google Pay"> -->
			</div>
		  </div>
		</div>
	  </div>
</body>

<script>
const footer = Vue.createApp({
	data() {
		return {};
	},
	methods: {
		
	},
	mounted() {
		
	}
});

footer.mount('#footer');
</script>
</html>
