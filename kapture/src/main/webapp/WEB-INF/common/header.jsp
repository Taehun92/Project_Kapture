<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../../css/style.css">
    <title>헤더</title>
</head>
<body class="bg-white text-gray-800 font-sans text-[16px] tracking-wide">
    <div id="header" class="w-full shadow-sm border-b bg-white">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <!-- 왼쪽 영역 -->
            <div class="flex items-center gap-6">
                <!-- 로고 -->
                <a href="/main.do">
                    <img src="../../img/kapture_Logo.png" class="w-32 h-auto" alt="로고" />
                </a>

                <!-- 검색바 -->
                <div class="flex items-center gap-2">
                    <!-- 🔍 검색 입력창 -->
                    <div class="flex items-center px-4 py-2 border border-gray-300 rounded-md bg-gray-50 w-[320px]">
                        <input 
                            v-model="keyword" 
                            type="text" 
                            placeholder="상품을 검색하세요..." 
                            @keyUp.enter="fnSearch"
                            class="bg-transparent focus:outline-none text-base w-full"
                        />
                    </div>
                
                    <!-- 🔎 검색 버튼 -->
                    <button 
                        @click="fnSearch"
                        class="bg-blue-950 hover:bg-blue-700 text-white text-sm px-4 py-2 rounded">
                        검색
                    </button>
                </div>

                <!-- 메뉴 -->
                <div class="flex items-center gap-6 text-[1.75rem] text-w-bold font-semibold text-gray-700">
                    <a href="/tours/list.do" class="hover:text-blue-700">여행상품</a>
                    <a href="/request/list.do" class="hover:text-blue-700">요청게시판</a>
                </div>
            </div>

            <!-- 오른쪽 영역 -->
            <div class="flex items-center gap-4 text-sm tracking-normal">
                <a href="/cs/faq.do" class="hover:text-blue-700">FAQ</a>
                <a href="/cs/main.do" class="hover:text-blue-700">고객센터</a>
                <!-- 로그인 상태 -->
                <template v-if="sessionId != ''">
                    <a href="/payment.do" class="hover:text-blue-700">장바구니({{ basketCount }})</a>
                    <a v-if="sessionRole == 'ADMIN'" href="http://localhost:8080/admin.do" class="hover:text-blue-700">관리자 페이지</a>
                    <a v-if="sessionRole == 'TOURIST'" href="http://localhost:8080/mypage/user-mypage.do" class="hover:text-blue-700">마이페이지</a>
                    <a v-if="sessionRole == 'GUIDE'" href="http://localhost:8080/mypage/guide-schedule.do" class="hover:text-blue-700">가이드페이지</a>
                    <button @click="fnLogout" class="tracking-normal bg-blue-950 hover:bg-blue-700 text-white px-4 py-1 rounded">
                        Logout
                    </button>
                </template>

                <!-- 비로그인 상태 -->
                <template v-if="sessionId == ''">
                    <a href="/login.do">
                        <button class="bg-blue-950 hover:bg-blue-700 text-white px-4 py-1 rounded">
                            Login
                        </button>
                    </a>
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