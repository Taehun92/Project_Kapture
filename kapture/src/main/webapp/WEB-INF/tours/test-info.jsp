<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-Change.js"></script>
		<script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>

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
			background: #ccc;
			display: flex;
			align-items: center;
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
			width: 800px;
			height: 800px;
			max-height: 800px;
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


	</style>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app" class="container">
			<div class="top-section">
				<div class="thumbnail"><img src="tourInfo.filePath"></div>
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
					tourDate : null
					
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

						}
					});
				},
				increase() {
					if (this.count < 4) this.count++;
				},
				decrease() {
					if (this.count > 0) this.count--;
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
						
					};

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
								self.fnGetTourDate();
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
							console.log(data);
							if(data.count > 0) {
								console.log('카트에 존재');
								self.showCartButton = true;
							} else {
								console.log('카트에 존재 x');
								
							}
						}
					});
				},
				fnGetTourDate() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						
					};

					$.ajax({
						url: "/basket/getTourDate.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							self.tourDate = data.date;
							console.log(self.tourDate);
							if (data.tourDate) {
								// "4월 15, 2025" 형식의 날짜를 Date 객체로 변환
								const parts = data.tourDate.split(' ');
								const month = parts[0].replace('월', '');
								const day = parseInt(parts[1].replace(',', ''), 10);
								const year = parseInt(parts[2], 10);
	
								// 월은 0부터 시작하므로 1을 빼줍니다.
								const monthIndex = parseInt(month, 10) - 1;
								const dateObj = new Date(year, monthIndex, day);
								self.cartTourDate = dateObj;

								console.log(cartTourDate);
								console.log(day);
								console.log(month);
								console.log(monthIndex);
							}
						}
					});
				},


			},
			mounted() {
				let self = this;
				self.fnTourInfo();
				self.fnGetCart();
				self.fnGetTourDate();
			}
		});
		app.component('star-rating', VueStarRating.default)
		app.mount('#app');
	</script>