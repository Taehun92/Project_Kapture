<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <title>첫번째 페이지</title>
    </head>
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
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            /* 🔥 여백 좀 더 넓게 */
            background-color: #fff;
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

        .tab-btn {
            margin: 0 4px;
            padding: 8px 12px;
            border: 1px solid #ccc;
            background-color: #f4f4f4;
            cursor: pointer;
            border-radius: 4px;
        }

        .tab-btn.active {
            background-color: #3e4a97;
            color: white;
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

        .fc-event {
            cursor: pointer;
        }

        .transaction-table {
            width: 100%;
            max-width: 1000px;
            /* 🔥 너무 꽉 차지 않게 제한 */
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 15px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.03);
            /* 약간 그림자 */
        }

        .transaction-table th,
        .transaction-table td {
            border: 1px solid #ddd;
            padding: 12px 16px;
            /* 🔥 셀 안 여백 넉넉하게 */
            text-align: center;
        }

        .transaction-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }

        .search-input {
            padding: 10px 14px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-right: 10px;
            width: 300px;
        }

        .search-button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #3e4a97;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .search-button:hover {
            background-color: #2f3c7e;
        }

        .search-bar {
            margin-bottom: 25px;
        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <div class="container">
                <!-- 좌측 사이드 메뉴 -->
                <div class="side-menu">
                    <ul>
                        <li>
                            <a :class="{ active: currentPage === 'guide-mypage.do' }"
                                href="http://localhost:8080/mypage/guide-mypage.do">
                                가이드 정보수정
                            </a>
                        </li>
                        <li>
                            <a :class="{ active: currentPage === 'guide-schedule.do' }"
                                href="http://localhost:8080/mypage/guide-schedule.do">
                                나의 스케줄
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
                        <li>
                            <a :class="{ active: currentPage === 'guide-add.do' }"
                                href="http://localhost:8080/mypage/guide-add.do">
                                여행상품 등록
                            </a>
                        </li>
                        <li>
                            <a :class="{ active: currentPage === 'guide-sales-list.do' }"
                                href="http://localhost:8080/mypage/guide-sales-list.do">
                                판매내역
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="content-area">
                    <!-- 검색 입력창 -->
                    <div style="max-width: 1000px; width: 100%;">
                        <input type="text" v-model="keyword" class="search-input" placeholder="회원명/상품 검색">
                        <button class="search-button" @click="loadFilteredData">검색</button>
                    </div>

                    <!-- 거래 테이블 -->
                    <table class="transaction-table">
                        <thead>
                            <tr>
                                <th>결제일</th>
                                <th>회원 이름</th>
                                <th>상품 제목</th>
                                <th>결제 금액</th>
                                <th>상태</th>
                                <th>인원</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in transactions"
                                :key="item.PAYMENT_DATE + item.USER_FIRSTNAME + item.TITLE">
                                <td>{{ item.PAYMENT_DATE }}</td>
                                <td>{{ item.USER_FIRSTNAME }}</td>
                                <td>{{ item.TITLE }}</td>
                                <td>{{ formatCurrency(item.AMOUNT) }}</td>
                                <td :style="{ color: item.PAYMENT_STATUS === 'PAID' ? 'green' : 'red' }">
                                    {{ item.PAYMENT_STATUS }}
                                </td>
                                <td>{{ item.NUM_PEOPLE }}명</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 페이징 -->
                    <div style="margin-top: 20px; text-align: center;">
                        <button class="tab-btn" @click="goPage(page - 1)" :disabled="page === 1">이전</button>
                        <button v-for="p in totalPages" :key="p" class="tab-btn" :class="{ active: p === page }"
                            @click="goPage(p)">
                            {{ p }}
                        </button>
                        <button class="tab-btn" @click="goPage(page + 1)" :disabled="page === totalPages">다음</button>
                    </div>
                </div>
            </div>
    </div>        



            <jsp:include page="../common/footer.jsp" />
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    keyword: '',
                    transactions: [],
                    page: 1,
                    size: 10,
                    totalPages: 1,
                    sessionId: "${sessionId}",
                    currentPage: ''
                };
            },
            methods: {
                setCurrentPage() {
                    const path = window.location.pathname; // 예: /mypage/guide-sales-list.do
                    this.currentPage = path.substring(path.lastIndexOf("/") + 1); // guide-sales-list.do
                },
                loadFilteredData() {
                    this.page = 1;
                    this.fnGetTransactions();
                },
                fnGetTransactions() {
                    let self = this;
                    $.ajax({
                        url: '/admin/getTransactionList.dox',
                        method: 'POST',
                        data: {
                            keyword: self.keyword,
                            page: self.page,
                            size: self.size,
                            sessionId: self.sessionId
                        },
                        dataType: 'json',
                        success(res) {
                            self.transactions = res.list;
                            self.totalPages = Math.ceil(res.totalCount / self.size);
                        }
                    });
                },
                goPage(p) {
                    if (p < 1 || p > this.totalPages) return;
                    this.page = p;
                    this.fnGetTransactions();
                },
                formatCurrency(val) {
                    return '₩ ' + Number(val).toLocaleString();
                }
            },
            mounted() {
                let self = this;
                self.setCurrentPage();
                self.fnGetTransactions();
            }
        });
        app.mount('#app');
    </script>
     </body>
     </html>