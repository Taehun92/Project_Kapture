<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <title>헤더</title>
    </head>

    <body class="bg-white text-gray-800 text-[16px] tracking-wide">

        <!-- 번역 위젯 -->
        <div class="gtranslate-wrapper fixed left-4 z-50" style="bottom: 80px;">
            <div class="gtranslate_wrapper"></div>
        </div>

        <!-- ✅ 헤더 시작 -->
        <div id="header" class="w-full bg-white shadow-sm border-b">
            <div class="w-[70%] h-[150px] mx-auto relative flex justify-between items-center px-4">

                <!-- 🔹 우측 상단 작은 텍스트 -->
                <div class="absolute top-4 right-4 flex gap-3 text-[15px] text-gray-600 items-center">
                    <a href="/cs/faq.do" class="hover:text-blue-700">FAQ</a>
                    <a href="/cs/main.do" class="hover:text-blue-700">고객센터</a>

                    <template v-if="sessionId == ''">
                        <a href="/login.do">
                            <button
                                class="bg-blue-950 hover:bg-blue-700 text-white px-3 py-[2px] rounded text-[13px] font-thin">
                                Login
                            </button>
                        </a>
                    </template>

                    <template v-if="sessionId != ''">

                        <!-- 장바구니 아이콘 + 수량 표시 -->
                        <a href="/payment.do" class="relative hover:text-blue-700">
                            <i class="fa-solid fa-cart-shopping text-[20px]"></i>

                            <!-- 수량 배지 -->
                            <span v-if="basketCount > 0"
                                class="absolute -top-2 -right-2 bg-red-600 text-white text-[10px] px-[5px] py-[1px] rounded-full leading-none">
                                {{ basketCount }}
                            </span>
                        </a>
                        <!-- 알림 아이콘 + 모달 wrapper -->
                        <div class="relative alarm-box">
                            <button @click="fnToggleAlarm" class="relative hover:text-blue-700">
                                <i class="fa-solid fa-bell text-[20px]"></i>
                                <span v-if="unreadAlarmCount > 0"
                                    class="absolute -top-2 -right-2 bg-red-600 text-white text-[10px] min-w-[16px] h-[16px] flex items-center justify-center rounded-full leading-none">
                                    {{ unreadAlarmCount }}
                                </span>
                            </button>

                            <!-- 🔽 알림 모달 -->
                            <div v-if="showAlarm"
                                class="absolute right-0 mt-2 w-60 bg-white border rounded shadow-md z-50 text-sm">
                                <div class="p-3 border-b font-semibold text-gray-700">새 알림</div>
                                <ul>
                                    <li v-for="alarm in alarmList" :key="alarm.id"
                                        class="px-4 py-2 hover:bg-gray-100 text-gray-700">
                                        {{ alarm.content }}
                                    </li>
                                </ul>
                                <div v-if="alarmList.length === 0" class="p-3 text-center text-gray-400">알림이 없습니다.</div>
                            </div>
                        </div>

                        <!-- 관리자 -->
                        <a v-if="sessionRole == 'ADMIN'" href="/admin.do" class="hover:text-blue-700">
                            <i class="fa-solid fa-user-group text-[20px]"></i>
                        </a>

                        <!-- 일반 사용자 (투어리스트) -->
                        <a v-if="sessionRole == 'TOURIST'" href="/mypage/user-mypage.do" class="hover:text-blue-700">
                            <i class="fa-solid fa-user text-[20px]"></i>
                        </a>

                        <!-- 가이드 -->
                        <a v-if="sessionRole == 'GUIDE'" href="/mypage/guide-schedule.do" class="hover:text-blue-700">
                            <i class="fa-solid fa-user-tie text-[20px]"></i>
                        </a>

                        <button @click="fnLogout"
                            class="bg-blue-950 hover:bg-blue-700 text-white px-3 py-[2px] rounded text-[13px] font-thin">
                            Logout
                        </button>
                    </template>
                </div>

                <!-- 🔵 왼쪽: 로고 + 메뉴 -->
                <div class="flex items-center gap-28 font-semibold text-[35px] text-gray-800">
                    <a href="/main.do">
                        <img src="../../img/logo/kapture_Logo.png" alt="로고" class="w-[120px] h-[96px] object-contain" />
                    </a>
                    <div class="flex gap-12">
                        <a href="/tours/list.do" class="hover:text-blue-700">Tours</a>
                        <div class="relative group">
                            <a href="#" class="hover:text-blue-700">
                                Board
                            </a>
                            <!-- 드롭다운: 가로 정렬 fix -->
                            <div class="absolute left-[-111px] hidden group-hover:flex flex-row items-center bg-white border-t border-gray-300 z-40 px-6 py-2"
                                style="top: 100%; margin-top: 0px;">
                                <a href="/request/list.do"
                                    class="text-gray-800 hover:text-blue-600 font-medium text-lg mr-6 whitespace-nowrap">요청게시판</a>
                                <a href="#"
                                    class="text-gray-800 hover:text-blue-600 font-medium text-lg mr-6 whitespace-nowrap" onclick="alert('준비중입니다.')">자유게시판</a>
                                <a href="#"
                                    class="text-gray-800 hover:text-blue-600 font-medium text-lg whitespace-nowrap" onclick="alert('준비중입니다.')">후기게시판</a>
                            </div>
                        </div>
                        <a href="/course.do" class="hover:text-blue-700">Where to Go</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- ✅ 헤더 끝 -->

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
                        basketCount: 0,
                        showAlarm: false,
                        unreadAlarmCount: 3,
                        alarmList: [
                            { id: 1, content: '예약이 확정되었습니다.' },
                            { id: 2, content: '가이드가 메시지를 보냈습니다.' },
                            { id: 3, content: '리뷰를 남겨주세요!' }
                        ]
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
                    fnGetBasket() {
                        let self = this;
                        $.ajax({
                            url: "/basket/getCount.dox",
                            type: "POST",
                            data: { sessionId: self.sessionId },
                            dataType: "json",
                            success: function (data) {
                                self.basketCount = data.count;
                            }
                        });
                    },

                    fnToggleAlarm() {
                        this.showAlarm = !this.showAlarm;
                    },

                    fnCloseAlarmOutside(e) {
                        // 알림 영역 DOM 찾기
                        const alarmBox = document.querySelector('.alarm-box');
                        if (alarmBox && !alarmBox.contains(e.target)) {
                            this.showAlarm = false;
                        }
                    }
                },
                mounted() {
                    if (this.sessionId != '') {
                        this.fnGetBasket();
                    }
                    const self = this;
                    window.addEventListener("storage", function (e) {
                        if (e.key === "basketChanged") {
                            self.fnGetBasket();
                        }
                    });
                    // 🔔 외부 클릭 감지 등록
                    document.addEventListener("click", this.fnCloseAlarmOutside);
                },
                beforeUnmount() {
                    document.removeEventListener("click", this.fnCloseAlarmOutside);
                }
            });

            header.mount('#header');
        </script>

    </body>

    </html>