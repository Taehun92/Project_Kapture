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
		<script src="https://unpkg.com/@vuepic/vue-datepicker@latest"></script>
		<link rel="stylesheet" href="https://unpkg.com/@vuepic/vue-datepicker@latest/dist/main.css">
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

		  .datepicker {
			width: 100%;
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

			<div class="clickable-area" @click="showModal = true" v-if="!showModal">
            	<p>🛒</p>
        	</div>
        	<transition name="modal">
            	<div v-if="showModal" class="modal">
                	<span class="close-button" @click="showModal = false">닫기</span>
                	<h2>날짜를 선택해주세요.</h2>
					<div class="datepicker">
						<vue-date-picker v-model="date" multi-calendars model-auto range :min-date="new Date()"
						@input="params.startDate = _formatedDatepicker($event)" />
					</div>
					<div><button @click="selectDate">날짜선택완료</button></div>
            	</div>
        	</transition>
    	
			<transition name="modal">
				<div v-if="showSelectedModal" class="modal">
				  <span class="close-button" @click="showSelectedModal = false">닫기</span>
				  <h2>선택한 날짜</h2>
				  <!-- 필요에 따라 다른 날짜 정보도 추가 -->
				  	<div v-if="formattedDays.length">
						<p v-for="(day, index) in formattedDays" :key="index">
							{{ day }} 
							<button @click="reserve(day, '오전')">오전</button>
							<button @click="reserve(day, '오후')">오후</button>
							<button @click="reserve(day, '종일')">종일</button>
						</p>
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
					showSelectedModal: false,
					date: new Date(),
					tourTime : ""
				};
			},
			components: {
				VueDatePicker
			},

			watch: {
				date(date) {
			 		this.selectedDate = date;
			 	}
			},

			computed: {
			 	formattedDate() {
			 		if (!this.date) return ''; // 날짜가 없을 때 빈 문자열 반환
			 		const d = new Date(this.date);
		 			const yy = String(d.getFullYear()).slice(2); // 연도 두 자리
			 		const mm = String(d.getMonth() + 1).padStart(2, '0'); // 월 (0부터 시작하므로 +1 필요)
			 		const dd = String(d.getDate()).padStart(2, '0'); // 일
			 		return yy + '/' + mm + '/' + dd;
				},
				monthDay() {
					// date가 배열인 경우 첫 번째 날짜만 사용하거나 원하는 방식으로 처리 가능
					const d = Array.isArray(this.date) ? new Date(this.date[0]) : new Date(this.date);
					const month = d.getMonth() + 1;
					const day = d.getDate();
					return month + "월 " + day + "일";
				},
				formattedDays() {
					if (Array.isArray(this.date) && this.date.length === 2) {
					  const datesArray = this.getDatesInRange(this.date[0], this.date[1]);
					  return datesArray.map(date => this.formatDay(date));
					}
					return [];
				}
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
							self.tourTime = data.tourInfo.duration;
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
						sessionId: self.sessionId
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
							} else {
								alert("이미 담은 상품입니다!");
							}
						}
					});
				},

				// 모달창에서 날짜 선택 후 날짜 표시
				formatDate(date) {
					// 🟢 date가 유효한지 체크
					// 🟢 YY/MM/DD 형식으로 변환
					const yy = String(date.getFullYear()).slice(2); // '25'
					const mm = String(date.getMonth() + 1).padStart(2, '0'); // '03'
					const dd = String(date.getDate()).padStart(2, '0'); // '23'					
					return yy + '/' + mm + '/' + dd;
			   	},
			   	getDatesInRange(startDate, endDate) {
				   const dates = [];
				   let currentDate = new Date(startDate);
				   endDate = new Date(endDate);
				   while (currentDate <= endDate) {
					 dates.push(new Date(currentDate));
					 currentDate.setDate(currentDate.getDate() + 1);
				   	}
				   return dates;
				},
				 // 날짜를 "일"만 출력 (예: "25일")
				formatDay(date) {
				   const d = new Date(date);
				   return (d.getMonth() + 1) + "월 " + d.getDate() + "일";
			   	},

				selectDate() {
				// 첫 번째 모달 닫고, 두 번째 모달 열기
					this.showModal = false;
					this.showSelectedModal = true;
				},
				/*
				reserve(day, time) {
					// tourInfo.duration 에 저장된 값과 사용자가 선택한 시간이 일치하는지 확인
					if (this.tourInfo.duration === time) {
					  alert(day + " " + time + "에 예약되었습니다.");
					} else {
					  alert("이 상품은 " + this.tourInfo.duration + " 예약 상품입니다.");
					}
					// 예약 후 추가 동작이 필요하면 여기에 구현합니다.
				}
					*/

				reserve(day, time) {
					// tourInfo.date가 상품의 예약 날짜라고 가정합니다.
					if (this.tourInfo.tourDate && this.tourInfo.tourDate !== day) {
					  alert("선택한 날짜(" + day + ")가 상품의 날짜(" + this.tourInfo.tourDate + ")와 일치하지 않습니다.");
					  return;
					}
				  
					// 날짜가 일치하는 경우, 예약 가능한 시간(오전/오후/종일)도 비교합니다.
					if (this.tourInfo.duration === time) {
					  alert(day + " " + time + "에 예약되었습니다.");
					} else {
					  alert("이 상품은 " + this.tourInfo.duration + " 예약 상품입니다.");
					}
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