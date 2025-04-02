<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="https://unpkg.com/@vuepic/vue-datepicker/dist/main.css">
        <script src="https://unpkg.com/@vuepic/vue-datepicker@latest"></script>
        <link rel="stylesheet" href="../../css/tourList.css">
        <link rel="stylesheet" href="../../css/components/card.css">
        <title>관광지 목록</title>
        <style>

        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
        <div id="app">
            <!-- 주요 관광지 그룹 -->
            <div class="tour-header-group"
                :style="{ backgroundImage: 'url(' + (hoveredRegionImage || defaultHeaderImage) + ')' }">
                <div class="tour-header">주요 관광지</div>
                <div class="tour-buttons">
                    <button v-for="region in regions" @mouseover="hoveredRegionImage = region.image"
                        @mouseleave="hoveredRegionImage = null" @click="fnRegionalTours(region.siNo)"
                        :key="region.region">
                        {{ region.region }}
                    </button>
                </div>
            </div>
            <div class="layout">
                <!-- 사이드바 -->
                <div class="sidebar">
                    <div class="filter">
                        <button @click="toggleFilter('date')">
                            여행기간 {{ filters.date ? '∧' : '∨' }}
                        </button>
                        <div class="filter-content" v-if="filters.date">

                            <!-- ✅ 날짜 선택 완료 후 -->
                            <div v-if="Array.isArray(selectedDates) && selectedDates.length > 0 && !showDatePicker">
                                <p>선택한 날짜: {{ formatDateRange(selectedDates) }}</p>
                                <button @click="resetDatePicker" style="font-size: 15px;">📅 날짜 다시 선택</button>
                            </div>

                            <!-- ✅ 날짜 선택 중 -->
                            <div v-else>
                                <vue-date-picker v-model="selectedDates" multi-calendars model-auto range
                                    :min-date="new Date()" locale="ko" @update:model-value="handleDateInput" />
                            </div>
                        </div>
                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('language')">가이드 언어 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.language">
                            <template v-for="language in languages">
                                <label>
                                    <input @change="fnToursList" type="checkbox" v-model="selectedLanguages"
                                        :value="language.eng">
                                    {{language.kor}}
                                </label><br>
                            </template>
                        </div>
                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('region')">지역별 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.region">
                            <template v-for="item in regionList">
                                <label><input @change="fnToursList" type="checkbox" v-model="selectedRegions"
                                        :value="item.siNo">
                                    {{item.siName}}
                                </label><br>
                            </template>
                        </div>
                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('theme')">테마별 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.theme">
                            <template v-for="theme in themeList">
                                <label><input @change="fnToursList" type="checkbox" v-model="selectedThemes"
                                        :value="theme.themeNo">
                                    {{theme.themeName}}
                                </label><br>
                            </template>
                        </div>
                    </div>
                </div>
                <div class="container">
                    <!-- 현재 경로 -->
                    <div class="breadcrumb">홈 > 상품</div>
                    <hr>
                    <!-- 콘텐츠 영역 -->
                    <div class="content">
                        <!-- 관광지 리스트 -->
                        <div class="card-list">
                            <div class="card" v-for="tour in toursList" :key="tour.tourNo">
                                <div class="card-image">
                                    <img :src="tour.filePath" alt="썸네일" />
                                </div>
                                <div class="card-content">
                                    <div class="card-top">
                                        <div class="card-date">{{ formatDate(tour.tourDate) }}</div>
                                        <div class="hashtags">
                                            <span class="theme-hashtag"># {{ tour.themeName }}</span>
                                        </div>
                                        <div class="favorite" :class="{ active: tour.isFavorite }" @click="toggleFavorite(tour)"></div>
                                    </div>
                                    <div class="card-title">{{ tour.title }}</div>
                                    <div class="card-desc">{{ truncateText(tour.description) }}</div>
                                    <div class="card-info">
                                        <div v-if="tour.rating >= 0" class="rating">⭐ {{ tour.rating }}</div>
                                        <div v-else class="rating"> {{ tour.rating }}</div>
                                        <div class="price">₩ {{ tour.price.toLocaleString() }}</div>
                                    </div>
                                    <button class="card-btn" @click="goToTourInfo(tour.tourNo)">예약하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
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
        <jsp:include page="../common/footer.jsp" />
        <!-- 푸터 주석하면 인풋박스까지 나오고 데이트피커 X -->
        <!-- 둘 다 주석 하거나 지우면 데이트피커까지 나옴 -->
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {

                    regions: [{
                        region: "서울", siNo: 11, image: "../../img/region/서울.jpg"
                    }, {
                        region: "제주", siNo: 39, image: "../../img/region/제주.jpg"
                    }, {
                        region: "부산", siNo: 21, image: "../../img/region/부산.jpg"
                    }, {
                        region: "전주", siNo: 35, image: "../../img/region/전주.jpg"
                    }, {
                        region: "강원", siNo: 32, image: "../../img/region/속초.jpg"
                    }, {
                        region: "인천", siNo: 23, image: "../../img/region/월미도.jpg"
                    }, {
                        region: "경기", siNo: 31, image: "../../img/region/용인.jpg"
                    }, {
                        region: "그 외", siNo: 999, image: "../../img/region/대천.jpg"
                    }],
                    languages: [{ eng: "Korean", kor: "한국어" }, { eng: "English", kor: "영어" }, { eng: "Chinese", kor: "중국어" }, { eng: "Japanese", kor: "일본어" }],
                    filters: {
                        date: false,
                        language: false,
                        region: false,
                        theme: false
                    },
                    toursList: [],
                    regionList: [],
                    themeList: [],
                    selectedDates: [],
                    selectedRegions: [],
                    selectedLanguages: [],
                    selectedThemes: [],
                  
                    keyword: "${keyword}",

                    sessionId: "${sessionId}",
                    showModal: false,
                    date: new Date(),
                    showCartButton: false,
                    tourDate: null,
                    dateList: [],
                    minDate: null,
                    maxDate: null,

                    showModal: false,
                    cartList: [],
                    minDate: new Date(),

                    defaultHeaderImage: "../../img/region/default.jpg",
                    hoveredRegionImage: null,

                    showDatePicker: true

                };
            },
            components: {
                VueDatePicker
            },

            methods: {
                resetDatePicker() {
                    this.selectedDates = [];
                    this.showDatePicker = true;
                },
                handleDateInput(dates) {
                    this.selectedDates = dates;
                    this.showDatePicker = false;
                    this.fnToursList();
                },
                formatDateRange(dates) {
                    if (!dates || dates.length === 0) return '선택 안 됨';
                    if (dates.length === 1) return this.formatDate(dates[0]);
                    return this.formatDate(dates[0]) + ' ~ ' + this.formatDate(dates[1]);
                },
                formatDate(input) {
                    if (!input) return '';
                    
                    // 문자열인 경우: "2025-04-12 00:00:00"
                    if (typeof input === 'string') {
                        return input.split(' ')[0];
                    }

                    // Date 객체인 경우
                    const year = input.getFullYear();
                    const month = (input.getMonth() + 1).toString().padStart(2, '0');
                    const day = input.getDate().toString().padStart(2, '0');
                    return `${year}-${month}-${day}`;
                },
                
                truncateText(text, maxLength = 30) {
                    if (!text) return '';
                    return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
                },

                addDays(date, days) {
                    const newDate = new Date(date);
                    newDate.setDate(newDate.getDate() + days);
                    return newDate;
                },
                toggleFilter(type) {
                    this.filters[type] = !this.filters[type];
                },
                fnToursList() {
                    const self = this;
                    const nparmap = {
                        selectedDates: JSON.stringify(self.selectedDates),
                        selectedRegions: JSON.stringify(self.selectedRegions),
                        selectedLanguages: JSON.stringify(self.selectedLanguages),
                        selectedThemes: JSON.stringify(self.selectedThemes),
                    };

                    $.ajax({
                        url: "/tours/list.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.toursList = data.toursList;
                            self.regionList = data.regionList;
                            self.themeList = data.themeList;
                        }
                    });
                },
                goToTourInfo(tourNo) {
                    location.href="/tours/tour-info.do?tourNo=" + tourNo ;
                },
                fnRegionalTours(siNo) {
                    location.href="/tours/regionalTours.do?siNo=" + siNo ;
                },
                fnGetMinTourDate() {
                    const self = this;
                    $.post("/basket/getMinTourDate.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.minDate) {
                            const parts = data.minDate.split(' ');
                            const month = parseInt(parts[0].replace('월', '')) - 1;
                            const day = parseInt(parts[1].replace(',', ''));
                            const year = parseInt(parts[2]);
                            self.minDate = new Date(year, month, day);
                        }
                    }, "json");
                },
                fnGetMaxTourDate() {
                    const self = this;
                    $.post("/basket/getMaxTourDate.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.maxDate) {
                            const parts = data.maxDate.split(' ');
                            const month = parseInt(parts[0].replace('월', '')) - 1;
                            const day = parseInt(parts[1].replace(',', ''));
                            const year = parseInt(parts[2]);
                            self.maxDate = new Date(year, month, day);
                        }
                    }, "json");
                },
                fnGetTourDateList() {
                    const self = this;
                    $.post("/basket/getTourDateList.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        self.dateList = data.dateList;
                    }, "json");
                },
                fnGetBasket() {
                    const self = this;
                    $.post("/basket/getCount.dox", {
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.count > 0) {
                            self.showCartButton = true;
                        }
                    }, "json");
                },
                fnGetBasketList() {
                    const self = this;
                    $.post("/basket/getBasketList.dox", {
                        sessionId: self.sessionId
                    }, function (data) {
                        self.cartList = data.basketList;
                    }, "json");
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

            created() {
                const params = new URLSearchParams(window.location.search);
                const keyword = params.get("keyword");

                if (keyword) {
                    this.keyword = keyword; // 검색창에 표시
                    this.fnGetSearchResult(keyword); // 검색 로직 실행
                }
            },

            mounted() {
                let self = this;
                self.fnToursList();
                self.fnGetMinTourDate();
                self.fnGetMaxTourDate();
                self.fnGetTourDateList();
                self.fnGetBasket();
                self.fnGetBasketList();
            }
        });

        app.mount('#app');
    </script>