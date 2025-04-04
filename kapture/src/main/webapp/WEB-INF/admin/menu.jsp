<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<title>첫번째 페이지</title>
</head>
<style>
/* 사이드바 스타일 */
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: 200px;
    height: 100vh;
    background-color: #333;
    color: white;
    padding: 20px;
    box-shadow: 2px 0 5px rgba(0,0,0,0.2);
}

/* 메뉴 리스트 스타일 */
.sidebar ul {
    list-style-type: none;
    padding: 0;
}

.sidebar ul li {
    padding: 10px 0;
}

.sidebar ul li a {
    color: white;
    text-decoration: none;
    display: block;
    padding: 10px;
    border-radius: 5px;
    transition: background 0.3s;
}

.sidebar ul li a:hover {
    background-color: #555;
}

/* 메뉴와 본문이 겹치지 않도록 여백 추가 */
.content {
    margin-left: 220px;
    padding: 20px;
}
</style>
<body>
<div class="sidebar">
    <a href="/main.do"><img id="logo" src="../../img/kapture_Logo.png" style="width: 200px;"></a> 
    <ul>
        <li><a href="/admin/tours.do">상품 관리</a></li>
        <li><a href="/admin/guide.do">가이드 관리</a></li>
        <li><a href="/admin/order.do">주문 및 예약 관리</a></li>
        <li><a href="/admin/review.do">리뷰 및 평점 관리</a></li>
        <li><a href="/admin/pay.do">결제 및 수익 관리</a></li>
        <li><a href="/admin/customer.do">고객 관리</a></li>
        <li><a href="/admin/promotion.do">마케팅 및 프로모션 관리</a></li>
        <li><a href="/admin/setting.do">운영 및 설정 관리</a></li>
    </ul>
</div>
</body>
</html>