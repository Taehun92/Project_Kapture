<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-Change.js"></script>
	<title>요청게시판</title>
	<style>
        table, tr, th, td {
            border: 1px solid black;
            border-collapse: collapse;
            padding: 5px 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
	<div id="app">
        <table>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>요청상태</th>
            </tr>
            <tr v-for="item in list" :key="item.requestNo">
                <td>{{ item.requestNo }}</td>
                <td>
                    <a href="javascript:;" @click="fnRequestView(item.requestNo)">{{ item.title }}</a>
                </td>
                <td>{{ item.userFirstName }} {{ item.userLastName }}</td>
                <td>{{ getStatusLabel(item.status) }}</td>
            </tr>
        </table>
        <hr>
        <button v-if="sessionId !== ''" @click="fnAdd">글쓰기</button>
	</div>
    <jsp:include page="../common/footer.jsp" />
</body>

<script>
const app = Vue.createApp({
    data() {
        return {
            list: [],
            sessionId : "${sessionId}"

        };
    },
    methods: {
        fnRequestList() {
            var self = this;
            $.ajax({
                url: "/request/list.dox",
                type: "POST",
                dataType: "json",
                data: {},
                success: function(data) {
                    console.log(data);
                    self.list = data.requestList;
                }
            });
        },
        fnRequestView(requestNo) {
            pageChange("/request/view.do", { requestNo: requestNo });
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
        }
    },
    mounted() {
        var self = this;
        self.fnRequestList();
    }
});

app.mount('#app');
</script>