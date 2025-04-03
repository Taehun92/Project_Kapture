<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>헤더</title>
    <link rel="stylesheet" href="../../css/header.css">
</head>
<body>
    <div id="header">
        <div class="header-inner">
            <div class="header-left">
                <a href="/main.do">
                    <img src="../../img/kapture_Logo.png" class="logo-img">
                </a>
        
                <div class="search-bar">
                    <input v-model="keyword" type="text" placeholder="상품을 검색하세요..." @keyUp.enter="fnSearch">
                    <button @click="fnSearch">검색</button>
                </div>
        
                <div class="main-menu">
                    <a href="/tours/list.do">여행상품</a>
                    <a href="/request/list.do">요청게시판</a>
                </div>
            </div>
            <div class="header-right">
                <div class="utility-links">
                    <a href="/cs/faq.do">FAQ</a>
                    <a href="/cs/main.do">고객센터</a>
                    <template v-if="sessionId != ''">
                        <a href="/payment.do">장바구니({{basketCount}})</a>
                        <a href="http://localhost:8080/admin.do" v-if="sessionRole == 'ADMIN'">관리자 페이지</a>
                        <a href="http://localhost:8080/mypage/user-mypage.do" v-if="sessionRole == 'TOURIST'">마이페이지</a>
                        <a href="http://localhost:8080/mypage/guide-schedule.do" v-if="sessionRole == 'GUIDE'">가이드페이지</a>
                    </template>
                    <template v-if="sessionId == ''">
                        <a href="/login.do"><button class="login-btn">Login</button></a>
                    </template>
                    <template v-else>
                        <button class="login-btn" @click="fnLogout">Logout</button>
                    </template>
                </div>
            </div>
        </div>        
    </div>
</body>

<script>
const header = Vue.createApp({
    data() {
        return {
            keyword: "",
            sessionId: "${sessionId}",
            sessionRole : "${sessionRole}",
            basketCount : 0
        };
    },
    methods: {
        fnLogout() {
            var self = this;
            $.ajax({
                url: "/logout.dox",
                type: "POST",
                dataType: "json",
                success: function(data) {
                    if (data.result === "success") {
                        alert("로그아웃 되었습니다.");
                        location.href = "/main.do";
                    }
                }
            });
        },
        fnSearch() {
            const keyword = this.keyword;
            if (!keyword || keyword.trim() === "") {
                alert("검색어를 입력해 주세요.");
                return;
            }

            const encoded = encodeURIComponent(keyword.trim());
            location.href = "/tours/list.do?keyword=" + encoded;
        },

        fnGetBasket() {
            let self = this;
            let nparmap = {
                sessionId : self.sessionId
            };
            $.ajax({
                url: "/basket/getCount.dox",
                type: "POST",
                data: nparmap,
                dataType: "json",
                success: function(data) {
                    console.log(data);
                    self.basketCount = data.count;

                }
            });
        },

    
    },
    mounted() {
        var self = this;
        if(this.sessionId != '') {
            this.fnGetBasket();
        }
        
        window.addEventListener("storage", function(e) {
            if (e.key === "basketChanged") {
                console.log("장바구니 변경 감지됨! 헤더 갱신");
                self.fnGetBasket();
            }
        });

		console.log("세션아이디 : " + self.sessionId);
		console.log("세션롤 : " + self.sessionRole);
		
    }
});

header.mount('#header');
</script>
</html>
