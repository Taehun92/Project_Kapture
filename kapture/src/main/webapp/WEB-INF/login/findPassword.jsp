<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            <button @click="fnLogin">Login</button>
        </div>
        <div>
            <a :href="location">
                <img src="../../img/kakaoLogin.png"> 
            </a>
            <a id="logBtn" href="#">
                <img src="../../img/facebooklg.jpg" style="width: 30px;">
            </a>
        </div>

        <div>
            <!-- Facebook 로그인 버튼 -->
            
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    email: "",
                    password: "",
                    location: "${location}",
                    isFbLoggedIn: false
                };
            },
            methods: {
                fnLogin() {
                    var self = this;
                    var nparmap = {
                        email: self.email,
                        password: self.password,
                    };
                    $.ajax({
                        url: "/login.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result == "success") {
                                alert(data.login.userFirstName + data.login.userLastName + "님 환영합니다!");
                               location.href = "/main.do";
                            } else {
                                alert("아이디/패스워드 확인하세요.");
                            }
                        }
                    });
                },
                fnSearch() {
                    location.href = "/login/search.do"
                },
                fnJoin() {
                    location.href = "/join.do"
                },

                // 페이스북 로그인 및 로그아웃
                facebookLogin() {
                    FB.login((res) => {
                        FB.api(
                            `/${res.authResponse.userID}/`,
                            'GET',
                            { "fields": "id,name,email" },
                            (res2) => {
                                console.log(res, res2);
                                this.isFbLoggedIn = true;
                                document.querySelector('#logBtn').value = "로그아웃";
                            });
                    });
                },

                facebookLogout() {
                    FB.logout(() => {
                        this.isFbLoggedIn = false;
                        document.querySelector('#logBtn').value = "로그인";
                    });
                }
            },
            mounted() {
                var self = this;

                // 페이스북 SDK 초기화
                window.fbAsyncInit = function () {
                    FB.init({
                        appId: '1496426481743942', // Facebook 앱 ID를 사용하세요
                        cookie: true,
                        xfbml: true,
                        version: 'v10.0'
                    });

                    // 로그인 상태 확인
                    FB.getLoginStatus(function (response) {
                        if (response.status === 'connected') {
                            self.isFbLoggedIn = true;
                            document.querySelector('#logBtn').value = "로그아웃";
                        }
                    });
                };

                // 로그인 버튼 클릭 이벤트 리스너 추가
                document.querySelector('#logBtn').addEventListener('click', e => {
                    if (self.isFbLoggedIn) {
                        self.facebookLogout();
                    } else {
                        self.facebookLogin();
                    }
                });
            }
        });

        app.mount('#app');
    </script>

</body>

</html>
