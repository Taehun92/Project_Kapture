<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>kapture | 약관 및 정책</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        #app {
            display: flex;
            min-height: 80vh;
        }
        .sidebar {
            width: 250px;
            background-color: #f4f4f4;
            border-right: 1px solid #ddd;
            padding: 20px;
            box-sizing: border-box;
        }
        .sidebar h2 {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 20px;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            padding: 10px;
            cursor: pointer;
            color: #555;
            transition: background-color 0.3s;
        }
        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #e91e63;
            color: white;
            border-radius: 5px;
        }
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        .content h3 {
            color: #e91e63;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div id="app">
        <div class="sidebar">
            <h2>약관 및 정책</h2>
            <ul>
                <li
                    v-for="(menu, index) in menus"
                    :key="index"
                    :class="{ active: selectedIndex === index }"
                    @click="selectMenu(index)">
                    {{ menu.title }}
                </li>
            </ul>
        </div>
        <div class="content">
            <!-- <h3>{{ menus[selectedIndex].title }}</h3> -->
            <div v-html="htmlContent"></div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            selectedIndex: 0,
            htmlContent: '',
            menus: [
                { title: '개인정보 처리방침', file: 'terms_privacy.html' },
                { title: '이용약관', file: 'terms_use.html' },
                { title: '마케팅 정보 수신 동의', file: 'terms_marketing.html' }
            ]
        };
    },
    mounted() {
        this.loadHtml(this.menus[this.selectedIndex].file);
    },
    methods: {
        selectMenu(index) {
            this.selectedIndex = index;
            this.loadHtml(this.menus[index].file);
        },
        loadHtml(fileName) {
            fetch('/html/' + fileName)
                .then(res => res.text())
                .then(html => {
                    this.htmlContent = html;
                })
                .catch(() => {
                    this.htmlContent = '<p>⚠️ 약관을 불러오는 데 실패했습니다.</p>';
                });
        }
    }
});
app.mount('#app');
</script>