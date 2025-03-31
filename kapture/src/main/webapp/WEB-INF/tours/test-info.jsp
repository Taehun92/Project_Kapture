<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-Change.js"></script>
		<script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
		<title>상품 상세페이지</title>
	</head>
	<style>
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
			font-family: Arial, sans-serif;
		}

		.container {
			width: 80%;
			margin: 20px auto;
			display: flex;
			flex-direction: column;
			gap: 10px;
		}

		.top-section {
			display: flex;
			gap: 10px;
		}

		.thumbnail {
			width: 40%;
			height: 150px;
			display: flex;
			justify-content: center;
			font-size: 16px;
		}

		.info {
			width: 60%;
			display: flex;
			flex-direction: column;
			gap: 10px;
		}

		.title {
			font-size: 20px;
			font-weight: bold;
			text-align: center;
			padding: 10px;
			background: #eee;
		}

		.guide-info {
			text-align: center;
			padding: 10px;
			background: #ddd;
		}

		.actions {
			display: flex;
			justify-content: space-between;
			padding: 10px;
			background: #f1f1f1;
		}

		.contents {
			width: 100%;
			height: 200px;
			background: #ddd;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 18px;
		}

		.tags {
			margin-top: 5px;
			display: flex;
			gap: 5px;
		}

		.tag {
			font-size: 12px;
			padding: 3px 6px;
			background: #ddd;
			border-radius: 5px;
		}

		.reviews {
			padding: 15px;
			background: #fff;
			border-top: 2px solid #f00;
		}

		.review-score {
			font-size: 18px;
			font-weight: bold;
			margin-bottom: 10px;
		}

		.stars {
			color: gold;
		}

		.user-review {
			padding: 10px 0;
			border-bottom: 1px solid #ddd;
		}

		.profile-img {
			width: 40px;
			height: 40px;
			border-radius: 50%;
			object-fit: cover;
			margin-right: 10px;
		}

		.rating-bars {
			margin: 10px 0;
		}

		.rating-bar {
			display: flex;
			align-items: center;
			gap: 10px;
			font-size: 14px;
			margin-bottom: 5px;
		}

		.progress-bar {
			flex: 1;
			height: 8px;
			background: #ddd;
			border-radius: 5px;
			overflow: hidden;
		}

		.fill {
			height: 100%;
			background: #ffa500;
		}

		.clickable-area {
			width: 50px;
			height: 150px;
			margin-left: auto;
			margin-right: 0;
			margin-top: 20px;
			background-color: #f0f0f0;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			cursor: pointer;
			position: fixed;
			top: 50%;
			right: 0;
			transform: translateY(-50%);
			overflow: hidden;
			z-index: 1001;
		  }
		  
		  .modal {
			background-color: lightblue;
			padding: 20px;
			overflow: hidden;
			position: fixed;
			top: 50%;
			left: 50%;
			transform: translate(-50%, -50%);
			width: 1200px;
			height: 900px;
			max-height: 900px;
			z-index: 1000;
			display: flex;
			flex-direction: column;
			border: 1px solid #ccc;
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
			align-items: center;
			justify-content: flex-start;
		  }
		  
		  .modal-enter-from {
			opacity: 0;
			transform: translateX(100%);
		  }
		  
		  .modal-enter-active {
			transition: opacity 0.3s ease-out, transform 0.3s ease-out;
		  }
		  
		  .modal-enter-to {
			opacity: 1;
			transform: translateX(0%);
		  }
		  
		  .modal-leave-from {
			opacity: 1;
			transform: translateX(0%);
		  }
		  
		  .modal-leave-active {
			transition: opacity 0.2s ease-in, transform 0.2s ease-in;
		  }
		  
		  .modal-leave-to {
			opacity: 0;
			transform: translateX(100%);
		  }
		  
		  .close-button {
			position: absolute;
			top: 10px;
			right: 10px;
			cursor: pointer;
			padding: 5px;
			background-color: #ddd;
			border-radius: 5px;
		  }

		  .black-box {
			background-color: black;
			color: white;
			padding: 10px;
			text-align: center;
			border: 1px solid #000;
			border-radius: 5px;
		}
		
		.white-box {
			background-color: white;
			color: black;
			padding: 10px;
			text-align: center;
			border: 1px solid #ccc;
			border-radius: 5px;
		}

		table {
			width: 100%; /* 테이블 너비를 100%로 설정 */
			max-width: 1200px; /* 최대 너비를 1200px로 제한 */
			margin: 20px auto; /* 테이블을 가운데 정렬 */
			border-collapse: collapse; /* 테이블 경계선 병합 */
			font-size: 16px; /* 글자 크기 조정 */
		}
		
		th, td {
			padding: 15px; /* 셀 안쪽 여백 */
			text-align: center; /* 텍스트 가운데 정렬 */
			border: 1px solid #ccc; /* 셀 경계선 */
		}
		
		th {
			background-color: #f4f4f4; /* 헤더 배경색 */
			font-weight: bold; /* 헤더 글자 굵게 */
		}
		
		td {
			background-color: #fff; /* 셀 배경색 */
		}



	</style>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<div class="top-section">
				<div class="thumbnail">
					<img class="img-thumbnail" :src="tourInfo.filePath">
				</div>
				<div class="info">
					<div class="title">{{ tourInfo.title }}</div>
					<div class="guide-info">{{tourInfo.experience}}</div>
					<div class="actions">
						<button @click="decrease">-</button>
						<span>인원수 {{ count }}명</span>
						<button @click="increase">+</button>
						<button @click="toggleWishlist">{{ isWishlisted ? "❤️ 찜 취소" : "🤍 찜" }}</button>
						<button @click="fnAddedToCart">🛒 장바구니 담기</button>
					</div>
				</div>
			</div>
			<div class="contents">{{tourInfo.description}}</div>

			<div class="reviews">
				<div class="review-score">
					이용후기 <star-rating :rating="getReviewAvg()" :read-only="true" :increment="0.01" :border-width="5"
						:show-rating="false" :rounded-corners="true"></star-rating>
					<span> {{getReviewAvg()}} / 5</span>
				</div>

				<!-- 점수별 게이지바 -->
				<div class="rating-bars">
					<div v-for="n in 5" :key="n" class="rating-bar">
						<span>{{ n }}점</span>
						<div class="progress-bar">
							<div class="fill" :style="{ width: getReviewPercentage(n) + '%' }"></div>
						</div>
						<span>{{ getReviewCount(n) }}명</span>
					</div>
				</div>

				<!-- 개별 리뷰 목록 -->
				<div v-for="review in reviewsList" class="user-review">
					<div>
						<span>{{review.userFirstName}} {{review.userLastName}}</span>
					</div>
					<star-rating :rating="review.rating" :read-only="true" :star-size="20" :increment="0.01"
						:border-width="5" :show-rating="false" :rounded-corners="true"></star-rating>
					<p>{{review.comment}}</p>
				</div>
			</div>
			<div v-if="showCartButton">
				<div class="clickable-area" @click="showModal = true" v-if="!showModal">
					<p>🛒</p>
				</div>
			</div>
        	<transition name="modal">
            	<div v-if="showModal" class="modal">
                	<span class="close-button" @click="showModal = false">닫기</span>
                	<h2>일정</h2>
					<div>
						<table>
							<tr v-for="n in 7" :key="n">
								<td>{{ formatDate(addDays(minDate, n-1))  }}</td>
								<td>
									<div
										v-bind:class="{
											'black-box': cartList.some(item => formatDate(addDays(minDate, n - 1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오전'|| item.duration === '종일') ),
											'white-box': !cartList.some(item => formatDate(addDays(minDate, n - 1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오전' || item.duration === '종일'))
										}"
									>
										오전
									</div>
								</td>
								<td>
									<div
										v-bind:class="{
											'black-box': cartList.some(item => formatDate(addDays(minDate, n - 1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오후' || item.duration === '종일')),
											'white-box': !cartList.some(item => formatDate(addDays(minDate, n - 1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오후' || item.duration === '종일'))
										}"
									>
										오후
									</div>
								</td>
								<template v-for="item in getSortedCartList()">
									<td v-if="formatDate(addDays(minDate, n-1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오전' || item.duration === '종일')">
										오전 : {{ item.title }}
									</td>
									<td v-if="formatDate(addDays(minDate, n-1)) === formatDate(new Date(item.tourDate)) && (item.duration === '오후' || item.duration === '종일')">
										오후 : {{ item.title }}
									</td>
									<td v-if="formatDate(addDays(minDate, n-1)) === formatDate(new Date(item.tourDate))">
										인원 : {{ item.numPeople }}
									</td>
									<td v-if="formatDate(addDays(minDate, n-1)) === formatDate(new Date(item.tourDate))">
										금액 : {{ item.price }}
									</td>
								</template>
							</tr>
						</table>
						<div>
							최종금액 : {{ getTotalPrice().toLocaleString() }} 원
						</div>
						<button>결제</button>
					</div>
            	</div>
        	</transition>
    	
		</div>
		<jsp:include page="../common/footer.jsp" />
	</body>
	

	</html>
	<script>
		const app = Vue.createApp({
			data() {
				return {
					tourNo: "${map.tourNo}",
					count: 0,
					isWishlisted: false,
					tourInfo: {},
					reviewsList: [],
					sessionId: "${sessionId}",
					showModal: false,
					date: new Date(),
					showCartButton : false,
					tourDate : null,
					dateList : [],
					minDate : null,
					maxDate : null,

					cartList : [],


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
							console.log(self.tourInfo);
							self.reviewsList = data.reviewsList;
							console.log(self.reviewsList);
							console.log('투어 날짜 : ', self.tourInfo.tourDate);
						}
					});
				},
				increase() {
					if (this.count < 4) this.count++;
					console.log('인원수 : ' , this.count);
				},
				decrease() {
					if (this.count > 0) this.count--;
					console.log('인원수 : ' , this.count);
				},
				toggleWishlist() {
					this.isWishlisted = !this.isWishlisted;
				},
				getReviewCount(star) {
					return this.reviewsList.filter(r => r.rating === star).length;
				},

				// 특정 별점의 비율을 계산 (전체 리뷰 대비 %)
				getReviewPercentage(star) {
					const total = this.reviewsList.length;
					if (total === 0) return 0;
					return (this.getReviewCount(star) / total) * 100;
				},
				getReviewAvg() {
					if (this.reviewsList.length === 0) return 0;
					const total = this.reviewsList.reduce((sum, rating) => sum + rating.rating, 0);
					return (total / this.reviewsList.length).toFixed(1);
				},

				fnAddedToCart() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						count : self.count
					};
					self.fnGetMinTourDate();
					self.fnGetMaxTourDate();
					

					if(self.count <= 0) {
						alert('인원수를 선택해주세요.');
						return;
					}

    				// 같은 날짜에 "종일" 상품이 있는지 확인
    				const selectedDate = self.formatDate(new Date(self.tourInfo.tourDate));
    				const hasFullDay = self.cartList.some(item => 
        			self.formatDate(new Date(item.tourDate)) === selectedDate && item.duration === '종일');

    				// 같은 날짜에 "오전" 또는 "오후" 상품이 있는지 확인
    				const hasMorningOrAfternoon = self.cartList.some(item => 
        			self.formatDate(new Date(item.tourDate)) === selectedDate && (item.duration === '오전' || item.duration === '오후'));

    				// "종일" 상품이 이미 있는 경우 "오전" 또는 "오후" 상품 추가 불가
    				if ((self.tourInfo.duration === '오전' || self.tourInfo.duration === '오후') && hasFullDay) {
        				alert('같은 날짜에 종일 상품이 이미 담겨 있어 오전 또는 오후 상품을 담을 수 없습니다.');
        				return;
    				}

    				// "오전" 또는 "오후" 상품이 이미 있는 경우 "종일" 상품 추가 불가
    				if (self.tourInfo.duration === '종일' && hasMorningOrAfternoon) {
        				alert('같은 날짜에 오전 또는 오후 상품이 이미 담겨 있어 종일 상품을 담을 수 없습니다.');
        				return;
    				}

					if (self.minDate) { // 장바구니에 이미 투어가 담겨있다면 날짜 비교
						const selectedDate = new Date(self.tourInfo.tourDate);
						const mindate = new Date(self.minDate);
						const maxdate = new Date(self.maxDate);
						const diffMin = Math.abs(Math.ceil((selectedDate - mindate) / (1000 * 60 * 60 * 24)));
						const diffMax = Math.abs(Math.ceil((selectedDate - maxdate) / (1000 * 60 * 60 * 24)));
						if (diffMax > 6 || diffMin > 6) {
							alert('장바구니에 담긴 투어와 6일 이상 차이납니다. 담을 수 없습니다.');
							return;
						}
					}

					if(!self.sessionId) {
						alert('로그인이 필요합니다.');
						location.href='/login.do'
						return;
					}

					$.ajax({
						url: "/basket/add.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result == "success") {
								alert("장바구니에 담겼습니다.");
								self.fnGetCart();
								self.fnGetMinTourDate();
								self.fnGetMaxTourDate();
								self.fnGetTourDateList();
								self.fnGetBasketList();
								self.fnGetBasket();
							} else {
								alert("이미 담은 상품입니다!");
							}
						}
					});
				},
				fnGetCart() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						
					};

					$.ajax({
						url: "/basket/get.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							if(data.count > 0) {
								
							} else {
								
							}
						}
					});
				},
				fnGetMinTourDate() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						
					};

					$.ajax({
						url: "/basket/getMinTourDate.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log('fnGetMinTourDate 호출' , data);
							if (data.minDate) {
								// "4월 15, 2025" 형식의 날짜를 Date 객체로 변환
								const parts = data.minDate.split(' ');
								const month = parts[0].replace('월', '');
								const day = parseInt(parts[1].replace(',', ''), 10);
								const year = parseInt(parts[2], 10);
	
								// 월은 0부터 시작하므로 1을 빼줍니다.
								const monthIndex = parseInt(month, 10) - 1;
								const dateObj = new Date(year, monthIndex, day);
								self.minDate = dateObj;
							}
						}
					});
				},

				fnGetMaxTourDate() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						
					};

					$.ajax({
						url: "/basket/getMaxTourDate.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log('fnGetMaxTourDate 호출' , data);
							if (data.maxDate) {
								// "4월 15, 2025" 형식의 날짜를 Date 객체로 변환
								const parts = data.maxDate.split(' ');
								const month = parts[0].replace('월', '');
								const day = parseInt(parts[1].replace(',', ''), 10);
								const year = parseInt(parts[2], 10);
	
								// 월은 0부터 시작하므로 1을 빼줍니다.
								const monthIndex = parseInt(month, 10) - 1;
								const dateObj = new Date(year, monthIndex, day);
								self.maxDate = dateObj;
							}
						}
					});
				},

				fnGetTourDateList() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						
					};

					$.ajax({
						url: "/basket/getTourDateList.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							self.dateList = data.dateList;
							console.log(self.dateList);
						}
					});
				},

				addDays(date, days) {
                    const newDate = new Date(date);
                    newDate.setDate(newDate.getDate() + days); // Use newDate here
                    return newDate;
                },
                formatDate(date) {
                    const year = date.getFullYear();
                    const month = String(date.getMonth() + 1).padStart(2, '0');
                    const day = String(date.getDate()).padStart(2, '0');
                    return year + '-' + month + '-' + day;
                },

				fnGetBasketList() {
					let self = this;
					let nparmap = {
						sessionId: self.sessionId,
					};

					$.ajax({
						url: "/basket/getBasketList.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							self.cartList = data.basketList;
							
						}
					});
				},
				// 최종 금액 계산 메서드
				getTotalPrice() {
					return this.cartList.reduce((total, item) => total + Number(item.price), 0);
				},

				getSortedCartList() {
					return this.cartList.slice().sort((a, b) => {
						if (a.duration === '오전' && b.duration !== '오전') return -1;
						if (a.duration !== '오전' && b.duration === '오전') return 1;
						return 0;
					});
				},

				fnGetBasket() {
					let self = this;
					let nparmap = {
						sessionId : self.sessionId
					};
					$.ajax({
						url: "/basket/getCount.dox",
						type: "POST",
						data: nparmap,
						dataType: "json",
						success: function(data) {
							console.log(data);
							if(data.count > 0) {
								self.showCartButton = true;
							}
							
						}
					});
				},
			

			},
			mounted() {
				let self = this;
				self.fnTourInfo();
				self.fnGetCart();
				self.fnGetMinTourDate();
				self.fnGetMaxTourDate();
				self.fnGetTourDateList();
				self.fnGetBasketList();
				self.fnGetBasket();
			}
		});
		app.component('star-rating', VueStarRating.default)
		app.mount('#app');
	</script>