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
					<star-rating :rating="review.rating" :read-only="true" :star-size="20" :increment="0.01" :border-width="5"
						:show-rating="false" :rounded-corners="true"></star-rating>
					<p>{{review.comment}}</p>
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
					tourNo: "${map.tourNo}",
					count: 0,
					isWishlisted: false,
					tourInfo: {},
					reviewsList: [],

					

					sessionId : "${sessionId}"

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
				
				fnAddedToCart() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId : self.sessionId


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
        }
					
          fnAddedToCart() {
            let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId : self.sessionId

					};
            
					$.ajax({
						url: "/basket/add.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if(data.result == "success") {
								alert("장바구니에 담겼습니다.");
							} else {
								alert("이미 담은 상품입니다!");
							}
						}
					});

				}

			},
			mounted() {
				let self = this;
				self.fnTourInfo();
			}
		});
		app.component('star-rating', VueStarRating.default)
		app.mount('#app');
	</script>