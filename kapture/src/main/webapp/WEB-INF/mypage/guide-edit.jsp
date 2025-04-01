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
</style>
<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app">
		<!-- 좌측 사이드 메뉴 -->
		<div class="side-menu">
			<ul>
				<li>
					<a :class="{ active: currentPage === 'guide-mypage.do' }"
						href="http://localhost:8080/mypage/guide-mypage.do">
						가이드 정보수정
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'guide-schedule.do' }"
						href="http://localhost:8080/mypage/guide-schedule.do">
						나의 스케줄
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'user-reviews.do' }"
						href="http://localhost:8080/mypage/user-reviews.do">
						이용후기 관리
					</a>
				</li>
				<li>
					<a href="http://localhost:8080/cs/qna.do">
						문의하기
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'user-unregister.do' }"
						href="http://localhost:8080/mypage/user-unregister.do">
						회원 탈퇴
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'guide-add.do' }"
						href="http://localhost:8080/mypage/guide-add.do">
						여행상품 등록
					</a>
				</li>
			</ul>
		</div>



		
	</div>
	<jsp:include page="../common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
               
            };
        },
        methods: {
            fn(){
				let self = this;
				let nparmap = {

				};
				$.ajax({
					url:".dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						
					}
				});
            }
        },
        mounted() {
            let self = this;

			if (this.sessionId == '') {
				alert("로그인 후 이용해주세요.");
				location.href = "http://localhost:8080/main.do";
			}
			if (this.sessionRole === 'TOURIST') {
				alert("가이드만 이용가능합니다.");
				location.href = "http://localhost:8080/main.do";
			}
        }
    });
    app.mount('#app');
</script>