<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title>상품 상세페이지</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js"
    integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
  <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
  <script src="../../js/page-Change.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 text-gray-800">
  <jsp:include page="../common/header.jsp" />

  <div id="app" class="max-w-5xl mx-auto p-4">
    <div class="flex flex-col md:flex-row gap-6 mb-8">
      <div class="flex-shrink-0 w-full md:w-1/2">
        <img class="rounded-xl shadow-md w-full h-auto object-cover" :src="tourInfo.filePath" />
      </div>
      <div class="flex flex-col justify-between w-full md:w-1/2 space-y-4">
        <h1 class="text-2xl font-bold">{{ tourInfo.title }}</h1>
        <p class="text-gray-600">{{ tourInfo.experience }}</p>
        <div class="flex items-center gap-4">
          <button class="bg-gray-200 px-3 py-1 rounded" @click="decrease">-</button>
          <span class="text-sm font-medium">인원수 {{ count }}명</span>
          <button class="bg-gray-200 px-3 py-1 rounded" @click="increase">+</button>
          <div class="ml-4 w-6 h-6 cursor-pointer" :class="{ 'bg-red-500': tourInfo?.isFavorite === 'Y' }" @click="toggleFavorite(tourInfo)"></div>
          <button class="ml-auto bg-blue-950 text-white px-4 py-2 rounded shadow hover:bg-blue-700" @click="fnAddedToCart">🛒 장바구니 담기</button>
        </div>
      </div>
    </div>

    <div class="prose max-w-none mb-8" v-html="tourInfo.description"></div>

    <div class="flex gap-4 mb-8" v-if="sessionId == tourInfo.userNo">
      <button class="px-4 py-2 bg-blue-950 text-white rounded hover:bg-blue-700" @click="fnEdit">수정</button>
      <button class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600" @click="fnDelete">삭제</button>
    </div>

    <div class="mb-12">
      <div class="flex items-center gap-2 mb-4">
        <span class="text-lg font-semibold">이용후기</span>
        <star-rating :rating="getReviewAvg()" :read-only="true" :increment="0.01" :show-rating="false" />
        <span>{{ getReviewAvg() }} / 5</span>
      </div>

      <div class="space-y-2 mb-6">
        <div v-for="n in 5" :key="n" class="flex items-center gap-2">
          <span class="w-8">{{ n }}점</span>
          <div class="flex-1 bg-gray-200 h-4 rounded">
            <div class="bg-yellow-400 h-4 rounded" :style="{ width: getReviewPercentage(n) + '%' }"></div>
          </div>
          <span class="w-10 text-right">{{ getReviewCount(n) }}명</span>
        </div>
      </div>

      <div class="space-y-4">
        <div class="p-4 bg-white rounded shadow" v-for="review in reviewsList" :key="review.id">
          <div class="font-semibold">{{review.userFirstName}} {{review.userLastName}}</div>
          <star-rating :rating="review.rating" :read-only="true" :show-rating="false" :star-size="20" />
          <p class="mt-2">{{ review.comment }}</p>
        </div>
      </div>
    </div>

    <div v-if="!showModal && cartList.length > 0" class="fixed bottom-0 left-0 right-0 bg-blue-500 text-white text-center py-3 cursor-pointer"
      @click="showModal = true">
      🛒 장바구니 열기
    </div>

    <div v-if="showModal" class="fixed bottom-0 left-0 right-0 max-h-[90vh] overflow-y-auto bg-white p-6 border-t shadow-lg z-50">
      <button class="ml-auto block text-gray-500 mb-4" @click="handleCartClose">닫기</button>
      <h2 class="text-xl font-bold mb-4">🗓️ 일정 확인</h2>

      <table class="w-full mb-4 text-sm table-fixed border">
        <thead>
          <tr class="bg-gray-100 text-gray-700">
            <th class="w-[15%] p-2 border">날짜</th>
            <th class="w-[10%] p-2 border">시간</th>
            <th class="w-[30%] p-2 border">상품 제목</th>
            <th class="w-[15%] p-2 border">인원 수</th>
            <th class="w-[20%] p-2 border">금액</th>
            <th class="w-[5%] p-2 border">삭제</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="n in 7" :key="'day-' + n">
            <!-- 종일 일정 -->
            <tr v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')" class="border-b">
              <td class="p-2 border">{{ formatDate(addDays(minDate, n - 1)) }}</td>
              <td class="p-2 border">종일</td>
              <td class="p-2 border">{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').title }}</td>
              <td class="p-2 border">
                <div class="flex items-center gap-2 justify-center">
                  <button class="bg-gray-200 px-2 py-1 rounded"
                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), -1)"
                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').numPeople <= 1">-</button>
                  <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').numPeople }}명</span>
                  <button class="bg-gray-200 px-2 py-1 rounded"
                    @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), 1)"
                    :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일').numPeople >= 4">+</button>
                </div>
              </td>
              <td class="p-2 border text-right">
                \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'종일').price) *
                Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'종일').numPeople)).toLocaleString() }}원
              </td>
              <td class="p-2 border text-center">
                <button @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'))"
                  class="text-red-500">🗑️</button>
              </td>
            </tr>

            <!-- 오전/오후 분리 -->
            <template v-else>
              <tr>
                <td class="p-2 border" rowspan="2">{{ formatDate(addDays(minDate, n - 1)) }}</td>

                <td class="p-2 border">오전</td>
                <template v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')">
                  <td class="p-2 border">{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').title }}</td>
                  <td class="p-2 border">
                    <div class="flex items-center gap-2 justify-center">
                      <button class="bg-gray-200 px-2 py-1 rounded"
                        @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), -1)"
                        :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').numPeople <= 1">-</button>
                      <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').numPeople }}명</span>
                      <button class="bg-gray-200 px-2 py-1 rounded"
                        @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), 1)"
                        :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전').numPeople >= 4">+</button>
                    </div>
                  </td>
                  <td class="p-2 border text-right">
                    \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오전').price) *
                    Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오전').numPeople)).toLocaleString() }}원
                  </td>
                  <td class="p-2 border text-center">
                    <button @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'))"
                      class="text-red-500">🗑️</button>
                  </td>
                </template>
                <template v-else>
                  <td class="p-2 border" colspan="4"></td>
                </template>
              </tr>

              <tr>
                <td class="p-2 border">오후</td>
                <template v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')">
                  <td class="p-2 border">{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').title }}</td>
                  <td class="p-2 border">
                    <div class="flex items-center gap-2 justify-center">
                      <button class="bg-gray-200 px-2 py-1 rounded"
                        @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), -1)"
                        :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').numPeople <= 1">-</button>
                      <span>{{ getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').numPeople }}명</span>
                      <button class="bg-gray-200 px-2 py-1 rounded"
                        @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), 1)"
                        :disabled="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후').numPeople >= 4">+</button>
                    </div>
                  </td>
                  <td class="p-2 border text-right">
                    \ {{ (Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오후').price) *
                    Number(getCartItemByDateAndTime(addDays(minDate, n - 1),'오후').numPeople)).toLocaleString() }}원
                  </td>
                  <td class="p-2 border text-center">
                    <button @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'))"
                      class="text-red-500">🗑️</button>
                  </td>
                </template>
                <template v-else>
                  <td class="p-2 border" colspan="4"></td>
                </template>
              </tr>
            </template>
          </template>
        </tbody>
      </table>

      <div class="text-right text-lg font-semibold mb-4">
        💰 최종 금액: <strong>{{ getTotalPrice().toLocaleString() }}</strong> 원
      </div>

      <div class="text-center">
        <button class="bg-green-500 text-white px-6 py-2 rounded shadow" @click="fnPay">결제</button>
      </div>
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
							self.tourInfo.isFavorite = "N";
							console.log(self.tourInfo);
							self.reviewsList = data.reviewsList;
							console.log(self.reviewsList);
							console.log('투어 날짜 : ', self.tourInfo.tourDate);
							self.fnGetWishList();
							
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
					}

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

				fnPay() {
					this.handleCartClose();
					location.href = "/payment.do"
				},

				fnGetWishList() {
                    let self = this;
                    let nparmap = {
                        userNo: parseInt(self.sessionId)
                    };

                    $.ajax({
                        url: "/wishList/getWishList.dox",
                        type: "POST",
                        dataType: "json",
                        data: nparmap,
                        success: function(data) {
                            const wishTourNos = (data.list || []).map(item => +item.tourNo);
							console.log("찜목록 tourNo 목록: ", wishTourNos);
							const currentTourNo = Number(self.tourInfo.tourNo); // 현재 보고 있는 상품 번호
							self.tourInfo.isFavorite = wishTourNos.includes(currentTourNo) ? "Y" : "N";

							console.log("최종 info 객체: ", self.tourInfo);
						}
                    });
                },

                toggleFavorite(tour) {
                    let self = this;
                    tour.isFavorite = tour.isFavorite === "Y" ? "N" : "Y";
                    if (tour.isFavorite === "Y") {
                        $.ajax({
                            url: "/wishList/addWishList.dox",
                            type: "POST",
                            data: { 
                                userNo: self.sessionId, 
                                guideNo : tour.guideNo,
                                tourNo: tour.tourNo 
                            },
                            success: function(res) {
                                console.log("찜 추가됨", res);
                            }
                        });
                    } else {
                        $.ajax({
                            url: "/wishList/removeWishList.dox",
                            type: "POST",
                            data: { 
                                userNo: self.sessionId, 
                                tourNo: tour.tourNo 
                            },
                            success: function(res) {
                                console.log("찜 제거됨", res);
                            }
                        });
                    }
                },
				fnEdit() {
					pageChange("/mypage/guide-edit.do", {tourNo : this.tourNo});
				
				},

				fnDelete() {
					let self = this;
					let nparmap = {
						tourNo: self.tourNo,
					};

					if (confirm("정말 삭제하시겠습니까?")) {
						$.ajax({
							url: "/mypage/guide-delete.dox",
							dataType: "json",
							type: "POST",
							data: nparmap,
							success: function (data) {
								if (data.result == "success") {
									alert("삭제되었습니다.");
									location.href = "/tours/list.do"
								} else {
									alert("삭제에 실패했습니다.");
								}
							}
						});
					}
				}


			},
			mounted() {
				let self = this;
				const params = new URLSearchParams(window.location.search);
				self.tourNo = params.get("tourNo") || "";
				self.fnTourInfo();
				self.fnGetCart();
				self.fnGetBasketList();
				self.fnGetBasket();
				self.fnGetMinTourDate();
				self.fnGetMaxTourDate();
				self.fnGetTourDateList();

				// setTimeout(() => {
                //     if (self.sessionId === "${sessionId}") {
                //         self.fnGetWishList();
                //     } else {
                //         console.log("세션 로딩이 아직 안됨");
                //     }
                // }, 300);

			}
		});
		app.component('star-rating', VueStarRating.default)
		app.mount('#app');
	</script>