<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="/js/page-change.js"></script>
	<title>요청게시판</title>
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
                <th>요청상태</th>
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
            fnRequestList(){
				var self = this;
				var nparmap = {	
                    
                };
				$.ajax({
					url:"/request/list.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.list = data.list;
					}
				});
            }

        },
        mounted() {
            var self = this;
            self.fnRequestList();
        }
    });
    app.mount('#app');
</script>