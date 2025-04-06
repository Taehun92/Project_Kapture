<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
	<title>첫번째 페이지</title>
</head>
<style>
    table, tr, th, td{
        border : 1px solid black;
        border-collapse: collapse;
        padding: 5px 10px; 
        text-align: center;
    } 
</style>
<body>
    <jsp:include page ="../common/header.jsp" />
	<div id="app"> 
        <table>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>조회수</th>
                <th>작성일</th>
            </tr>
            <tr v-for ="item in list">
                <td>{{item.boardNo}}</td>
                <td>
                   <a href="javascript:;" @click="fnView(item.boardNo)">{{item.title}}</a>
                </td>
                <td>{{item.userId}}</td>
                <td>{{item.cnt}}</td>
                <td>{{item.cdateTime}}</td>
            </tr>
        </table>
        <button @click="fnAdd">글쓰기</button>
		
	</div>
    <jsp:include page ="../common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                list : []
            };
        },
        methods: {
            fnBoardList(){
				var self = this;
				var nparmap = {	};
				$.ajax({
					url:"/board/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.list = data.list;
					}
				});
            },

            fnAdd : function(){
				location.href="/board/add.do"
            },

            fnView : function(boardNo){
                pageChange("/board/view.do", {boardNo : boardNo});

            }

        },
        mounted() {
            var self = this;
            self.fnBoardList();
        }
    });
    app.mount('#app');
</script>