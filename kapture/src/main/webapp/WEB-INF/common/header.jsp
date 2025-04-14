<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css">
        <title>헤더</title>
    </head>

    <body class="bg-white text-gray-800 text-[16px] tracking-wide">
        <!-- 번역 -->
        <div class="gtranslate-wrapper fixed bottom-20 left-4 sm:bottom-24 md:bottom-28 z-50">
            <div class="gtranslate_wrapper"></div>
        </div>
        <div id="header" class="w-full bg-white shadow-sm border-b !w-full !max-w-full !overflow-visible">
            <div class="w-full max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
                <div class="flex items-center gap-6 grow basis-0 min-w-0 flex-nowrap">
                    <!-- 로고 -->
                    <a href="/main.do" class="shrink-0">
                        <img src="../../img/logo/kapture_Logo.png" class="w-32 h-auto" alt="로고" />
                    </a>

                    <!-- 검색바 -->
                    <div class="flex items-center gap-2 shrink-0">
                        <div
                            class="flex items-center px-4 py-2 border border-gray-300 rounded-md bg-gray-50 w-[280px] sm:w-[320px]">
                            <input v-model="keyword" type="text" placeholder="Search for product title..."
                                @keyUp.enter="fnSearch" class="bg-transparent focus:outline-none text-sm w-full" />
                        </div>
                        <button @click="fnSearch"
                            class="bg-blue-950 hover:bg-blue-700 text-white text-sm px-4 py-2 rounded whitespace-nowrap">
                            검색
                        </button>
                    </div>

                    <!-- 메뉴 -->
                    <div class="flex items-center gap-4 min-w-0 shrink text-2xl font-semibold text-gray-700">
                        <a href="/tours/list.do"
                            class="hover:text-blue-700 truncate max-w-[130px] whitespace-nowrap overflow-hidden block">
                            여행상품
                        </a>
                        <a href="/request/list.do"
                            class="hover:text-blue-700 truncate max-w-[130px] whitespace-nowrap overflow-hidden block">
                            요청게시판
                        </a>
                    </div>
                </div>

                <!-- 오른쪽 영역 -->
                <div class="flex items-center gap-4 text-sm whitespace-nowrap">
                    <div class="flex items-center gap-4 text-sm whitespace-nowrap min-w-0">
                        <a href="/cs/faq.do"
                            class="hover:text-blue-700 truncate max-w-[80px] overflow-hidden block">FAQ</a>
                        <a href="/cs/main.do"
                            class="hover:text-blue-700 truncate max-w-[100px] overflow-hidden block">고객센터</a>

                        <!-- 로그인 상태 -->
                        <template v-if="sessionId != ''">
                            <a href="/payment.do"
                                class="hover:text-blue-700 truncate max-w-[140px] overflow-hidden block">
                                장바구니({{ basketCount }})
                            </a>

                            <a v-if="sessionRole == 'ADMIN'" href="/admin.do"
                                class="hover:text-blue-700 truncate max-w-[130px] overflow-hidden block text-xs">
                                관리자 페이지
                            </a>
                            <a v-if="sessionRole == 'TOURIST'" href="/mypage/user-mypage.do"
                                class="hover:text-blue-700 truncate max-w-[130px] overflow-hidden block text-xs">
                                마이페이지
                            </a>
                            <a v-if="sessionRole == 'GUIDE'" href="/mypage/guide-schedule.do"
                                class="hover:text-blue-700 truncate max-w-[130px] overflow-hidden block text-xs">
                                가이드페이지
                            </a>

                            <button @click="fnLogout"
                                class="tracking-normal bg-blue-950 hover:bg-blue-700 text-white w-[80px] h-8 text-xs font-semibold truncate rounded text-center">
                                Logout
                            </button>
                        </template>
                    </div>

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
        window.gtranslateSettings = {
            default_language: "ko",
            native_language_names: true,
            detect_browser_language: true,
            languages: ["ko", "en", "ja", "zh-CN"],
            wrapper_selector: ".gtranslate_wrapper",
            alt_flags: { en: "usa" }
        };
    </script>
    <script src="https://cdn.gtranslate.net/widgets/latest/float.js" defer></script>
    <script>
        const header = Vue.createApp({
            data() {
                return {
                    keyword: "",
                    sessionId: "${sessionId}",
                    sessionRole: "${sessionRole}",
                    basketCount: 0
                };
            },
            methods: {
                fnLogout() {
                    var self = this;
                    $.ajax({
                        url: "/logout.dox",
                        type: "POST",
                        dataType: "json",
                        success: function (data) {
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
                        sessionId: self.sessionId
                    };
                    $.ajax({
                        url: "/basket/getCount.dox",
                        type: "POST",
                        data: nparmap,
                        dataType: "json",
                        success: function (data) {
                            console.log(data);
                            self.basketCount = data.count;

                        }
                    });
                },

            },
            mounted() {
                var self = this;
                if (this.sessionId != '') {
                    this.fnGetBasket();
                }

                window.addEventListener("storage", function (e) {
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