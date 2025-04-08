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
	<script src="https://cdn.tailwindcss.com"></script>
	<title>상품 수정 페이지</title>
</head>
<style>
</style>
<body class="bg-gray-100 text-gray-800">
	<jsp:include page="../common/header.jsp" />
	<div id="app" class="max-w-7xl mx-auto flex flex-col md:flex-row p-6 gap-6">
		 <!-- 사이드 메뉴 -->
		 <div class="w-full md:w-1/4 bg-white rounded-lg shadow-md p-4">
			<ul class="space-y-2">
				<li><a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'guide-mypage.do' }" class="block p-2 rounded hover:bg-gray-100" href="/mypage/guide-mypage.do">가이드 정보수정</a></li>
				<li><a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'guide-schedule.do' }" class="block p-2 rounded hover:bg-gray-100" href="/mypage/guide-schedule.do">나의 스케줄</a></li>
				<li><a class="block p-2 rounded hover:bg-gray-100" href="/cs/qna.do">문의하기</a></li>
				<li><a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'guide-add.do' }" class="block p-2 rounded hover:bg-gray-100" href="/mypage/guide-add.do">여행상품 등록</a></li>
				<li><a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'guide-sales-list.do' }" class="block p-2 rounded hover:bg-gray-100" href="/mypage/guide-sales-list.do">판매내역</a></li>
			</ul>
		</div>

		<div class="w-full md:w-3/4 bg-white rounded-lg shadow-md p-6">
			<table class="w-full table-auto text-sm">
            	<tr class="border-b">
                	<th class="text-left py-2 pr-4 w-24">제목 :</th>
                	<td colspan="3"><input v-model="title" class="w-full border rounded px-3 py-2"/></td>
				</tr>
            	<tr class="border-b">
                	<th class="text-left py-2 pr-4">소요시간 :</th>
                	<td>
						<select v-model="duration" class="border rounded px-2 py-1">
							<option value="">:: 선택 ::</option>
							<option value="오전">오전</option>
							<option value="오후">오후</option>
							<option value="종일">종일</option>
					</td>
                	<th class="text-left py-2 pr-4">가격 :</th>
                	<td><input v-model="price" class="border rounded px-2 py-1 w-full"/></td>
				</tr>
				<tr class="border-b">
                	<th class="text-left py-2 pr-4">날짜 :</th>
                	<td><input  type=date v-model="tourDate" placeholder="2025-04-10" :min="minDate" class="border rounded px-2 py-1"/></td>
				</tr>
				<tr class="border-b">
                	<th class="text-left py-2 pr-4">시 :</th>
                	<td>
						<select @change="fnSelectGu()" v-model="siName" class="border rounded px-2 py-1 w-full">
							<option value="">:: 선택 ::</option>
							<template v-for="item in siList">
								<option :value="item.siName">{{item.siName}}</option>
							</template>
						</select>
					</td>

                	<th class="text-left py-2 pr-4">구 :</th>
                	<td><select v-model="guName" class="border rounded px-2 py-1 w-full">
						<option value="">:: 선택 ::</option>
						<template v-for="item in guList">
							<option :value="item.guName">{{item.guName}}</option>
						</template>
					</select></td>
            	</tr>
				<tr class="border-b">
                	<th class="text-left py-2 pr-4" >상위테마 :</th>
                	<td><select @change="fnSelectTheme()" v-model="themeParent" class="border rounded px-2 py-1 w-full">
						<option value="">:: 선택 ::</option>
						<template v-for="item in themeParentList">
							<option :value="item.themeName">{{item.themeName}}</option>
						</template>
					</select></td>
                	<th class="text-left py-2 pr-4">테마 :</th>
                	<td><select v-model="themeName" class="border rounded px-2 py-1 w-full">
						<option value="">:: 선택 ::</option>
						<template v-for="item in themeNameList">
							<option :value="item.themeName">{{item.themeName}}</option>
						</template>
					</select></td>
            	</tr>
            	<tr class="border-b">
                	<th class="text-left py-2 pr-4 align-top">내용 :</th>
                	<td colspan="3">
                    	<div id="editor"  class="border rounded w-full" style="width: 800px; height: 400px;"></div>
                	</td>
            	</tr>
        	</table>
        	<div class="mt-6 text-right" style="margin-top: 20px; padding-left: 80px;">
            	<button @click="fnSave" class="bg-blue-950 text-white px-6 py-2 rounded hover:bg-blue-700 transition">저장</button>
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
			   minDate : new Date().toISOString().split("T")[0],
			   // 썸네일 이미지
			   thumbnail : ""
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
					themeName : self.themeName,
					tourNo : self.tourNo,

					// 썸네일 이미지로 설정할 이미지 URL
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
								// 이미지 추가 없을 경우
								if(self.thumbnail != "") {
									// 본문에 이미지 존재 
									console.log('본문에 이미지 존재');
									self.fnSetThumbnail();
								} else {
									// 썸네일 초기화
									console.log('본문에 이미지 없음');
									self.fnResetThumbnail();
								}
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
							alert("이미지 추가되었습니다.");
							location.href = "/tours/tour-info.do?tourNo=" + self.tourNo;
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
					
					// 본문에 있는 이미지 URL을 추출하여 썸네일 설정
					if(self.getImageUrlsFromHtml(self.description).length > 0) {
						self.thumbnail = self.getImageUrlsFromHtml(self.description)[0];
					} else {
						self.thumbnail = ""; // 이미지가 없을 경우 썸네일 초기화
					}
					console.log('썸네일 : ', self.thumbnail);
				});
			},

			// 본문에 있는 이미지 URL을 추출하는 함수
			getImageUrlsFromHtml(html) {
				let div = document.createElement("div");
				div.innerHTML = html;
				let imgs = div.querySelectorAll("img");
				return Array.from(imgs).map(img => img.getAttribute("src"));
			},

			// 썸네일 초기화
			fnResetThumbnail() {
				let self = this;
				let nparmap = {
					tourNo: self.tourNo
				}
				$.ajax({
					url: "/mypage/resetThumbnail.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						location.href = "/tours/tour-info.do?tourNo=" + self.tourNo;
					}
				});
			},

			// 썸네일 설정
			fnSetThumbnail() {
				let self = this;
				let nparmap = {
					tourNo: self.tourNo,
					thumbnail: self.thumbnail
				}
				$.ajax({
					url: "/mypage/setThumbnail.dox",
					dataType: "json",
					type: "POST",
					data: nparmap,
					success: function (data) {
						console.log(data);
						location.href = "/tours/tour-info.do?tourNo=" + self.tourNo;
					}
				});
			},

			





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