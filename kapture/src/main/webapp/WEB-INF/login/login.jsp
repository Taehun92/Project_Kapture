<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Kapture - Login</title>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f9f9f9;
		}

		#app {
			max-width: 420px;
			margin: 80px auto;
			background: #fff;
			padding: 40px;
			border-radius: 8px;
			box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
		}

		.logo {
			text-align: center;
			margin-bottom: 30px;
		}

		.logo img {
			height: 60px;
		}

		h2 {
			text-align: center;
			margin-bottom: 20px;
			color: #333;
		}

		.login-input {
			width: 100%;
			padding: 12px;
			margin: 10px 0;
			border: 1px solid #ccc;
			border-radius: 4px;
			box-sizing: border-box;
		}

		.login-btn {
			width: 100%;
			background-color: #2b74e4;
			color: white;
			padding: 19px;
			border: none;
			border-radius: 2px;
			font-size: 16px;
			cursor: pointer;
			margin-top: 10px;
		}

		.signup-link {
			margin-top: 20px;
			text-align: center;
			font-size: 15px;
		}

		.signup-link a {
			color: #2b74e4;
			text-decoration: none;
		}

		.error-msg {
			color: red;
			font-size: 13px;
			margin-top: 5px;
			text-align: center;
		}
	</style>
</head>

<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app">
		<div class="logo">
			<img src="../../img/kapture_Logo(2).png" alt="Kapture Logo" />
		</div>

		<h2>Login to Kapture</h2>
		<input class="login-input" type="text" v-model="email" placeholder="Email or ID">
		<input class="login-input" type="password" v-model="password" placeholder="Password" @keyUp.enter="login">

		<div class="error-msg" v-if="errorMessage">{{ errorMessage }}</div>

		<button class="login-btn" @click="login">Login</button>

		<div style="margin-top: 30px; text-align: center; display: flex; justify-content: center; gap: 16px;">
			<!-- Google 로그인 버튼 -->
			<a :href="googleLoginUrl"
			   style="width: 50px; height: 50px; display: flex; justify-content: center; align-items: center; border-radius: 50%; background-color: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.2);">
				<img src="../../img/google.png" alt="Google 로그인" style="width: 50px;" />
			</a>

			<!-- X 로그인 버튼 -->
			<button @click="getTwitAuthCodeUrl"
					style="width: 50px; height: 50px; border: none; border-radius: 50%; background-color: black; display: flex; justify-content: center; align-items: center; box-shadow: 0 2px 6px rgba(0,0,0,0.2); cursor: pointer;">
				<img src="../../img/x.jpg" alt="X 로그인" style="width: 40px;" />
			</button>
		</div>

		<div class="signup-link">
			Don't have an account? <a href="/join.do">Sign up here</a><br />
			Forgot your password? <a href="/find-id.do">Find it here</a>
		</div>
	</div>
	<jsp:include page="../common/footer.jsp" />
</body>
<script>
	const app = Vue.createApp({
		data() {
			return {
				email: "",
				password: "",
				errorMessage: "",
				googleLoginUrl: "/google/login?returnUrl=/main.do"
			};
		},
		methods: {
			login() {
				const self = this;

				if (!self.email || !self.password) {
					self.errorMessage = "Please enter both email and password.";
					return;
				}

				$.ajax({
					url: "/login.dox",
					type: "POST",
					dataType: "json",
					data: {
						email: self.email,
						password: self.password
					},
					success(data) {
						if (data.result === "success") {
							alert(data.login.userFirstName + "님 환영합니다!");
							location.href = "/main.do";
						} else {
							self.errorMessage = data.message || "Login failed. Please try again.";
						}
					},
					error() {
						self.errorMessage = "Server error. Please try again later.";
					}
				});
			},
			getTwitAuthCodeUrl: function () {
				$.ajax({
					type: "POST",
					url: "/twitter/auth-code-url.dox",
					dataType: "json",
					data: { returnUrl: "/main.do" },
					success: function (res) {
						if (res.result === "success") {
							console.log("받은 URL:", res.url);
							window.location.href = res.url;
						} else {
							alert("로그인 URL 생성 실패");
						}
					},
					error: function (xhr, status, error) {
						console.error("트위터 로그인 오류:", error);
						alert("트위터 로그인에 실패했습니다.");
					}
				});
			}
		}
	});
	app.mount('#app');
</script>
</html>
