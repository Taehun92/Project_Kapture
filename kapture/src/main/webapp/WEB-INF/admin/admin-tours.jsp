<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <title>관리자 페이지</title>
    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        /* 컨텐츠 영역 스타일 */
        .content {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 30px auto;
        }
        /* 제목 스타일 */
        h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #3498db;
            color: #fff;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp"></jsp:include>
    <div id="app">
        <div class="content">
            <h1>상품 관리 페이지</h1>
            <table>
                <tr>
                    <th>상품 번호</th>
                    <th>가이드 번호</th>
                    <th>제목</th>
                    <th>소요시간</th>
                    <th>가격</th>
                    <th>여행날짜</th>
                    <th>상세설명</th>
                </tr>
                <tr v-for="item in list">
                    <td>{{item.tourNo}}</td>
                    <td>{{item.guideNo}}</td>
                    <td>{{item.title}}</td>
                    <td>{{item.duration}}</td>
                    <td>{{item.price}}</td>
                    <td>{{item.tourDate}}</td>
                    <td>{{item.description}}</td>
                </tr>
            </table>
       </div>
    </div>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                list : [],

            };
        },
        methods: {
			fnGetTourList() {
				let self = this;
				let nparmap = {

                };
				$.ajax({
					url:"/tours/all.dox",
					dataType:"json",
					type : "POST",
					data : nparmap,
					success : function(data) {
                        console.log(data);
                        self.list = data.toursList;
					}
				});
			}

        },
        mounted() {
			let self = this;
            self.fnGetTourList();
        }
    });
    app.mount('#app');
</script>