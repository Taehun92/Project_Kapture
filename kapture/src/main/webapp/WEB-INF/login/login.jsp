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
<body>
	<div id="app">
        <div>
        <input v-model="email" type="text" placeholder="Email or Id">
     
        </div>

        <div>
        <input v-model="password" type="password" @keyup.enter="fnLogin" placeholder="password">
        </div>

        <div>
        <button @click="fnLogin" >Login</button>
         </div>

         <div >
            <a  style="text-decoration: none; color: black;" @click="fnSearch" href="javascript:;">아이디 / 비밀번호 찾기</a>
            <a style="text-decoration: none; color: black;" @click="fnJoin" href="javascript:;">  회원가입 </a>
         </div>
    <div>
        <a  :href="location"> 
			<img src="../../img/kakaoLogin.png">
		</a>
    </div>
      
      </div>
  
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                email : "",
                password : "",
                location : "${location}"
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {
                    email : self.email,
                    password : self.password,
                    
                };
				$.ajax({
					url:"/login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        if(data.result == "success"){
							alert(data.login.user + "님 환영합니다!");
							location.href="/main.do";
						} else {
							alert("아이디/패스워드 확인하세요.");
						}
					}
				});
            },
            fnSearch () {
                location.href="/login/search.do"
            },
            fnJoin () {
                location.href="/join.do"
            }

        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>