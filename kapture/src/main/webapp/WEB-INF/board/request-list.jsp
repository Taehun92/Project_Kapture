<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="../../css/request-list.css">
        <title>요청게시판</title>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />

        <div id="app">
            <div class="request-container">
                <div class="request-board-header">
                    <div class="left">
                        <h2 class="title">📌 요청 게시판</h2>
                        <p class="subtitle">고객님이 직접 원하는 여행을 요청해보세요!</p>
                    </div>
                    <div class="search-bar">
                        <input type="text" v-model="keyword" placeholder="제목 또는 작성자 검색" @keyUp.enter="fnSearch">
                        <button @click="fnSearch">검색</button>
                    </div>
                </div>

                <table class="request-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>요청상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in list" :key="item.requestNo">
                            <td>{{ item.requestNo }}</td>
                            <td><a href="javascript:;" @click="fnRequestView(item.requestNo)">{{ item.title }}</a></td>
                            <td>{{ item.userFirstName }} {{ item.userLastName }}</td>
                            <td>
                                <span :class="['status-badge', getStatusClass(item.status)]">
                                    {{ getStatusLabel(item.status) }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 페이징 -->
                <div class="pagination">
                    <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                    <button v-for="page in totalPages" :key="page" @click="changePage(page)"
                        :class="{ active: currentPage === page }">
                        {{ page }}
                    </button>
                    <button @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
                </div>

                <!-- 글쓰기 버튼 -->
                <button v-if="sessionId !== ''" class="request-write-btn" @click="fnAdd">글쓰기</button>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </body>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    keyword: '',
                    sessionId: "${sessionId}",
                    currentPage: 1,        // 현재 페이지
                    pageSize: 10,          // 한 페이지당 게시글 수
                    totalPages: 1
                };
            },
            methods: {
                fnRequestList() {
                    const self = this;
                    const offset = (self.currentPage - 1) * self.pageSize;
                    $.ajax({
                        url: "/request/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            keyword: self.keyword,
                            page: self.currentPage,
                            pageSize: self.pageSize,
                            offset: offset
                        },
                        success: function (data) {
                            console.log(data);
                            self.list = data.requestList;
                            self.totalPages = data.totalPages || 1;
                        }
                    });
                },
                fnSearch() {
                    this.currentPage = 1;
                    this.fnRequestList();
                },
                changePage(page) {
                    if (page >= 1 && page <= this.totalPages) {
                        this.currentPage = page;
                        this.fnRequestList();
                    }
                },
                fnRequestView(requestNo) {
                    location.href = "/request/view.do?requestNo=" + requestNo;
                },
                fnAdd() {
                    location.href = "/request/add.do";
                },
                getStatusLabel(status) {
                    switch (status) {
                        case '0': return '답변 대기';
                        case '1': return '답변 중';
                        case '2': return '답변 완료';
                        default: return '-';
                    }
                },
                getStatusClass(status) {
                    switch (status) {
                        case '0': return 'status-waiting';
                        case '1': return 'status-progress';
                        case '2': return 'status-done';
                        default: return '';
                    }
                }
            },
            mounted() {
                this.fnRequestList();
            }
        });
        app.mount('#app');
    </script>

    </html>