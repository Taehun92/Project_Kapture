<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>첫번째 페이지</title>
</head>
<style>
</style>
<body>
	<div id="app">
        <div>
        <input v-model="userEmail" type="text" placeholder="이메일 주소 혹은 아이디">
        </div>

        <div>
        <input v-model="password" type="password" placeholder="비밀번호 확인">
        </div>

        <div>
        <button @click="fnLogin">로그인</button>
         </div>

         <div >
            <a  style="text-decoration: none; color: black;" @click="fnSearch" href="javascript:;">아이디 / 비밀번호 찾기</a>
            <a style="text-decoration: none; color: black;" @click="fnJoin" href="javascript:;">  회원가입 </a>
         </div>
         <div>
            or
         </div>
	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                userEmail : self.userEmail,
                password : self.password
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {};
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
            fnSearch () {
                location.href="/login/search.do"
            },
            fnJoin () {

            }

        },
        mounted() {
            var self = this;
            self.fnLogin();
        }
    });
    app.mount('#app');
</script>