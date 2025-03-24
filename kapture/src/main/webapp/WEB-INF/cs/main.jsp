<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <title>자주 묻는 질문</title>
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
            }

            .sidebar {
                width: 250px;
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
                padding: 20px;
            }

            select,
            input,
            button {
                padding: 10px;
                margin: 5px;
            }

            .category-container {
                cursor: pointer;
                font-weight: bold;
                background-color: #e0f7fa;
                padding: 12px;
                margin-bottom: 10px;
                border-radius: 8px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .plus-btn {
                font-size: 20px;
                transition: color 0.3s ease;
            }

            .category-content {
                background-color: #fff;
                padding: 10px;
                border-radius: 5px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 10px;
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
        <header>
            고객센터
        </header>

        <!-- Vue app 시작 -->
        <div id="app" class="main-layout">
            <!-- 사이드바 -->
            <div class="sidebar">
                <ul>
                    <li :class="{ active: activeMenu === 'notice' }" @click="goTo('notice')">공지사항</li>
                    <li :class="{ active: activeMenu === 'faq' }" @click="setActive('faq')">FAQ</li>
                    <li :class="{ active: activeMenu === 'inquiry' }" @click="goTo('inquiry')">QNA</li>
                </ul>
            </div>

            <!-- 메인 컨텐츠 -->
            <div class="content">
                <div>
                    <select v-model="searchOption">
                        <option value="all">:: 전체 ::</option>
                        <option value="category">카테고리</option>
                        <option value="question">질문</option>
                    </select>
                    <input v-model="keyword" @keyup.enter="fnMain" placeholder="검색어">
                    <button @click="fnMain">검색</button>
                </div>

                <!-- 질문 리스트 -->
                <div v-for="item in list" :key="item.category">
                    <div class="category-container" @click="toggleAnswer(item)">
                        <span>{{ item.category }} - {{ item.question }}</span>
                        <span class="plus-btn">
                            {{ item.isOpen ? '-' : '+' }}
                        </span>
                    </div>
                    <div v-if="item.isOpen" class="category-content">
                        <div>
                            답변: {{ item.answer }}
                        </div>
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
        <footer>
            ⓒ 2025 고객센터. All rights reserved.
        </footer>

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
                        activeMenu: 'faq'
                    };
                },
                methods: {
                    fnMain() {
                        let self = this;
                        let nparmap = {
                            keyword: self.keyword,
                            searchOption: self.searchOption,
                            pageSize: self.pageSize,
                            page: (self.page - 1) * self.pageSize
                        };
                        $.ajax({
                            url: "/cs/main.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
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
                        this.fnMain();
                    },
                    toggleAnswer(item) {
                        item.isOpen = !item.isOpen;
                    },
                    setActive(menu) {
                        this.activeMenu = menu;
                    },

                    goTo(menu) {
                        if (menu === 'notice') {
                            window.location.href = '/cs/notice.do';
                        } else if (menu === 'inquiry') {
                            window.location.href = '/cs/qna.do';
                        }
                    
                }
            },
                mounted() {
                this.fnMain();
            }
        });

            app.mount('#app');
        </script>
    </body>

    </html>