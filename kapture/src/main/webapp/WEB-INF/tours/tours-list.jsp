<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="https://unpkg.com/@vuepic/vue-datepicker/dist/main.css">
        <script src="https://unpkg.com/@vuepic/vue-datepicker@latest"></script>
        <script src="/js/page-Change.js"></script>
        <link rel="stylesheet" href="../../css/tourList.css">
        <link rel="stylesheet" href="../../css/tourInfo.css">
        <title>관광지 목록</title>
        <style>
           
        </style>
    </head>

    <body>

        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <!-- 주요 관광지 그룹 -->
            
            <div class="tour-header-group">
                <div class="tour-header">주요 관광지</div>
                <div class="tour-buttons">
                    <button v-for="region in regions" @click="fnRegionalTours(region.siNo)" :key="region.region">{{ region.region }}</button>

                </div>
            </div>

            <!-- 현재 경로 -->
            <div class="breadcrumb">홈 > 상품</div>
            <hr>

            <!-- 콘텐츠 영역 -->
            <div class="content">
                <!-- 사이드바 -->
                <div class="sidebar">
                    <div class="filter">
                        <button @click="toggleFilter('date')">여행기간 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.date">
                            
                            <div>날짜  선택: {{ selectedDates }}</div>
                            <vue-date-picker v-model="selectedDates" multi-calendars model-auto range :min-date="new Date()"
                                @input="params.startDate = _formatedDatepicker($event)" locale="ko" />
                                
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

                <!-- 관광지 리스트 -->
                <div class="tour-list">
                    <div v-for="tour in toursList" class="tour-card" @click="goToTourInfo(tour.tourNo)">
                        <img :src="tour.filePath" alt="Tour Image">
                        <div class="desc">
                            <p>{{ tour.title }}</p>
                            <p>{{ tour.price }}</p>
                        </div>
                    </div>
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
         <!-- 푸터 주석하면 인풋박스까지 나오고 데이트피커 X -->
          <!-- 둘 다 주석 하거나 지우면 데이트피커까지 나옴 -->
    </body>

    </html>
    <script>

        const app = Vue.createApp({
            data() {
                return {
                    regions: [{region:"서울", siNo:11}, {region:"제주", siNo:39}, {region:"부산", siNo:21}, {region:"전주", siNo:35},
                             {region:"강원", siNo:32}, {region:"인천", siNo:23}, {region:"경기", siNo:31}, {region:"그 외", siNo:999}],
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

                    keyword : "${keyword}",

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
            components: {
				VueDatePicker
			},
            watch: {
				selectedDates() {
                    this.fnToursList();
				}
			},
            methods: {
                toggleFilter(type) {
                    let self = this;
                    self.filters[type] = !self.filters[type];
                    console.log(self.regionList);
                    console.log(self.themeList);
                },
                fnToursList() {
                    let self = this;
                    console.log("selectedDates >> " + self.selectedDates);
                    let nparmap = {
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
                            console.log("DATA", data);
                            self.toursList = data.toursList;
                            self.regionList = data.regionList;
                            self.themeList = data.themeList;
                            console.log("LANG", self.selectedLanguages);
                            console.log("LIST", self.toursList);
                        }
                    });
                },
                goToTourInfo(tourNo) {
                    pageChange("/tours/tour-info.do", { tourNo: tourNo });
                },
                fnRegionalTours(siNo){
                    console.log("siNo"+siNo);
   
                    pageChange("/tours/regionalTours.do",{siNo: siNo});
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
                            console.log('getCount 호출 : ', data);
                            if(data.count > 0) {
                                self.showCartButton = true;
                            }
                            
                        }
                    });
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
                var self = this;
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