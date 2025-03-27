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
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
                height: calc(100vh - 300px);
                ;
                margin: 0 auto;
                padding: 20px;
                box-sizing: border-box;
            }

            /* 사이드 메뉴 */
            .side-menu {
                width: 200px;
                margin-right: 30px;
            }

            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .side-menu li {
                margin-bottom: 10px;
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
        </style>
    </head>

    <body>
        <!-- 공통 헤더 -->
        <jsp:include page="../common/header.jsp" />

        <div id="app" class="container">
            <!-- 좌측 사이드 메뉴 -->
            <div class="side-menu">
                <ul>
                    <li><a href="#">회원 정보수정</a></li>
                    <li><a href="#">구매한 상품</a></li>
                    <li><a href="#">이용후기 관리</a></li>
                    <li><a href="#">문의하기</a></li>
                    <li><a href="#">회원 탈퇴</a></li>
                </ul>
            </div>

            <!-- 우측 메인 콘텐츠 -->
            <div class="content-area">
                <div id='calendar'></div>
            </div>
        </div>

        <!-- 공통 푸터 -->
        <jsp:include page="../common/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                themeSystem: 'bootstrap5',
                initialView: 'dayGridMonth',
                validRange: function (now) {
                    return {
                        start: now,                     // 오늘 날짜
                        // end: now.add(30, 'days')        // 오늘부터 30일 후까지
                    };
                },
                events: [
                    { title: '일정1', start: '2025-03-29T10:00:00', allDay: true, backgroundColor: 'red', borderColor: 'red' },
                    { title: '일정2', start: '2025-03-29T12:30:00', allDay: true }
                ]
            });
            calendar.render();
        });
            const app = Vue.createApp({
                data() {
                    return {
                        // 예: 이미 인증된 이메일 정보(샘플)
                        sessionId: "${sessionId}",
                    };
                },
                methods: {
                },
                mounted() {
                    // 페이지 로드시 필요한 초기화 로직
                    // 세션롤이 가이드가 아니거나 세션아이디가 널이면 알림창
                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "localhost:8080/main.do";
                    }
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>