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
			<input type="text" placeholder="ex)123@gmail.com" v-model="user.email">

		
		 <button @click="fnIdCheck" style="margin-left: 10px;">Please double check your ID.</button>
		</div>
		
		Password
		<div>
		<input type="password" v-model="user.password" 
		placeholder="At least 6 characters" >
		</div>
		
		<div style="font-size: small;">
		<img src="../../img/login.png">Passwords must be at least 6 characters.
		</div>
		
		
		Re-enter password 
		<div>
		<input type="password"  v-model="user.password2" >
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
		<input  v-model="user.phone" placeholder="ex) xxx-xxxx-xxxx">
		</div>

		
		birthday 
		<div>
		<input type="text" placeholder="ex)yyyy.mm.dd"  v-model="user.birthday">
		</div>


		<br>

		<div>
			<button style="font-weight: bold;" @click="fnJoin" >Continue</button>
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
					birthday : "",
					
				},
            };
        },
        methods: {
            fnJoin(){
				var self = this;
				var nparmap = self.user;
				if(self.user.password != self.user.password2 ||
				   self.user.password.length < 6 
				){
					alert("Please check your password")
					return;
				}
				if(self.user.firstName == "" ||
				   self.user.lastName == "" ||
				   self.user.phone == "" ||
				   self.user.birthday == "" 
				   
				 ){
					alert("Please fill in all blanks.")
					return;
				}
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
            },
				fnIdCheck : function(){
                    var self = this;
                    if(self.user.email === ""){
                        alert("Please check your ID and re-enter it.");
                        return;
                    }
                    var nparmap = {
                        email : self.user.email
                    };
                    $.ajax({
                        url: "/check.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                           if(data.count == 0){
                                alert("Available");
                           } else {
                                alert("Unavailable")
                           }
                           
                        }
                    });
                },
        },
        mounted() {
            var self = this;
        }
    });
    app.mount('#app');
</script>