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
        <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css' rel='stylesheet'>
        <link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css' rel='stylesheet'>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@fullcalendar/bootstrap5@6.1.14/index.global.min.js"></script>
        <style>
            /* 전체 레이아웃 설정 */
            body {
                margin: 0;
                padding: 0;
                font-family: 'Noto Sans KR', sans-serif;
                background-color: #fff;
                color: #333;
            }

            .container {
                /* 사이드 메뉴와 콘텐츠를 가로로 배치하기 위해 flex 사용 */
                display: flex;
                max-width: 1200px;
                min-height: calc(100vh - 300px);
                ;
                margin: 0 auto;
                padding: 20px;
                box-sizing: border-box;
            }

            /* 사이드 메뉴 */
            .side-menu {
                width: 200px;
                height: 100%;
                border: 1px solid #ddd;
                position: sticky;
                top: 0;
                background: white;
                transition: top 0.3s;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;

            }

            .side-menu li {
                margin-bottom: 10px;

            }

            .side-menu li a.active {
                display: block;
                background-color: #3e4a97;
                color: white;
                padding: 10px;
                text-decoration: none;
            }

            .side-menu a {
                text-decoration: none;
                color: #333;
                font-weight: 500;
            }

            .side-menu a:hover {
                color: #ff5555;
            }

            /* 메인 콘텐츠 영역 */
            .content-area {
                flex: 1;
            }

            /* 공통 박스 스타일 */
            .box {
                border: 1px solid #ccc;
                padding: 20px;
                margin-bottom: 20px;
            }

            .box .title {
                margin: 0 0 15px;
                font-size: 16px;
                font-weight: bold;
            }

            /* 폼 그룹 공통 스타일 */
            .form-group {
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .form-group label {
                width: 100px;
                font-weight: 600;
                margin-right: 10px;
            }

            .form-group input[type="text"],
            .form-group input[type="password"] {
                flex: 1;
                padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
            }

            /* 필수 항목 표시 */
            .required::after {
                content: "*";
                margin-left: 4px;
                color: red;
            }

            /* 라디오 버튼 그룹 */
            .radio-group {
                display: flex;
                align-items: center;
            }

            .radio-group label {
                margin-right: 15px;
                font-weight: normal;
                cursor: pointer;
            }

            /* 저장하기 버튼 */
            .btn-save {
                margin-top: 20px;
                padding: 10px 20px;
                background-color: #ff5555;
                border: none;
                color: #fff;
                font-size: 14px;
                cursor: pointer;
            }

            .btn-save:hover {
                background-color: #ff3333;
            }

            .center-box {
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: center;
                margin-top: 150px;

                /* 필요 시 조정 */
                text-align: center;
                gap: 10px;
            }

            /* customButtons 스타일 */
            .fc-button.fc-button-primary.all-day-btn1,
            .fc-button.fc-button-primary.all-day-btn2,
            .fc-button.fc-button-primary.all-day-btn3 {
                background-color: white !important;
                border-color: #ccc !important;
                color: black !important;
                /* 필요 시 padding, font-size 등도 지정 */
                padding: 5px 10px;
                font-size: 14px;
            }

            /* CSS 코드: 버튼 모양과 스타일 지정 */
            .custom-buttons {
                list-style: none;
                /* 기본 목록 스타일 제거 */
                padding: 0;
                margin: 0;
                display: flex;
                /* 가로로 정렬 */
                gap: 10px;
                /* 버튼 간 간격 */
            }

            .custom-button {
                /* 배경 흰색 */
                color: black;
                /* 글씨 검은색 */
                padding: 5px 10px;
                /* 적당한 여백 */
                display: flex;
                /* 내부 항목을 가로 정렬 */
                align-items: center;
                /* 수직 중앙 정렬 */
                font-size: 14px;
            }

            .custom-button .dot {
                margin-right: 4px;
                /* 점과 텍스트 사이 간격 */
            }
        </style>
    </head>

    <body>
        <!-- 공통 헤더 -->
        <jsp:include page="../common/header.jsp" />

        <div id="app" class="container">
            <!-- 좌측 사이드 메뉴 -->
            <div class="side-menu">
                <ul>
                    <li>
                        <a :class="{ active: currentPage === 'user-mypage.do' }" 
                           href="http://localhost:8080/mypage/user-mypage.do">
                          회원 정보수정
                        </a>
                      </li>
                      <li>
                        <a :class="{ active: currentPage === 'user-purchase-history.do' }" 
                           href="http://localhost:8080/mypage/user-purchase-history.do">
                          구매한 상품
                        </a>
                      </li>
                      <li>
                        <a :class="{ active: currentPage === 'user-reviews.do' }" 
                           href="http://localhost:8080/mypage/user-reviews.do">
                          이용후기 관리
                        </a>
                      </li>
                      <li>
                        <a href="http://localhost:8080/cs/qna.do">
                          문의하기
                        </a>
                      </li>
                      <li>
                        <a :class="{ active: currentPage === 'user-unregister.do' }" 
                           href="http://localhost:8080/mypage/user-unregister.do">
                          회원 탈퇴
                        </a>
                      </li>
                </ul>
            </div>

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
            </div>
        </div>

        <!-- 공통 푸터 -->
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
                    };
                },
                methods: {
                    fnGetPayments(callback) {
                        let self = this;
                        let nparmap = {
                            sessionId: self.sessionId,
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

                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "localhost:8080/main.do";
                    }
                    if (this.sessionRole != 'TOURIST') {
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
                            themeSystem: 'bootstrap5',
                            initialView: 'dayGridMonth',
                            validRange: function (now) {
                                return { start: now };
                            },
                            events: eventsArray
                        });
                        calendar.render();
                    });

                    this.currentPage = window.location.pathname.split('/').pop();
                    console.log("Current page:", this.currentPage);
                }

            });
            app.mount('#app');
        </script>
    </body>

    </html>