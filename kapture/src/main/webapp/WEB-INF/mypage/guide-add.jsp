<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>
	<title>첫번째 페이지</title>
</head>
<style>
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

	.content-area {
		flex: 1;
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

</style>
<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app" class="container">

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
			</ul>
		</div>
		<div class="content-area">
			<table>
            	<tr>
                	<th>제목 :</th>
                	<td colspan="3"><input v-model="title" /></td>
				</tr>
            	<tr>
                	<th>소요시간 :</th>
                	<td>
						<select v-model="duration">
							<option value="">:: 선택 ::</option>
							<option value="오전">오전</option>
							<option value="오후">오후</option>
							<option value="종일">종일</option>
					</td>
                	<th>가격 :</th>
                	<td><input v-model="price" /></td>
				</tr>
				<tr>
                	<th>날짜 :</th>
                	<td><input  type=date v-model="tourDate" placeholder="2025-04-10"/></td>
                	<th>시 :</th>
                	<td>
						<select @change="fnSelectGu()" v-model="siName">
							<option value="">:: 선택 ::</option>
							<template v-for="item in siList">
								<option :value="item.siName">{{item.siName}}</option>
							</template>
						</select>
					</td>
				</tr>
				<tr>
                	<th>구 :</th>
                	<td><select v-model="guName">
						<option value="">:: 선택 ::</option>
						<template v-for="item in guList">
							<option :value="item.guName">{{item.guName}}</option>
						</template>
					</select></td>
            	</tr>
				<tr>
                	<th>상위테마 :</th>
                	<td><select @change="fnSelectTheme()" v-model="themeParent">
						<option value="">:: 선택 ::</option>
						<template v-for="item in themeParentList">
							<option :value="item.themeName">{{item.themeName}}</option>
						</template>
					</select></td>
                	<th>테마 :</th>
                	<td><select v-model="themeName">
						<option value="">:: 선택 ::</option>
						<template v-for="item in themeNameList">
							<option :value="item.themeName">{{item.themeName}}</option>
						</template>
					</select></td>
            	</tr>
            	<tr>
                	<th>내용 :</th>
                	<td colspan="3">
                    	<div id="editor" style="width: 800px; height: 400px;"></div>
                	</td>
            	</tr>
        	</table>
        	<div style="margin-top: 20px; padding-left: 80px;">
            	<button @click="fnSave">저장</button>
        	</div>
		</div>
	</div>
	<jsp:include page="../common/footer.jsp" />
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				title: "",
				description: "",
				duration: "",
				price: "",
				sessionId: "${sessionId}",
				tourDate: "",
				siNo: "",
				guNo: "",
				siList: [],
				guList: [],
				siName: "",
				guName: "",
				themeParentList: [],
				themeList: [],
				themeName : "",
				themeParent : "",
				themeNameList : [],
				currentPage: ""

            };
        },
        methods: {
            fnSave(){
				let self = this;
				let nparmap = {
					title: self.title,
					description: self.description,
					duration: self.duration,
					price: self.price,
					tourDate: self.tourDate,
					siName: self.siName,
					guName: self.guName,
					sessionId : self.sessionId,
					themeName : self.themeName
				};

				if(self.sessionId == ""){
					alert("로그인 후 이용 가능합니다.");
					location.href="/login.do";
					return;
				}

				if(self.title == ""){
					alert("제목을 입력하세요.");
					return;
				}

				if(self.duration == ""){
					alert("소요시간을 선택하세요.");
					return;
				}
				
				if(self.price == ""){
					alert("가격을 입력하세요.");
					return;
				}
				
				if(isNaN(self.price)){
					alert("가격은 숫자만 입력 가능합니다.");
					return;
				}
				
				if(self.price < 0){
					alert("가격은 0보다 커야합니다.");
					return;
				}
				
				if(self.tourDate == ""){
					alert("날짜를 입력하세요.");
					return;
				}
				
				if(self.siName == ""){
					alert("시를 선택하세요.");
					return;
				}
				
				if(self.guName == ""){
					alert("구를 선택하세요.");
					return;
				}

				if(self.themeParent == ""){
					alert("상위테마를 선택하세요.");
					return;
				}
				
				if(self.themeName == ""){
					alert("테마를 선택하세요.");
					return;
				}
				
				if(self.description == ""){
					alert("내용을 입력하세요.");
					return;
				}
				
				




				$.ajax({
					url:"/mypage/guide-add.dox",
					dataType:"json",
					type : "POST",
					data : nparmap,
					success : function(data) {
						if(data.result == 'success'){
						console.log(data);
						console.log(self.sessionId);
						console.log(self.siName);
						console.log(self.guName);
						alert("등록되었습니다.");
						}
					}
				});
            },

			fnSelectSi() {
				let self = this;
				let nparmap = {
					// siList:self.siList,
					// selectsi:self.selectsi
				};
				$.ajax({
					url: "/common/getSiList.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.siList = data.siList;
						
					}
				});
			},

			fnSelectGu() {
				let self = this;
				// if(){}
				let nparmap = {
					siName: self.siName
				};
				$.ajax({
					url: "/common/getGuList.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.guList = data.guList;
					}
				});
			},

			fnGetThemeParentList() {
				let self = this;
				let nparmap = {
				};
				$.ajax({
					url: "/common/getThemeParentList.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.themeParentList = data.themeParentList;
						
					}
				});
			},

			fnSelectTheme() {
				let self = this;
				let nparmap = {
					themeParent: self.themeParent
				};
				$.ajax({
					url: "/common/getThemeList.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.themeNameList = data.themeNameList;
					}
				});
			},
        },
        mounted() {
			let self = this;
			let quill = new Quill('#editor', {
				theme: 'snow',
				modules: {
					toolbar: [
						[{ 'header': [1, 2, 3, false] }],
						['bold', 'italic', 'underline'],
						[{ 'list': 'ordered' }, { 'list': 'bullet' }],
						['link', 'image'],
						[{ 'color': [] }, { 'background': [] }],
						[{ 'align': [] }],
						['clean']
					]
				}
			});
	
			quill.on('text-change', function() {
				self.description = quill.root.innerHTML;
			});

			self.fnSelectSi();
			self.fnGetThemeParentList();
			this.currentPage = window.location.pathname.split('/').pop();
        }
    });
    app.mount('#app');
</script>