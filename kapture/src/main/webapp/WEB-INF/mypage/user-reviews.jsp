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

            /* 후기 본문 텍스트 */
            .review-text {
                font-size: 15px;
                line-height: 1.4;
                color: #333;
            }

            /* 모달 오버레이 (뒷배경) */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background-color: rgba(0, 0, 0, 0.5);
                /* 모달을 화면 가운데 정렬하기 위해 */
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                /* 다른 요소 위에 표시 */
            }

            /* 모달 컨테이너 */
            .modal-container {
                background-color: #fff;
                width: 500px;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
                border-radius: 5px;
            }

            /* 테이블 예시 */
            .review-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 15px;
            }

            .review-table th,
            .review-table td {
                text-align: left;
                padding: 8px;
                border-bottom: 1px solid #ddd;
                vertical-align: top;
                width: 30%;
            }

            /* 버튼 영역 */
            .btn-area {
                text-align: right;
                margin-top: 10px;
            }

            .btn-area button {
                padding: 6px 12px;
                margin-left: 5px;
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
                                    <div>
                                        평점: <star-rating :rating="review.rating" :read-only="true" :star-size="10"
                                            :increment="0.01" :border-width="5" :show-rating="false"
                                            :rounded-corners="true"
                                            style="display: inline-block; vertical-align: middle;"></star-rating>
                                    </div>
                                </div>
                                <div class="review-text">
                                    {{review.comment}}
                                </div>
                            </div>
                        </template>
                        <template v-else>
                            <div class="review-text">
                                <button @click="fnReviewAdd(review.title,review.tourNo)">리뷰 등록</button>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
            <!-- ========== 사용후기 레이아웃 끝 ========== -->
            <div v-if="showReviewModal" class="modal-overlay">
                <!-- 모달 창 -->
                <div class="modal-container">
                    <h3>사용후기 작성</h3>
                    <table class="review-table">
                        <tr>
                            <th>상품명</th>
                            <td>
                                <!-- 상품명 (제목) -->
                                <input type="text" v-model="newReviewTitle" readonly />
                                <!-- 필요하다면 readonly 제거하고 수정 가능하도록 -->
                            </td>
                        </tr>
                        <tr>
                            <th>이용후기</th>
                            <td>
                                <!-- textarea로 후기 입력 -->
                                <textarea v-model="newReviewComment" rows="5" cols="50"
                                    placeholder="이용후기를 입력해주세요."></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th>평점</th>
                            <td>
                                <!-- 별 5개 (max-rating=5), 사용자가 선택할 수 있도록 v-model -->
                                <star-rating :rating="0" :increment="0.5" :star-size="20" :border-width="2"
                                    :show-rating="false" :rounded-corners="true"></star-rating>
                            </td>
                        </tr>
                    </table>
                    <!-- 작성 완료, 닫기 버튼 -->
                    <div class="btn-area">
                        <button @click="fnReviewSubmit">작성 완료</button>
                        <button @click="fnReviewClose">닫기</button>
                    </div>
                </div>
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

                        showReviewModal: false,
                        newReviewTitle: "",
                        newReviewComment: "",
                        rating: 0,
                        tourNo: 0,
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
                    fnReviewAdd(title, tourNo) {
                        this.newReviewTitle = title || "";  // 혹시 값이 없으면 빈 문자열
                        this.showReviewModal = true;
                        this.tourNo = tourNo;
                    },
                    // ▼ 추가된 부분: 작성 완료 버튼 클릭 시 처리
                    fnReviewSubmit() {
                        // 실제 DB에 저장하려면 여기서 AJAX POST 등으로 서버에 전송
                        let self = this;
                        let nparmap = {
                            tourNo: self.tourNo,
                            userNo: self.sessionId,
                            rating: self.rating,
                            comment: self.newReviewComment
                        };
                        $.ajax({
                            url: "/mypage/user-reviewAdd.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    self.fnReviews();
                                    // 완료 후 모달 닫기
                                    self.showReviewModal = false;
                                } else {
                                    console.error("데이터 로드 실패");
                                }
                            },
                            error: function (error) {
                                console.error("AJAX 에러:", error);
                            }
                        });
                    },
                    // ▼ 추가된 부분: 모달 닫기
                    fnReviewClose() {
                        this.showReviewModal = false;
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
                    console.log("쇼모달 " + this.showReviewModal);
                }
            });
            app.component('star-rating', VueStarRating.default)
            app.mount('#app');
        </script>
    </body>

    </html>