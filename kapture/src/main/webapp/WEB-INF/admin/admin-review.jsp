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

.content {
    margin-left: 220px;
    padding: 20px;
}

.review-box {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    background-color: #fafafa;
}

.review-info {
    max-width: 80%;
}

.review-actions {
    text-align: right;
}

.review-title {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 6px;
}

.review-meta {
    font-size: 14px;
    color: #888;
    margin-bottom: 10px;
}

.review-content {
    font-size: 15px;
    line-height: 1.5;
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

<!-- ✅ 이 영역만 Vue에서 리스트 출력 -->
<div class="maincontent" id="app">
    <div class="content">
        <h2>전체 리뷰 리스트</h2>

        <div v-for="review in list" class="review-box">
            <div class="review-info">
                <div class="review-title"> {{ review.TITLE }}</div>
                <div class="review-meta">
                    작성자: {{ review.USERFIRSTNAME }} {{ review.USERRASTNAME }} &nbsp;|&nbsp; 평점: ⭐ {{ review.RATING }} 
                    &nbsp;|&nbsp;  작성자 이메일: {{review.EMAIL}}  &nbsp;|&nbsp; 날짜: {{ review.CREATEDAT }}
                </div>
                <div class="review-content">
                    {{ review.CONTENT }}
                </div>
            </div>
            <div class="review-actions">
                <button>HIDE</button><br>
                <button>RESPOND</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>

<script>
     const app = Vue.createApp({
        data() {
            return {
                list: []  // ✅ 서버에서 가져온 리뷰 저장
            };
        },
        methods: {
            fnReviewList() {
				let self = this;
				let nparmap = {};
				$.ajax({
					url: "/admin-review.dox",
					dataType: "json",	
					type : "POST", 
					data : nparmap,
					success: function(data) { 
						self.list = data.list;
                        
						console.log("리뷰 불러오기 성공", data.list);
					},
					error: function(err) {
						console.error("리뷰 불러오기 실패", err);
					}
				});
            }
        },
        mounted() {
            this.fnReviewList(); // ✅ 최초 진입 시 데이터 불러오기
        }
    });
    app.mount('#app');
</script>
