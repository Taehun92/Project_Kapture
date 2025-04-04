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
        <link rel="stylesheet" href="../../css/main.css">
        <link rel="stylesheet" href="../../css/components/card.css">
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <title>메인 페이지</title>
    </head>
    <style>
        .div {
            padding-bottom: 50px;
        }
    </style>

    <body>
        <jsp:include page="../common/header.jsp"></jsp:include>
        <div id="app">
            <div class="swiper-container" style="position: relative;">
                <!-- ✅ 고정 문구 텍스트 -->
                <div class="hero-text">
                    <h1 class="title">YOUR WORLD OF JOY</h1>
                    <p class="subtitle">캡쳐와 함께 국내의 모든 즐거움을 경험해보세요</p>
                </div>

                <!-- ✅ Swiper 이미지 슬라이드 -->
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <img class="banner" src="../../img/city.jpg">
                    </div>
                    <div class="swiper-slide">
                        <img class="banner" src="../../img/han.jpg">
                    </div>
                    <div class="swiper-slide">
                        <img class="banner" src="../../img/banner3.jpg">
                    </div>
                </div>
            </div>
            <div class="main-container">
                <div class="main-title">
                    <hr>
                    추 천 상 품
                </div>
                <!-- 관광지 리스트 -->
                <div class="card-list">
                    <div class="card" v-for="tour in limitedToursList" :key="tour.tourNo">
                        <div class="card-image">
                            <img :src="tour.filePath" alt="썸네일" />
                        </div>
                        <div class="card-content">
                            <div class="card-top">
                                <div class="card-date">{{ formatDate(tour.tourDate) }}</div>
                                <div class="hashtags">
                                    <span class="theme-hashtag"># {{ tour.themeName }}</span>
                                </div>
                                <div class="favorite" :class="{ active: tour.isFavorite === 'Y' }" @click="toggleFavorite(tour)"></div>
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

                <div class="main-title">
                    <hr>
                      추 천 리 뷰
                </div>
                <div class="review-page">
                    <div class="review-box">
                        <div class="review-author">사용자 A</div>
                        <img class="review-image" src="../../img/1.jpg" alt="리뷰 이미지 1">
                        <div class="review-content">이 상품 정말 좋아요! 배송도 빠르고 품질도 만족스럽습니다.</div>
                        <div class="review-rating">★★★★★</div>
                    </div>

                    <div class="review-box">
                        <div class="review-author">사용자 B</div>
                        <img class="review-image" src="../../img/2.jpg" alt="리뷰 이미지 2">
                        <div class="review-content">가격 대비 성능이 훌륭합니다. 추천합니다!</div>
                        <div class="review-rating">★★★★☆</div>
                    </div>

                    <div class="review-box">
                        <div class="review-author">사용자 C</div>
                        <img class="review-image" src="../../img/3.jpg" alt="리뷰 이미지 3">
                        <div class="review-content">잘 받았습니다. 다음에 또 구매할게요.</div>
                        <div class="review-rating">★★★★</div>
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