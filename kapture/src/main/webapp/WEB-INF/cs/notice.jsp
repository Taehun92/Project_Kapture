<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>공지사항</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f8f8;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background-color: #003366;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        footer {
            background-color: #003366;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: auto;
        }

        .main-layout {
            display: flex;
            flex: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            width: 100%;
        }

        .sidebar {
            width: 220px;
            background-color: #fff;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            padding: 15px;
            cursor: pointer;
            font-weight: bold;
            border-radius: 5px;
        }

        .sidebar ul li:hover {
            background-color: #e0f7fa;
        }

        .sidebar .active {
            color: red;
            font-weight: bold;
        }

        .content {
            flex: 1;
            padding: 20px 30px;
            width: 100%;
        }

        .search-box {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .search-box select,
        .search-box input,
        .search-box button {
            padding: 10px;
            margin: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .search-box input {
            width: 400px;
        }

        .notice-item {
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }

        .notice-title {
            font-weight: bold;
            font-size: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notice-content {
            margin-top: 10px;
            color: #333;
        }

        .pagination {
            text-align: center;
            margin-top: 20px;
        }

        .pagination a {
            margin: 0 8px;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
        }

        .pagination .bgcolor-gray {
            background-color: #003366;
            color: white;
        }
    </style>
</head>

<body>
    <!-- 헤더 -->
	<jsp:include page="../common/header.jsp" />

    <!-- Vue app 시작 -->
    <div id="app" class="main-layout">
        <!-- 사이드바 -->
        <div class="sidebar">
            <ul>
                <li :class="{ active: activeMenu === 'notice' }" @click="setActive('notice')">공지사항</li>
                <li :class="{ active: activeMenu === 'faq' }" @click="goTo('faq')">FAQ</li>
                <li :class="{ active: activeMenu === 'inquiry' }" @click="goTo('inquiry')">Q&A</li>
            </ul>
        </div>

        <!-- 메인 콘텐츠 -->
        <div class="content">
            <!-- 검색창 -->
            <div class="search-box">
                <select v-model="searchOption">
                    <option value="all">:: 전체 ::</option>
                    <option value="title">제목</option>
                    <option value="content">내용</option>
                </select>
                <input v-model="keyword" @keyup.enter="fnNotice" placeholder="검색어">
                <button @click="fnNotice">검색</button>
            </div>

            <!-- 공지 리스트 -->
            <div v-for="item in list" :key="item.noticeNo" class="notice-item" @click="toggleContent(item)">
                <div class="notice-title">
                    <span>{{ item.title }}</span>
                    <span>{{ item.isOpen ? '-' : '+' }}</span>
                </div>
                <div v-if="item.isOpen" class="notice-content">
                    {{ item.content }}
                </div>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination">
                <a v-for="num in index" @click="fnPage(num)">
                    <span v-if="page == num" class="bgcolor-gray">{{ num }}</span>
                    <span v-else>{{ num }}</span>
                </a>
            </div>
        </div>
    </div>

    <!-- 풋터 -->
	<jsp:include page="../common/footer.jsp" />

    <!-- Vue 앱 스크립트 -->
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    searchOption: "all",
                    keyword: "",
                    pageSize: 10,
                    index: 0,
                    page: 1,
                    activeMenu: 'notice'
                };
            },
            methods: {
                fnNotice() {
                    let self = this;
                    let params = {
                        keyword: self.keyword,
                        searchOption: self.searchOption,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };
                    $.ajax({
                        url: "/cs/notice.dox",
                        dataType: "json",
                        type: "POST",
                        data: params,
                        success: function (data) {
                            self.list = data.list.map(item => ({
                                ...item,
                                isOpen: false
                            }));
                            self.index = Math.ceil(data.count / self.pageSize);
                        }
                    });
                },
                fnPage(num) {
                    this.page = num;
                    this.fnNotice();
                },
                toggleContent(item) {
                    item.isOpen = !item.isOpen;
                },
                goTo(menu) {
                    if (menu === 'faq') {
                        window.location.href = '/cs/faq.do';
                    } else if (menu === 'inquiry') {
                        window.location.href = '/cs/qna.do';
                    }
                },
                setActive(menu) {
                    this.activeMenu = menu;
                }
            },
            mounted() {
                this.fnNotice();
            }
        });

        app.mount('#app');
    </script>
</body>

</html>
