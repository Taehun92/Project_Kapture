<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-Change.js"></script>
	<link rel="stylesheet" href="../../css/header.css">
    <script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
	<title>헤더</title>
</script>
</head>
<style>
</style>
<body>
	<div id="header">
        <div id="google_translate_element">
        <header>
            <div>
                <!-- 로고 -->
                <a href="/main.do">
                    <img id="logo" src="#" >
                </a>

                <!-- 검색 바 -->
                <span class="search-bar">
                    <input v-model="keyword" type="text" placeholder="상품을 검색하세요...">
                    <button @click="fnSearch">검색</button>
                </span>

                <!-- 메뉴 -->
                <span>
                    <a href="#">상품검색</a>
                </span>
                <span>
                    <a href="#">요청게시판</a>
                </span>
            </div>

            <div>
                <span>
                     <a href="#" id="language">
                        언어선택
                     </a>
                </span>
                <span>
                    <a href="#">FAQ</a>
                </span>
                <span>
                    <a href="#">고객센터</a>
                </span>
                <!-- 로그인 버튼 -->
                <span class="login-btn">
                    <template v-if="sessionId == ''">
                        <a href="login.do"> 
                            <button>Login</button> 
                        </a>
                    </template>
                    <template v-else>
                        <a>
                            <button>Logout</button>
                        </a>
                    </template>
                </span>
            </div>
        </div>
        </header>
    </div>
</body>
</html>
<script>
    const header = Vue.createApp({
        data() {
            return {
                keyword : "",
                sessionId : "${sessionId}"

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
                console.log(self.keyword);
			    pagechange("main.do",{keyword : self.keyword}); // 상품화면 페이지로 이동 예정
			},

            googleTranslateElementInit() {
            new google.translate.TranslateElement({pageLanguage: 'ko',autoDisplay: false}, 'google_translate_element');
            }

        },
        mounted() {
            var self = this;
           self.googleTranslateElementInit();
        }
    });
    header.mount('#header');
</script>