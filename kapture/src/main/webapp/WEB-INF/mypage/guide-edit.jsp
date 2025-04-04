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
	<link rel="stylesheet" href="../../css/guideAdd.css">
	<title>첫번째 페이지</title>
</head>
<style>
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
					<a href="http://localhost:8080/cs/qna.do">
						문의하기
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'guide-add.do' }"
						href="http://localhost:8080/mypage/guide-add.do">
						여행상품 등록
					</a>
				</li>
				<li>
					<a :class="{ active: currentPage === 'guide-sales-list.do' }"
						href="http://localhost:8080/mypage/guide-sales-list.do">
						판매내역
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
               tourNo : "${map.tourNo}",
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
			   currentPage: "",
			   imgList: [],
			   themeNo : "",
			   themeParentNo : "",
			   
			  
            };
        },
        methods: {
			fnTourInfo() {
				let self = this;
				let nparmap = {
					tourNo: self.tourNo,
				};
				$.ajax({
					url: "/tours/tour-info.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.tourInfo = data.tourInfo;
						console.log('tourInfo : ',self.tourInfo);
						self.reviewsList = data.reviewsList;
						console.log(self.reviewsList);
						console.log('투어 날짜 : ', self.tourInfo.tourDate);

						self.title = data.tourInfo.title;
						self.duration = data.tourInfo.duration;
						self.price = data.tourInfo.price;
						self.tourDate = data.tourInfo.tourDate;
						self.siNo = data.tourInfo.siNo;
						self.guNo = data.tourInfo.guNo;
						self.themeNo = data.tourInfo.themeNo;
						self.themeParentNo = data.tourInfo.themeParentNo;
						self.description = data.tourInfo.description;
						

						self.fnGetSi();
						// self.fnGetGu();
						self.fnGetThemeParent();
						self.fnGetThemeName();
						self.tourDate = self.tourDate.split(" ")[0];
						console.log('투어 내용 : ',self.description);
						self.fnQuill();
						console.log('투어 내용 : ',self.description);
					}
				});
			},

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
					themeName : self.themeName,
					tourNo : self.tourNo,
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
					url:"/mypage/guide-update.dox",
					dataType:"json",
					type : "POST",
					data : nparmap,
					success : function(data) {
						if(data.result == 'success'){
							console.log('data : ', data);
							console.log(self.sessionId);
							console.log(self.siName);
							console.log(self.guName);
							console.log(self.imgList);
							console.log(self.description);
							alert("수정되었습니다.");

							if (self.imgList.length > 0) {
								self.fnUpdateImgList(self.tourNo);
							} else {
								location.href = "/tours/tour-info.do?tourNo=" + self.tourNo;
							}
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
						self.fnGetThemeName();
					}
				});
			},

			fnUpdateImgList(tourNo) {
				let self = this;
				let imageUrls = self.imgList.map(img => img.url);
				let nparmap = {
					tourNo: tourNo,
					imgList: JSON.stringify(imageUrls), // URL만 전송
        			thumbnailList: JSON.stringify(self.imgList) // 전체 데이터도 전송 (썸네일 구분용)


				};
				console.log('imgList : ', self.imgList);
				$.ajax({
					url: "/mypage/updateImg.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						if (data.result == 'success') {
							console.log('data : ', data);
							alert("이미지 등록되었습니다.");
							location.href = "/tours/list.do";
						}
					}
				})
			},

			fnGetSi() {
				let self = this;
				let nparmap = {
					siNo: self.siNo
				};
				$.ajax({
					url: "/common/getSi.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.siName = data.si.siName;
						self.fnSelectGu();
						self.fnGetGu();
						console.log('siName : ',self.siName);
					}
				});
				

			},
			
			fnGetGu() {
				let self = this;
				let nparmap = {
					guNo: self.guNo,
					siNo: self.siNo
				};
				$.ajax({
					url: "/common/getGu.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						self.guName = data.gu.guName;
						console.log('guName : ',self.guName);
					}
				});
			},

			fnGetThemeParent() {
				let self = this;
				let nparmap = {
					themeParentNo: self.themeParentNo
				};
				$.ajax({
					url: "/common/getThemeParent.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log('ThemeParentName : ', data);
						self.themeParent = data.themeParent.themeName;
						self.fnSelectTheme();
					}
				});
			},
			
			fnGetThemeName() {
				let self = this;
				let nparmap = {
					themeNo: self.themeNo
				};
				$.ajax({
					url: "/common/getTheme.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log('ThemeName : ', data);
						self.themeName = data.themeName.themeName;
					}
				});

			},
			fnQuill() {
				let self = this;
				let quill = new Quill('#editor', {
					theme: 'snow',
					modules: {
						toolbar: {
							container: [
								[{ 'header': [1, 2, 3, false] }],
								['bold', 'italic', 'underline'],
								[{ 'list': 'ordered' }, { 'list': 'bullet' }],
								['link', 'image'],
								[{ 'color': [] }, { 'background': [] }],
								[{ 'align': [] }],
								['clean']
							],
							handlers: {
								image: function () {
									let input = document.createElement('input');
									input.setAttribute('type', 'file');
									input.setAttribute('accept', 'image/*');
									input.click();
			
									input.onchange = async () => {
										let file = input.files[0];
										if (!file) return;
			
										let formData = new FormData();
										formData.append("file", file);
			
										try {
											let response = await fetch("/upload/image", {
												method: "POST",
												body: formData
											});
			
											let result = await response.json();
			
											if (result.success) {
												let range = quill.getSelection();
												quill.insertEmbed(range.index, 'image', result.imageUrl);
												
												let thumbnailFlag = self.imgList.length === 0 ? "Y" : "N";
	
												self.imgList.push({
													url: result.imageUrl,
													thumbnail: thumbnailFlag
												});
	
	
											} else {
												alert("이미지 업로드 실패");
											}
										} catch (error) {
											console.error("이미지 업로드 중 오류 발생:", error);
										}
									};
								}
							}
						}
					}
				});
	
				quill.root.innerHTML = self.description;
	
				quill.on('text-change', function () {
					self.description = quill.root.innerHTML;
				});
			}



        },
        mounted() {
            let self = this;
			
			if (this.sessionId == '') {
				alert("로그인 후 이용해주세요.");
				location.href = "http://localhost:8080/main.do";
			}
			if (this.sessionRole === 'TOURIST') {
				alert("가이드만 이용가능합니다.");
				location.href = "http://localhost:8080/main.do";
			}

			self.fnSelectSi();
			self.fnGetThemeParentList();

			self.fnTourInfo();

			
        }
    });
    app.mount('#app');
</script>