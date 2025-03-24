<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>헤더</title>
    <link rel="stylesheet" href="../../css/header.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
</head>
<body>
    <div id="header">
        <div class="header-left">
            <a href="/main.do"><img id="logo" src="../../img/kapture_Logo.png"></a>

            <div class="search-bar">
                <input v-model="keyword" type="text" placeholder="상품을 검색하세요...">
                <button @click="fnSearch">검색</button>
            </div>

            <div class="menu">
                <a href="#">여행상품</a>
                <a href="/request/list.do">요청게시판</a>
            </div>
        </div>

        <div class="top-right">
            <div class="right-links">
                <a href="#">FAQ</a>
                <a href="#">고객센터</a>
                <template v-if="sessionId != ''">
                    <a href="#">장바구니(0)</button></a>
                    <a href="#">마이페이지</button></a>
                </template>
            </div>
            <div>
                <template v-if="sessionId == ''">
                    <a href="/login.do"><button class="login-btn">Login</button></a>
                </template>
                <template v-else>
                    <button class="login-btn" @click="fnLogout">Logout</button>
                </template>
            </div>
        </div>
    </div>
</body>

<script>
const header = Vue.createApp({
    data() {
        return {
            keyword: "",
            sessionId: "${sessionId}"
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
            var self = this;
            if (typeof app !== 'undefined' && app._component && app._component.methods.fnToursList) {
                app._component.methods.fnToursList(self.keyword);
            } else {
                alert("검색 기능을 사용할 수 없습니다.");
            }
        },
        initializeGoogleTranslate() {
            var self = this;
            new google.translate.TranslateElement({ pageLanguage: "ko", autoDisplay: true }, "google_translate_element");
            setTimeout(function() {
                var gtCombo = document.querySelector('.goog-te-combo');
                if (gtCombo) {
                    gtCombo.style.display = 'none';
                }
            }, 10);
        }
    },
    mounted() {
        var self = this;
        if (typeof google !== "undefined" && google.translate) {
            self.initializeGoogleTranslate();
        } else {
            window.googleTranslateElementInit = self.initializeGoogleTranslate;
        }
    }
});

header.mount('#header');
</script>
</html>
