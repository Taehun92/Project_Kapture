<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="/js/page-Change.js"></script>
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

		.reviews {
			padding: 10px;
			background: #fff;
			border-top: 2px solid #f00;
		}

		.review-score {
			font-size: 18px;
			font-weight: bold;
		}

		.stars {
			color: gold;
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

		.user-review {
			margin-top: 10px;
			font-size: 14px;
		}

		.profile-img {
			width: 40px;
			/* 가로 크기 */
			height: 40px;
			/* 세로 크기 */
			border-radius: 50%;
			/* 동그랗게 */
			object-fit: cover;
			/* 이미지가 잘리지 않도록 */
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
				<div class="review-score">이용후기
					<div>
						<span class="stars">★★★★★</span> 4.9/5
					</div>
				</div>
				<hr style="margin-bottom: 20px;">
				<!-- <template> v-for="review in reviewsList" -->
					<div>
						<img src="../img/화면 캡처 2025-03-22 152559.png" class="profile-img">
						<span>강 재 석</span>
						<div>3월 22일</div>
						<!-- <span>{{review.userFirstName}}</span> -->
						 <!-- <div>{{review.rUpdatedAt}}</div> -->
					</div>
					<div class="tags">
						<span class="tag">#불친절해요</span>
						<span class="tag">#비합리적인 가격</span>
						<span class="tag">#안재밌어요</span>
					</div>
					<div class="user-review">
						⭐☆☆☆☆ 나 강재석인데 이 상품 별로임 대표 나오라 그래

					</div>
				</template>
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
					if(this.count<4) this.count++;
				},
				decrease() {
					if (this.count > 0) this.count--;
				},
				toggleWishlist() {
					this.isWishlisted = !this.isWishlisted;
				},
				fnAddedToCart() {

				}
			},
			mounted() {
				let self = this;
				self.fnTourInfo();
			}
		});
		app.mount('#app');
	</script>