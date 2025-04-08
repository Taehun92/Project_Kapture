<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="icon" type="image/png" sizes="96x96" href="/img/logo/favicon-96x96.png" />
        <link rel="shortcut icon" href="/img/logo/favicon-96x96.png" />
        <title>메인 페이지 | kapture</title>
    </head>

    <body class="bg-white text-gray-800 font-sans text-[16px] tracking-wide">
        <jsp:include page="../common/header.jsp"></jsp:include>
        <div id="app" class="pb-12">
            <!-- Swiper 배너 -->
            <div class="relative w-full h-[500px]">
                <div class="absolute z-10 w-full text-center top-[30%] text-white">
                    <h1 class="text-5xl font-bold">YOUR WORLD OF JOY</h1>
                    <p class="text-xl mt-4">캡쳐와 함께 국내의 모든 즐거움을 경험해보세요</p>
                </div>
                <div class="swiper-container w-full h-full">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img class="w-full h-full object-cover" src="../../img/city.jpg">
                        </div>
                        <div class="swiper-slide">
                            <img class="w-full h-full object-cover" src="../../img/han.jpg">
                        </div>
                        <div class="swiper-slide">
                            <img class="w-full h-full object-cover" src="../../img/banner3.jpg">
                        </div>
                    </div>
                </div>
            </div>
            <div class="max-w-[1200px] mx-auto mt-12">
                <h2 class="text-2xl font-bold mb-4 border-b-2 pb-2">추천 상품</h2>
            
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <div 
                        class="border rounded-xl shadow-md overflow-hidden flex flex-col justify-between"
                        v-for="tour in limitedToursList" 
                        :key="tour.tourNo"
                    >
                        <img :src="tour.filePath" class="w-full h-48 object-cover" alt="썸네일" />
                        <div class="p-4">
                            <div class="flex justify-between items-center text-sm text-gray-500 mb-2">
                                <span>{{ formatDate(tour.tourDate) }}</span>
                                <span># {{ tour.themeName }}</span>
                                <img :src="tour.isFavorite === 'Y' ? '../../svg/taeguk-full.svg' : '../../svg/taeguk-outline.svg'"
                                        alt="찜 아이콘" class="w-8 h-8 cursor-pointer" @click="toggleFavorite(tour)" />
                            </div>
                            <h3 class="text-lg font-semibold mb-2">{{ tour.title }}</h3>
                            <p class="text-gray-600 text-sm mb-3">{{ truncateText(tour.description) }}</p>
                            <div class="flex justify-between items-center">
                                <span v-if="tour.rating >= 0" class="text-yellow-500">⭐ {{ tour.rating }}</span>
                                <span v-else class="text-gray-500">리뷰 없음</span>
                                <span class="font-bold text-blue-600">₩ {{ tour.price.toLocaleString() }}</span>
                            </div>
                            <button 
                                class="mt-4 w-full bg-blue-950 hover:bg-blue-700 text-white py-2 px-4 rounded"
                                @click="goToTourInfo(tour.tourNo)"
                            >예약하기</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="max-w-[1200px] mx-auto mt-16">
                <h2 class="text-2xl font-bold mb-4 border-b-2 pb-2">추천 리뷰</h2>
            
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <div class="border rounded-lg p-4 shadow" v-for="(review, index) in reviews" :key="index">
                        <div class="text-sm font-semibold mb-2">{{ review.author }}</div>
                        <img :src="review.image" class="w-full h-40 object-cover mb-2 rounded" />
                        <p class="text-gray-600 text-sm mb-2">{{ review.content }}</p>
                        <div class="text-yellow-500">{{ review.rating }}</div>
                    </div>
                </div>
            </div>
        </div>    
        <jsp:include page="../common/footer.jsp"></jsp:include>
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    swiper: null,
                    toursList: [],
                    sessionId: "${sessionId}"
                };
            },

            computed: {
                limitedToursList() {
                    return this.toursList.slice(0, 12); // 최대 9개만 반환
                }
            },
            methods: {
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
                    return year + '-' + month + '-' + day;
                },

                truncateText(text, maxLength = 30) {
                    if (!text) return '';
                    return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
                },

                fnToursList() {
                    let self = this;
                    let nparmap = {
                    };
                    $.ajax({
                        url: "/main/getTourandRatingList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.toursList = data.list;
                        }
                    });
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

                            self.toursList = self.toursList.map(function(tour) {
                                const tourNo = Number(tour.tourNo);
                                return {
                                    ...tour,
                                    isFavorite: wishTourNos.includes(tourNo) ? "Y" : "N"
                                };
                            });

                            console.log("최종 toursList: ", self.toursList);
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

                goToTourInfo(tourNo) {
                    location.href="/tours/tour-info.do?tourNo=" + tourNo;
                },
            },
            mounted() {
                let self = this;
                let swiper = new Swiper('.swiper-container', {
                    // 기본 옵션 설정
                    loop: true, // 반복
                    spaceBetween: 0,
                    slidesPerView: 1,
                    autoplay: {
                        delay: 2500,
                    },
                    pagination: {
                        el: '.swiper-pagination',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.swiper-button-next',
                        prevEl: '.swiper-button-prev',
                    },
                });

                self.fnToursList();

                setTimeout(() => {
                    if (self.sessionId === "${sessionId}") {
                        self.fnGetWishList();
                    } else {
                        console.log("세션 로딩이 아직 안됨");
                    }
                }, 300);

            }
        });
        app.mount('#app');
    </script>