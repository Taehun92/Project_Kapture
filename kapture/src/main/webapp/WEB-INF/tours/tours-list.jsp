<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-Change.js"></script>
        <title>관광지 목록</title>
        <style>
            body {
                font-family: Arial, sans-serif;
            }

            .container {
                width: 80%;
                margin: auto;
            }

            /* 주요 관광지 + 지역 선택 버튼 그룹 */
            .tour-header-group {
                background-color: #f0f0f0;
                padding: 20px;
                text-align: center;
                margin-bottom: 10px;
            }

            .tour-header {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .tour-buttons {
                display: flex;
                justify-content: center;
                gap: 10px;
            }

            .tour-buttons button {
                padding: 10px 15px;
                border: 1px solid #ccc;
                background-color: #f8f8f8;
                cursor: pointer;
            }

            /* 경로 표시 */
            .breadcrumb {
                margin: 10px 0;
                font-size: 14px;
            }

            hr {
                border: 1px solid #ccc;
            }

            /* 사이드바 및 고정 기능 */
            .content {
                display: flex;
                gap: 20px;
            }

            .sidebar {
                width: 250px;
                padding: 10px;
                border: 1px solid #ddd;
                position: sticky;
                top: 0;
                background: white;
                transition: top 0.3s;
            }

            .filter {
                width: 145px;
                margin-bottom: 10px;
                border-bottom: 1px solid #ddd;
                padding-bottom: 5px;
            }

            .filter button {
                width: 100%;
                background: none;
                border: none;
                font-size: 16px;
                text-align: left;
                cursor: pointer;
                padding: 5px;
            }

            .filter-content {

                padding: 5px 10px;
            }

            /* 상품 카드 (폴라로이드 스타일) */
            .tour-list {
                flex-grow: 1;
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .tour-card {
                width: 200px;
                background: white;
                border: 2px solid black;
                padding: 10px;
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .tour-card img {
                width: 180px;
                height: 150px;
                object-fit: cover;
            }

            .tour-card .desc {
                width: 100%;
                background: white;
                padding: 10px;
            }
        </style>
    </head>

    <body>

        <jsp:include page="../common/header.jsp" />
        <div id="app" class="container">
            <!-- 주요 관광지 그룹 -->
            <div class="tour-header-group">
                <div class="tour-header">주요 관광지</div>
                <div class="tour-buttons">
                    <a v-for="region in regions" :key="region">{{ region }}</a>
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
                        <div class="" v-if="filters.date">
                            <input type="date">
                        </div>

                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('language')">가이드 언어 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.language">
                            <label><input type="checkbox" v-model="selectedLanguages" value="한국어"> 한국어</label><br>
                        </div>
                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('region')">지역별 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.region">
                            <template v-for="item in regionList">
                                <label><input type="checkbox" v-model="selectedRegions" value="item.siName">
                                    {{item.siName}}
                                </label><br>
                            </template>
                        </div>
                    </div>
                    <div class="filter">
                        <button @click="toggleFilter('theme')">테마별 {{ filters.date ? '∧' : '∨' }}</button>
                        <div class="filter-content" v-if="filters.theme">
                            <template v-for="theme in themeList">
                                <label><input type="checkbox" v-model="selectedThemes" value="theme.themeNo">
                                    {{theme.themeName}}
                                </label><br>
                            </template>
                        </div>
                    </div>
                </div>

                <!-- 관광지 리스트 -->
                <div class="tour-list">
                    <div v-for="tour in toursList" :key="tour.title" class="tour-card">
                        <img :src="tour.filePath" alt="Tour Image">
                        <div class="desc">
                            <p>{{ tour.title }}</p>
                            <p>{{ tour.price }}</p>
                        </div>
                    </div>
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
                    regions: ["서울", "경기 인천", "부산", "전주", "강원", "그 외"],
                    language: ["한국어", "영어", "중국어", "일본어"],
                    filters: {
                        date: false,
                        language: false,
                        region: false,
                        theme: false
                    },
                    // tours: [
                    //     { id: 1, name: "경복궁", description: "전통적인 궁궐", image: "https://via.placeholder.com/180" },
                    //     { id: 2, name: "해운대 해수욕장", description: "부산의 대표 해변", image: "https://via.placeholder.com/180" },
                    //     { id: 3, name: "전주 한옥마을", description: "전통 한옥 체험", image: "https://via.placeholder.com/180" },
                    //     { id: 4, name: "남산 타워", description: "서울의 랜드마크", image: "https://via.placeholder.com/180" },
                    //     { id: 5, name: "설악산", description: "아름다운 자연 경관", image: "https://via.placeholder.com/180" },
                    //     { id: 6, name: "제주 성산일출봉", description: "제주의 대표 명소", image: "https://via.placeholder.com/180" },
                    //     { id: 7, name: "광안리 해변", description: "야경이 아름다운 해변", image: "https://via.placeholder.com/180" },
                    //     { id: 8, name: "안동 하회마을", description: "전통적인 한옥 마을", image: "https://via.placeholder.com/180" },
                    //     { id: 9, name: "수원 화성", description: "유네스코 문화유산", image: "https://via.placeholder.com/180" },
                    //     { id: 10, name: "DMZ 비무장지대", description: "한국 전쟁의 역사적 장소", image: "https://via.placeholder.com/180" }
                    // ]
                    toursList: [],
                    regionList: [],
                    themeList: [],
                    selectedDates: [],
                    selectedRegions: [],
                    selectedLanguages: [],
                    selectedThemes: [],

                };
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

                    let nparmap = {
                        // selectedDates:self.selectedDates,
                        // selectedRegion:self.selectedRegion,
                        // selectedLanguage:self.selectedLanguage,
                        // selectedTheme:self.selectedTheme,
                    };
                    $.ajax({
                        url: "/tours/list.dox",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json", // JSON으로 보내기
                        data: JSON.stringify(nparmap),
                        success: function (data) {
                            console.log(data);
                            self.toursList = data.toursList;
                            console.log(self.toursList);
                            self.regionList = data.regionList;
                            console.log(self.regionList);
                            self.themeList = data.themeList;
                            console.log(self.themeList);

                        }
                    });
                },
            },
            mounted() {
                var self = this;
                self.fnToursList();
            }
        });
        app.mount('#app');
    </script>