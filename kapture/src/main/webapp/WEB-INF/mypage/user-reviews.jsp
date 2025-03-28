<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>마이페이지</title>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <!-- Vue.js -->
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <!-- rating -->
        <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>

        <style>
            /* 전체 레이아웃 설정 */
            body {
                margin: 0;
                padding: 0;
                font-family: 'Noto Sans KR', sans-serif;
                background-color: #fff;
                color: #333;
            }

            .container {
                /* 사이드 메뉴와 콘텐츠를 가로로 배치하기 위해 flex 사용 */
                display: flex;
                max-width: 1200px;
                min-height: calc(100vh - 300px);
                margin: 0 auto;
                padding: 20px;
                box-sizing: border-box;
            }

            /* 사이드 메뉴 */
            .side-menu {
                width: 200px;
                height: 100%;
                border: 1px solid #ddd;
                position: sticky;
                top: 0;
                background: white;
                transition: top 0.3s;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .side-menu li {
                margin-bottom: 10px;
            }

            .side-menu li a.active {
                display: block;
                background-color: #3e4a97;
                color: white;
                padding: 10px;
                text-decoration: none;
            }

            .side-menu a {
                text-decoration: none;
                color: #333;
                font-weight: 500;
            }

            .side-menu a:hover {
                color: #ff5555;
            }

            /* 메인 콘텐츠 영역 */
            .content-area {
                flex: 1;
            }

            /* ========== 후기 레이아웃 추가 ========== */
            .review-container {
                max-width: 1000px;
                /* 필요에 따라 조정 */
                margin: 0 auto;
                padding: 0 20px;
                box-sizing: border-box;
            }

            /* 헤더 영역 (검색 기능 제외) */
            .review-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .review-header h2 {
                font-size: 20px;
                font-weight: bold;
                margin: 0;
                margin-right: auto;
            }

            /* 후기 목록 */
            .review-list {
                border-top: 1px solid #ccc;
                margin-top: 10px;
                padding-top: 10px;
            }

            /* 각 후기 아이템 */
            .review-item {
                display: flex;
                margin-bottom: 20px;
            }

            /* 후기 이미지 */
            .review-img {
                margin-right: 15px;
            }

            .review-img img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                /* 이미지 비율 유지 */
                border: 1px solid #ccc;
            }

            /* 후기 내용 */
            .review-content {
                flex: 1;
            }

            /* 작성자, 작성일, 평점 등 메타 정보 */
            .review-meta {
                font-size: 14px;
                color: #666;
                margin-bottom: 5px;
            }

            .review-meta span {
                margin-right: 10px;
            }

            /* 평점 표시 (별) */
            star-rating {
                display: inline-block;
            }

            /* 후기 본문 텍스트 */
            .review-text {
                font-size: 15px;
                line-height: 1.4;
                color: #333;
            }
        </style>
    </head>

    <body>
        <!-- 공통 헤더 -->
        <jsp:include page="../common/header.jsp" />

        <div id="app" class="container">
            <!-- 좌측 사이드 메뉴 -->
            <div class="side-menu">
                <ul>
                    <li>
                        <a :class="{ active: currentPage === 'user-mypage.do' }"
                            href="http://localhost:8080/mypage/user-mypage.do">
                            회원 정보수정
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-purchase-history.do' }"
                            href="http://localhost:8080/mypage/user-purchase-history.do">
                            구매한 상품
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-reviews.do' }"
                            href="http://localhost:8080/mypage/user-reviews.do">
                            이용후기 관리
                        </a>
                    </li>
                    <li>
                        <a href="http://localhost:8080/cs/qna.do">
                            문의하기
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-unregister.do' }"
                            href="http://localhost:8080/mypage/user-unregister.do">
                            회원 탈퇴
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 우측 메인 콘텐츠 -->
            <div class="content-area">
                <!-- ========== 사용후기 레이아웃 ========== -->
                <div class="review-container">
                    <div class="review-header">
                        <h2>사용후기</h2>
                    </div>

                    <!-- <div class="review-list">
                    
                    <div class="review-item">
                        <div class="review-img">
                    
                            <img src="https://via.placeholder.com/80" alt="상품이미지">
                        </div>
                        <div class="review-content">
                            <div class="review-meta">
                                <span>작성자: 장씨</span>
                                <span>작성일: 2018-07-11</span>
                                <span>평점수:
                                    <span class="stars">★★★★★</span>
                                </span>
                            </div>
                            <div class="review-text">
                                여행후기입니다.
                            </div>
                        </div>
                    </div> -->

                    <!-- 두 번째 후기 -->
                    <div class="review-item" v-for="review in reviewsList">

                        <div class="review-img">
                            <img src="../img/1.jpg" alt="상품이미지">
                            <div>상품명: {{review.title}}</div>
                        </div>
                        <template v-if="review.reviewNo != 0">
                            <div class="review-content">
                                <div class="review-meta">
                                    <span>작성자: {{review.userFirstName}} </span>
                                    <span v-if="review.userLastName != null">{{review.userLastName}}</span>
                                    <span>작성일: {{review.rUpdatedAt}}</span>
                                    <div >
                                        평점: <star-rating :rating="review.rating" :read-only="true" :star-size="10"
                                            :increment="0.01" :border-width="5" :show-rating="false"
                                            :rounded-corners="true" style="display: inline-block; vertical-align: middle;"></star-rating>
                                    </div>
                                </div>
                                <div class="review-text">
                                    {{review.comment}}
                                </div>
                            </div>
                        </template>
                        <template v-else>
                            <div class="review-text">
                                <button @click="fnReviewAdd">리뷰 등록</button>
                            </div>
                        </template>

                    </div>

                    <!-- 필요하다면 후기 아이템 추가 -->
                </div>
            </div>
            <!-- ========== 사용후기 레이아웃 끝 ========== -->
        </div>
        </div>

        <!-- 공통 푸터 -->
        <jsp:include page="../common/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        reviewsList: [],
                        currentPage: "",
                    };
                },
                methods: {
                    fnReviews() {
                        let self = this;
                        let nparmap = {
                            sessionId: self.sessionId,
                        };

                        $.ajax({
                            url: "/mypage/user-reviews.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    self.reviewsList = data.reviewsList;
                                    console.log(self.reviewsList);

                                } else {
                                    console.error("데이터 로드 실패");
                                }
                            },
                            error: function (error) {
                                console.error("AJAX 에러:", error);
                            }
                        });
                    },
                    fnReviewAdd(){
                        
                    }
                },
                mounted() {
                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "http://localhost:8080/main.do";
                    }
                    if (this.sessionRole != 'TOURIST') {
                        alert("일반회원만 이용가능합니다.");
                        location.href = "http://localhost:8080/main.do";
                    }

                    // 현재 페이지 파일명 추출 -> 사이드바 active 클래스 적용
                    this.currentPage = window.location.pathname.split('/').pop();
                    console.log("Current page:", this.currentPage);
                    this.fnReviews();
                }
            });
            app.component('star-rating', VueStarRating.default)
            app.mount('#app');
        </script>
    </body>

    </html>