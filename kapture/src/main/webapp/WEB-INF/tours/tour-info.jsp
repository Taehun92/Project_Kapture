<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
		<script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
			integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
		<link rel="stylesheet" href="../../css/tourInfo.css">
		<title>상품 상세페이지</title>
	</head>

	<body>
		<jsp:include page="../common/header.jsp" />
		<div id="app">
			<!-- 기존 컨텐츠 영역 -->
			<div class="top-section">
				<div class="thumbnail">
					<img class="img-thumbnail" :src="tourInfo.filePath">
				</div>
				<div class="info">
					<div class="title">{{ tourInfo.title }}</div>
					<div class="guide-info">{{ tourInfo.experience }}</div>
					<div class="actions">
						<button @click="decrease">-</button>
						<span>인원수 {{ count }}명</span>
						<button @click="increase">+</button>
						<button @click="toggleWishlist">{{ isWishlisted ? "❤️ 찜 취소" : "💕 찜" }}</button>
						<button @click="fnAddedToCart">🛒 장바구니 담기</button>
					</div>
				</div>
			</div>

			<div class="contents" v-html="tourInfo.description"></div>

			<div class="reviews">
				<div class="review-score">
					이용후기 <star-rating :rating="getReviewAvg()" :read-only="true" :increment="0.01"
						:show-rating="false" />
					<span>{{ getReviewAvg() }} / 5</span>
				</div>
				<div class="rating-bars">
					<div class="rating-bar" v-for="n in 5" :key="n">
						<span>{{ n }}점</span>
						<div class="progress-bar">
							<div class="fill" :style="{ width: getReviewPercentage(n) + '%' }"></div>
						</div>
						<span>{{ getReviewCount(n) }}명</span>
					</div>
				</div>
				<div class="user-review" v-for="review in reviewsList">
					<div><strong>{{review.userFirstName}} {{review.userLastName}}</strong></div>
					<star-rating :rating="review.rating" :read-only="true" :show-rating="false" :star-size="20" />
					<p>{{ review.comment }}</p>
				</div>
			</div>

			<!-- 장바구니 트리거 바 -->
            <div class="bottom-cart-bar" v-if="!showModal">
                <div class="clickable-area" @click="showModal = true">
                    🛒 장바구니 열기
                </div>
            </div>
            <!-- 하단 모달 창 -->
            <div class="bottom-cart-modal" :class="{ show: showModal }">
                <button class="close-button" @click="handleCartClose">닫기</button>
                <h2 class="modal-title">🗓️ 일정 확인</h2>

                <table class="modal-table">
                    <thead>
                        <tr>
                            <th style="width: 15%">날짜</th>
                            <th style="width: 10%">시간</th>
                            <th style="width: 30%">상품 제목</th>
                            <th style="width: 15%">인원 수</th>
                            <th style="width: 20%">금액</th>
                            <th style="width: 5%">삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template v-for="n in 7" :key="'day-' + n">
                            <tr v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')">
                                <td>{{ formatDate(addDays(minDate, n - 1)) }}</td>
                                <td>종일</td>
                                <td>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').title }}</td>
                                <td>
                                    <div class="item-controls">
                                        <button
                                            @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), -1)"
                                            :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').numPeople <= 1">
                                            - </button>
                                        <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                            '종일').numPeople}}명</span>
                                        <button
                                            @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), 1)"
                                            :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').numPeople >= 4">
                                            + </button>
                                    </div>
                                </td>
                                <td>
                                    \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'종일').price) *
                                    Number(getCartItemByDateAndTime(addDays(minDate, n -
                                    1),'종일').numPeople)).toLocaleString() }}원
                                </td>
                                <td>
                                    <button
                                        @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'))"
                                        class="delete-btn">🗑️</button>
                                </td>
                            </tr>

                            <template v-else>
                                <!-- 오전 -->
                                <tr>
                                    <td rowspan="2">{{ formatDate(addDays(minDate, n - 1)) }}</td>
                                    <td>오전</td>
                                    <template v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')">
                                        <td>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').title }}</td>
                                        <td>
                                            <div class="item-controls">
                                                <button
                                                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), -1)"
                                                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').numPeople <= 1">
                                                    - </button>
                                                <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                    '오전').numPeople}}명</span>
                                                <button
                                                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), 1)"
                                                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').numPeople >= 4">
                                                    + </button>
                                            </div>
                                        </td>
                                        <td>
                                            \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오전').price) *
                                            Number(getCartItemByDateAndTime(addDays(minDate, n -
                                            1),'오전').numPeople)).toLocaleString() }}원
                                        </td>
                                        <td>
                                            <button
                                                @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'))"
                                                class="delete-btn">🗑️</button>
                                        </td>
                                    </template>
                                    <template v-else>
                                        <td> </td>
                                        <td> </td>
                                        <td> </td>
                                        <td> </td>
                                    </template>
                                </tr>

                                <!-- 오후 -->
                                <tr>
                                    <td>오후</td>
                                    <template v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')">
                                        <td>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').title }}</td>
                                        <td>
                                            <div class="item-controls">
                                                <button
                                                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), -1)"
                                                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').numPeople <= 1">
                                                    - </button>
                                                <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                    '오후').numPeople}}명</span>
                                                <button
                                                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), 1)"
                                                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').numPeople >= 4">
                                                    + </button>
                                            </div>
                                        </td>
                                        <td>
                                            \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오후').price) *
                                            Number(getCartItemByDateAndTime(addDays(minDate, n -
                                            1),'오후').numPeople)).toLocaleString() }}원
                                        </td>
                                        <td>
                                            <button
                                                @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'))"
                                                class="delete-btn">🗑️</button>
                                        </td>
                                    </template>
                                    <template v-else>
                                        <td> </td>
                                        <td> </td>
                                        <td> </td>
                                        <td> </td>
                                    </template>
                                </tr>
                            </template>
                        </template>
                    </tbody>
                </table>

                <div class="total-price">
                    💰 최종 금액: <strong>{{ getTotalPrice().toLocaleString() }}</strong> 원
                </div>

                <button class="confirm-btn" @click="fnPay">결제</button>
            </div>
		</div>
	</body>

	</html>
	<script>
		const app = Vue.createApp({
			data() {
				return {
					tourNo: "",
					count: 0,
					isWishlisted: false,
					tourInfo: {},
					reviewsList: [],
					sessionId: "${sessionId}",
					showModal: false,
					date: new Date(),
					showCartButton: false,
					tourDate: null,
					dateList: [],
					minDate: null,
					maxDate: null,

					cartList: [],


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
					console.log('인원수 : ', this.count);
				},
				decrease() {
					if (this.count > 0) this.count--;
					console.log('인원수 : ', this.count);
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
					return parseFloat((total / this.reviewsList.length).toFixed(1));
				},

				fnAddedToCart() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
						sessionId: self.sessionId,
						count: self.count
					};
					self.fnGetMinTourDate();
					self.fnGetMaxTourDate();


					if (self.count <= 0) {
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

					if (!self.sessionId) {
						alert('로그인이 필요합니다.');
						location.href = '/login.do'
						return;
					}

					let existingItem = self.cartList.find(item =>
						item.tourNo == self.tourNo &&
						self.formatDate(new Date(item.tourDate)) === self.formatDate(new Date(self.tourInfo.tourDate)) &&
						item.duration === self.tourInfo.duration
					);

					console.log('existingItem : ', existingItem);


					if (existingItem) {
						if (existingItem.numPeople != self.count) {
							$.ajax({
								url: "/basket/update.dox",
								dataType: "json",
								type: "POST",
								data: {
									basketNo: existingItem.basketNo,  // 기존 항목의 고유 ID
									count: self.count
								},
								success: function (data) {
									alert('인원수가 변경되었습니다.');
									localStorage.setItem("basketChanged", Date.now());
									self.fnGetCart();
									self.fnGetMinTourDate();
									self.fnGetMaxTourDate();
									self.fnGetTourDateList();
									self.fnGetBasketList();
									self.fnGetBasket();
									
								}
							});
							return;
						} else {
							alert("이미 담은 상품입니다!");
							return;
						}
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
								location.reload();
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
							if (data.count > 0) {

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
							console.log('fnGetMinTourDate 호출', data);
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
							console.log('fnGetMaxTourDate 호출', data);
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
					if (!date) return '';
					const year = date.getFullYear();
					const month = (date.getMonth() + 1).toString().padStart(2, '0');
					const day = date.getDate().toString().padStart(2, '0');
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
						sessionId: self.sessionId
					};
					$.ajax({
						url: "/basket/getCount.dox",
						type: "POST",
						data: nparmap,
						dataType: "json",
						success: function (data) {
							console.log(data);
							if (data.count > 0) {
								self.showCartButton = true;
							}

						}
					});
				},
				getCartItemByDateAndTime(date, time) {
					const formattedDate = this.formatDate(date);
					return this.cartList.find(item =>
						this.formatDate(new Date(item.tourDate)) === formattedDate &&
						item.duration === time
					) || null;
				},

				changePeople(item, diff) {
                    const self = this;
                    const index = self.cartList.findIndex(i => i.basketNo === item.basketNo);

                    if (index !== -1) {
                        // 반드시 숫자로 변환해서 연산
                        const current = Number(self.cartList[index].numPeople);
                        const newCount = current + diff;
                        self.cartList[index].numPeople = newCount < 1 ? 1 : newCount;
                    }
                },

				// 최종 금액 계산 메서드
                getTotalPrice() {
                    return this.cartList.reduce((total, item) => total + Number(item.price) * Number(item.numPeople), 0);
                },

                deleteFromCart(item) {
                    const self = this;
                    if (!item || !item.basketNo) return;
                    if (confirm("이 항목을 장바구니에서 삭제할까요?")) {
                        $.ajax({
                            url: "/payment/removeBasket.dox",
                            type: "POST",
                            data: { basketNo: item.basketNo },
                            dataType: "json",
                            success: function (data) {
                                if (data.result === "success") {
                                    alert("삭제되었습니다.");
                                    localStorage.setItem("basketChanged", Date.now());
                                    self.fnGetBasketList();  // 장바구니 목록 갱신
                                    self.fnGetBasket();      // 아이콘 등 상태 갱신
                                    self.fnGetMinTourDate(); // 날짜 갱신
                                    self.fnGetMaxTourDate();
                                    location.reload();
                                }
                            }
                        });
                    }
                },

                handleCartClose() {
                    let self = this;
                    self.showModal = false;

                    // 모든 장바구니 항목 업데이트
                    let updatedCartList = self.cartList.map(item => ({
                        basketNo: item.basketNo,
                        count: item.numPeople
                    }));
                    $.ajax({
                        url: "/basket/updateList.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ cartList: updatedCartList }),
                        success: function (data) {
                            console.log("장바구니 업데이트 완료", data);
                            localStorage.setItem("basketChanged", Date.now());
                        },
                        error: function (err) {
                            console.error("장바구니 업데이트 실패", err);
                        }
                    });
                },

                fnPay(){
                    this.handleCartClose();
                    location.href="/payment.do"
                }


			},
			mounted() {
				let self = this;
				const params = new URLSearchParams(window.location.search);
				self.tourNo = params.get("tourNo") || "";
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