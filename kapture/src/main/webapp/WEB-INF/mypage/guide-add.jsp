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
</style>
<body>
	<jsp:include page="../common/header.jsp" />
	<div id="app">
		<table>
            <tr>
                <th>제목 :</th>
                <td colspan="3"><input v-model="title" /></td>
            </tr>
            <tr>
                <th>소요시간 :</th>
                <td><input v-model="duration" placeholder="오전, 오후, 종일" /></td>
                <th>가격 :</th>
                <td><input v-model="price" /></td>
			</tr>
			<tr>
                <th>날짜 :</th>
                <td><input v-model="tourDate" placeholder="2025-04-10"/></td>
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
        <div style="margin-top: 20px;">
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
				themeNameList : []

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
				$.ajax({
					url:"/mypage/guide-add.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) {
						console.log(data);
						console.log(self.sessionId);
						console.log(self.siName);
						console.log(self.guName);
						alert("등록되었습니다.");
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
			var self = this;
			var quill = new Quill('#editor', {
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
        }
    });
    app.mount('#app');
</script>