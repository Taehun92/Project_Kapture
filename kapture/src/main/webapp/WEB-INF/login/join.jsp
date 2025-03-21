<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<title>회원가입</title>
</head>
<style>
</style>
<body>
	<div id="app">
		
		
		Email or Id 
		<div>
		<input type="text" placeholder=" ex)123@gmail.com"  v-model="user.email">
		</div>

		
		Password
		<div>
		<input type="password" v-model="user.password" placeholder="At least 6 characters">
		</div>
		
		<div style="font-size: small;">
		<img src="../../img/login.png">Passwords must be at least 6 characters.
		</div>

		
		Re-enter password 
		<div>
		<input type="password"  v-model="user.password2">
		</div>

	
		First Name 	
		<div>
		<input placeholder="FirstName" v-model="user.firstName">
		</div>
			
		
		LastName 
		<div>
		<input type="text" placeholder="LastName"  v-model="user.lastName">
		</div>

		
		Phone 
		<div>
		<input  v-model="user.phone">
		</div>

		
		BirthDay 
		<div>
		<input type="text" placeholder="ex)yyyy.mm.dd"  v-model="user.birthDay">
		</div>

		<div>
		<label>gender : </label>
    	<input type="radio" id="male" name="gender" value="M"  v-model="user.gender">
    	<label for="male">M</label>
    	<input type="radio" id="female" name="gender" value="F"  v-model="user.gender">
    	<label for="female">F</label>
		</div>

		<div>
			<button @click="fnJoin">Continue</button>
		</div>

		<div style="font-size: small; margin-top: 20px;" >
			By creating an account, you agree to Kapture's <br>
			<a href="#">Conditions</a> of Use and <a href="#">Privacy Notice</a>.
		</div>


	</div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                user: {
					firstName : "",
					lastName : "",
					email: "",
					password : "",
					password2 : "",
					phone : "",
					birthDay : ""
				}
            };
        },
        methods: {
            fnJoin(){
				var self = this;
				var nparmap = self.user;
				$.ajax({
					url:"join.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
						alert("Congratulations on becoming a member.")
						location.href= "/login.do";
					}
				});
            }
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>