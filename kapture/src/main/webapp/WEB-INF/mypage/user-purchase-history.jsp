<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>마이페이지</title>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <!-- Vue.js -->
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <!-- 캘린더 -->
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
<<<<<<< HEAD
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css">
=======
        <script src="https://cdn.jsdelivr.net/npm/@fullcalendar/bootstrap5@6.1.14/index.global.min.js"></script>
        <!-- 페이지 체인지 -->
        <script src="/js/page-Change.js"></script>
        <script src="https://cdn.tailwindcss.com"></script>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git
        <style>
            .fc .fc-toolbar {
              display: flex;
              justify-content: space-between;
              align-items: center;
              margin-bottom: 1rem;
              font-weight: 600;
            }
            .fc .fc-toolbar-title {
              font-size: 1.5rem;
              font-weight: 600;
              color: #1f2937;
            }
            .fc .fc-button {
              background-color: #1f2937;
              border: 1px solid #d1d5db;
              padding: 6px 10px;
              color: #ffffff;
              font-size: 1rem;
              margin: 0 4px;
              border-radius: 6px;
              box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
              transition: all 0.2s;
            }
            .fc .fc-button:hover {
              background-color: #1f2937;
              border-color: #9ca3af;
              transform: translateY(-1px);
            }
            .fc .fc-button:disabled {
              background-color: #1f2937;
              color: #9ca3af;
              cursor: not-allowed;
            }
          </style>
    </head>

    <body class="bg-white text-gray-800 text-[16px] tracking-wide">
        <jsp:include page="../common/header.jsp" />
<<<<<<< HEAD
        
        <div id="app" class="flex max-w-6xl mx-auto px-6 py-8 gap-10">
            <!-- 사이드바 -->
            <div class="w-56 bg-white shadow-md p-4 rounded">
                <ul class="space-y-2 font-semibold">
                    <li>
                        <a :class="{ 'bg-blue-950 text-white': currentPage === 'user-mypage.do' }"
                           href="/mypage/user-mypage.do"
                           class="block px-3 py-2 rounded hover:bg-blue-100">회원 정보수정</a>
                    </li>
                    <li>
                        <a :class="{ 'bg-blue-950 text-white': currentPage === 'user-purchase-history.do' }"
                           href="/mypage/user-purchase-history.do"
                           class="block px-3 py-2 rounded hover:bg-blue-950">구매한 상품</a>
                    </li>
                    <li>
                        <a :class="{ 'bg-blue-950 text-white': currentPage === 'user-reviews.do' }"
                           href="/mypage/user-reviews.do"
                           class="block px-3 py-2 rounded hover:bg-blue-100">이용후기 관리</a>
                    </li>
                    <li>
                        <a :class="{ 'bg-blue-950 text-white': currentPage === 'qna.do' }"
                           href="/cs/qna.do"
                           class="block px-3 py-2 rounded hover:bg-blue-100">문의하기</a>
                    </li>
                    <li>
                        <a :class="{ 'bg-blue-950 text-white': currentPage === 'user-unregister.do' }"
                           href="/mypage/user-unregister.do"
                           class="block px-3 py-2 rounded hover:bg-blue-100">회원 탈퇴</a>
                    </li>
                </ul>
            </div>
        
            <!-- 콘텐츠 영역 -->
            <div class="flex-1">
                <ul class="flex gap-4 mb-6 text-sm font-medium">
                    <li class="flex items-center"><span class="text-blue-600 mr-2 text-lg">●</span>종일</li>
                    <li class="flex items-center"><span class="text-red-500 mr-2 text-lg">●</span>오전</li>
                    <li class="flex items-center"><span class="text-green-600 mr-2 text-lg">●</span>오후</li>
                </ul>
                <div ref="calendar" class="bg-white p-4 border border-gray-200 rounded shadow-sm"></div>
=======

        <div id="app" class="max-w-7xl mx-auto flex py-10 px-4">
             <!-- 사이드 메뉴 -->
        <aside class="w-full md:w-1/4 bg-white rounded-lg shadow-md p-4">
            <ul class="space-y-3">
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-mypage.do' }"
                       href="http://localhost:8080/mypage/user-mypage.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        회원 정보수정
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-purchase-history.do' }"
                       href="http://localhost:8080/mypage/user-purchase-history.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        구매한 상품
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-reviews.do' }"
                       href="http://localhost:8080/mypage/user-reviews.do"
                       class="block px-4 py-2 rounded hover:bg-blue-700">
                        이용후기 관리
                    </a>
                </li>
                <li>
                    <a href="http://localhost:8080/cs/qna.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        문의하기
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-unregister.do' }"
                       href="http://localhost:8080/mypage/user-unregister.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        회원 탈퇴
                    </a>
                </li>
            </ul>
        </aside>

            <!-- 우측 메인 콘텐츠 -->
            <div class="content-area">
                <ol class="custom-buttons">
                    <li class="custom-button">
                        <span class="dot" style="color: #3788d8;">●</span>
                        <span class="label">종일</span>
                    </li>
                    <li class="custom-button">
                        <span class="dot" style="color: red;">●</span>
                        <span class="label">오전</span>
                    </li>
                    <li class="custom-button">
                        <span class="dot" style="color: green;">●</span>
                        <span class="label">오후</span>
                    </li>
                </ol>
                <div ref="calendar"></div>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git
            </div>
        </div>
        
        <jsp:include page="../common/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 예: 이미 인증된 이메일 정보(샘플)
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        payList: [],
                        currentPage: "",
                        page: "",
                        tourNo: "",
                    };
                },
                methods: {
                    fnGetPayments(callback) {
                        let self = this;
                        let nparmap = {
                            userNo: self.sessionId,
                            currentPage: '',
                        };

                        $.ajax({
                            url: "/mypage/user-purchase-history.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    self.payList = data.payList;
                                    console.log(self.payList);
                                    callback();
                                } else {
                                    console.error("데이터 로드 실패");
                                }
                            },
                            error: function (error) {
                                console.error("AJAX 에러:", error);
                            }
                        });
                    }
                },
                mounted() {
                    // if (localStorage.getItem('page') == "undefined") {
                    //     self.page = 1;
                    // } else {
                    //     self.page = localStorage.getItem('page');
                    // }
                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "localhost:8080/main.do";
                    }
                    if (this.sessionRole === 'GUIDE') {
                        alert("일반회원만 이용가능합니다.");
                        location.href = "http://localhost:8080/main.do";
                    }

                    this.fnGetPayments(() => {
                        const eventsArray = [];
                        for (let i = 0; i < this.payList.length; i++) {
                            const item = this.payList[i];
                            const colorMapping = {
                                "오전": "red",
                                "오후": "green",
                                "종일": "#3788d8"
                            };
                            eventsArray.push({
                                id: item.tourNo,
                                title: item.title || '투어',       // 실제 데이터에 맞게 속성명을 조정하세요.
                                start: item.tourDate,                // 날짜 형식은 FullCalendar에서 인식하는 형식이어야 합니다.
                                allDay: true,    // "종일"이면 allDay는 true, 아니면 false
                                backgroundColor: colorMapping[item.duration] || "gray",
                                borderColor: colorMapping[item.duration] || "gray"
                            });
                        }
                        console.log("eventsArray:", eventsArray);

                        const calendarEl = this.$refs.calendar;
                        const calendar = new FullCalendar.Calendar(calendarEl, {
                            initialView: 'dayGridMonth',
                            validRange: function (now) {
                                return { start: now };
                            },
                            events: eventsArray,
                            eventClick: function (info) {
                                let self = this;
                                // localStorage.setItem('page', self.page);
                                // 클릭된 이벤트의 기본 동작을 막습니다.
                                info.jsEvent.preventDefault();
                                // 투어 상세페이지로 이동 (URL은 프로젝트에 맞게 수정하세요)
                                // pageChange("/tours/tour-info.do", { tourNo: info.event.id });
                                self.tourNo = info.event.id;
                                location.href="/tours/tour-info.do?tourNo=" + self.tourNo;
                            }
                        });
                        calendar.render();
                    });

                    this.currentPage = window.location.pathname.split('/').pop();
                    console.log("Current page:", this.currentPage);
                    // localStorage.removeItem('page');
                }

            });
            app.mount('#app');
        </script>
    </body>

    </html>