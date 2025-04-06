<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<title>헤더</title>
</head>
<style>
</style>
<body>
	<div id="header">
		<header>
			<div>
				<!--로고 영역-->
				<a href="main"> <!--메인페이지로 이동 예정-->
					<img id="logo" src="javascript:;" >
				</a>

				<!-- 검색 바 -->
				<span class="search-bar">
					<input v-model="keyword" type="text" placeholder="상품을 검색하세요...">
					<button @click="fnSearch">검색</button>
				</span>

				<!--메뉴 버튼-->
				<span>
					<a href="javascript:;">상품검색</a> <!--상품 리스트 화면으로 이동 예정-->
				</span>

				<span>
					<a href="javascript:;">요청게시판</a> <!--요청게시판 화면으로 이동 예정-->
				</span>
			</div>

			<div>
				<span>
					<a href="javascript:;">FAQ</a> <!--FAQ 화면으로 이동 예정-->
				</span>
				<span>
					<a href="javascript:;">고객센터</a> <!--고객센터 화면으로 이동 예정-->
				</span>
				<!-- 로그인 버튼 -->
				<span class="login-btn">
					<a href="javascript:;"> <!--로그인 페이지로 이동 예정-->
						<button>로그인</button> 
					</a>
				</span>
			</div>
		</header>
	</div>
</body>
</html>
<script>
    const header = Vue.createApp({
        data() {
            return {
                keyword : ""
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {	};
				$.ajax({
					url:"login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
					}
				});
            },
			
			fnSearch(){
				let self = this;
				pagechange("main.do",{keyword : self.keyword}); // 상품화면 페이지로 이동 예정
			}

        },
        mounted() {
            var self = this;
        }
    });
    header.mount('#header');
</script>