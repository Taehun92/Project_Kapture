<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <title>마이페이지</title>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <!-- Vue.js -->
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <!-- rating -->
        <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css">
        <style>
            [v-cloak] {
                display: none !important;
            }
        </style>
    </head>

    <body class="bg-white text-gray-800 text-[16px] tracking-wide">
        <jsp:include page="../common/header.jsp" />
        
        <div id="app" class="flex max-w-6xl mx-auto px-6 py-8 gap-10">
            <!-- 사이드바 -->
            <div class="w-56 bg-white shadow-md p-4 rounded">
                <ul class="space-y-2 font-semibold">
                    <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'user-mypage.do' }" href="/mypage/user-mypage.do" class="block px-3 py-2 rounded hover:bg-blue-100">회원 정보수정</a></li>
                    <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'user-purchase-history.do' }" href="/mypage/user-purchase-history.do" class="block px-3 py-2 rounded hover:bg-blue-100">구매한 상품</a></li>
                    <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'user-reviews.do' }" href="/mypage/user-reviews.do" class="block px-3 py-2 rounded hover:bg-blue-100">이용후기 관리</a></li>
                    <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'qna.do' }" href="/cs/qna.do" class="block px-3 py-2 rounded hover:bg-blue-100">문의하기</a></li>
                    <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'user-unregister.do' }" href="/mypage/user-unregister.do" class="block px-3 py-2 rounded hover:bg-blue-100">회원 탈퇴</a></li>
                </ul>
=======
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <!-- Vue.js -->
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <!-- Star Rating -->
    <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 text-gray-800">
    <!-- 공통 헤더 -->
    <jsp:include page="../common/header.jsp" />

    <div id="app" class="max-w-7xl mx-auto flex py-10 px-4">
        <!-- 사이드 메뉴 -->
        <aside class="w-full md:w-1/4 bg-white rounded-lg shadow-md p-4">
            <ul class="space-y-3">
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-mypage.do' }"
                       href="http://localhost:8080/mypage/user-mypage.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        회원 정보수정
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-purchase-history.do' }"
                       href="http://localhost:8080/mypage/user-purchase-history.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        구매한 상품
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-reviews.do' }"
                       href="http://localhost:8080/mypage/user-reviews.do"
                       class="block px-4 py-2 rounded hover:bg-blue-700">
                        이용후기 관리
                    </a>
                </li>
                <li>
                    <a href="http://localhost:8080/cs/qna.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        문의하기
                    </a>
                </li>
                <li>
                    <a :class="{ 'bg-blue-950 text-white rounded': currentPage === 'user-unregister.do' }"
                       href="http://localhost:8080/mypage/user-unregister.do"
                       class="block px-4 py-2 rounded hover:bg-gray-100">
                        회원 탈퇴
                    </a>
                </li>
            </ul>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="w-3/4 space-y-8">
            <!-- 리뷰 헤더 -->
            <div class="border-b pb-2">
                <h2 class="text-2xl font-semibold">사용후기</h2>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git
            </div>
<<<<<<< HEAD
        
            <!-- 콘텐츠 영역 -->
            <div class="flex-1">
                <div class="border border-gray-200 rounded shadow-sm p-6">
                    <h2 class="text-xl font-bold mb-6">사용후기</h2>
                    <div class="grid grid-cols-1 gap-6">
                        <div v-for="review in reviewsList" class="border border-gray-100 rounded-lg p-4 shadow-sm">
                            <div class="flex gap-4">
                                <img src="../img/1.jpg" class="w-24 h-24 object-cover rounded border" />
                                <div class="flex-1">
                                    <div class="text-sm text-gray-500 mb-1">상품명: {{ review.title }}</div>
                                    <template v-if="review.reviewNo != 0">
                                        <div class="text-sm text-gray-500 mb-1">
                                            <span>작성자: {{review.userFirstName}}</span>
                                            <span v-if="review.userLastName"> {{review.userLastName}}</span>
                                            <span> · {{ review.rUpdatedAt.substring(0, 10) }}</span>
                                        </div>
                                        <div class="mb-2">
                                            평점:
                                            <star-rating :rating="review.rating" :read-only="true" :star-size="14" :increment="1" :border-width="5" :show-rating="false" :rounded-corners="true" style="display: inline-block;"></star-rating>
                                        </div>
                                        <div class="text-sm text-gray-800 mb-2 whitespace-pre-wrap">{{review.comment}}</div>
                                        <div class="flex gap-3 text-sm">
                                            <button @click="fnReviewEdit(review.reviewNo, review.title, review.rating, review.comment)" class="text-blue-600 hover:underline">수정</button>
                                            <button @click="fnReviewRemove(review.reviewNo)" class="text-red-500 hover:underline">삭제</button>
                                        </div>
                                    </template>
                                    <template v-else>
                                        <button @click="fnReviewAdd(review.title, review.tourNo)" class="text-blue-600 hover:underline text-sm">리뷰 등록</button>
                                    </template>
                                </div>
                            </div>
                        </div>
=======

            <!-- 리뷰 리스트 -->
            <div v-for="review in reviewsList" class="bg-white p-6 rounded shadow space-y-4">
                <div class="flex gap-4">
                    <!-- 이미지 & 제목 -->
                    <div class="w-1/4">
                        <img src="../img/1.jpg" alt="상품이미지" class="w-full h-auto rounded">
                        <div class="mt-2 font-semibold">상품명: {{ review.title }}</div>
                    </div>

                    <!-- 후기 내용 -->
                    <div class="w-3/4 space-y-2">
                        <template v-if="review.reviewNo != 0">
                            <div class="text-sm text-gray-600">
                                <span>작성자: {{review.userFirstName}}</span>
                                <span v-if="review.userLastName != null">{{review.userLastName}}</span>
                                <span class="ml-4">작성일: {{review.rUpdatedAt}}</span>
                                <div class="mt-1">
                                    평점:
                                    <star-rating :rating="review.rating" :read-only="true" :star-size="10"
                                                 :increment="1" :border-width="5" :show-rating="false"
                                                 :rounded-corners="true"
                                                 class="inline-block align-middle"></star-rating>
                                </div>
                            </div>
                            <div class="text-gray-700">{{review.comment}}</div>
                            <div class="space-x-2">
                                <button @click="fnReviewEdit(review.reviewNo, review.title, review.rating, review.comment)"
                                        class="px-3 py-1 bg-blue-950 text-white rounded hover:bg-blue-700">
                                    수정
                                </button>
                                <button @click="fnReviewRemove(review.reviewNo)"
                                        class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">
                                    삭제
                                </button>
                            </div>
                        </template>
                        <template v-else>
                            <button @click="fnReviewAdd(review.title, review.tourNo)"
                                    class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600">
                                리뷰 등록
                            </button>
                        </template>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git
                    </div>
                </div>
<<<<<<< HEAD
        
                <!-- 모달 -->
                <div v-if="showReviewModal" v-cloak class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
                    <div class="bg-white p-6 rounded shadow-lg w-full max-w-lg">
                        <h3 class="text-lg font-bold mb-4">사용후기 작성</h3>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-semibold mb-1">상품명</label>
                                <input type="text" v-model="ReviewTitle" class="w-full border px-3 py-2 rounded" readonly />
                            </div>
                            <div>
                                <label class="block font-semibold mb-1">이용후기</label>
                                <textarea v-model="ReviewComment" rows="5" class="w-full border px-3 py-2 rounded" placeholder="이용후기를 입력해주세요."></textarea>
                            </div>
                            <div>
                                <label class="block font-semibold mb-1">평점</label>
                                <star-rating :rating="rating" :increment="1" :star-size="20" :border-width="2" :show-rating="false" :rounded-corners="true" @update:rating="setRating"></star-rating>
                            </div>
                        </div>
                        <div class="mt-6 flex justify-end gap-2">
                            <button @click="fnReviewSubmit" class="bg-blue-950 text-white px-4 py-2 rounded hover:bg-blue-700">작성 완료</button>
                            <button @click="fnReviewClose" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">닫기</button>
                        </div>
=======
            </div>

            <!-- 모달 -->
            <div v-if="showReviewModal"
                 class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                <div class="bg-white rounded-lg p-6 w-full max-w-xl shadow-lg">
                    <h3 class="text-xl font-semibold mb-4">사용후기 작성</h3>
                    <table class="w-full table-auto mb-4">
                        <tr class="border-t">
                            <th class="text-left py-2 pr-4 w-1/4">상품명</th>
                            <td><input type="text" v-model="ReviewTitle" readonly class="w-full border px-3 py-2 rounded" /></td>
                        </tr>
                        <tr class="border-t">
                            <th class="text-left py-2 pr-4">이용후기</th>
                            <td><textarea v-model="ReviewComment" rows="4"
                                          placeholder="이용후기를 입력해주세요."
                                          class="w-full border px-3 py-2 rounded"></textarea></td>
                        </tr>
                        <tr class="border-t">
                            <th class="text-left py-2 pr-4">평점</th>
                            <td>
                                <star-rating :rating="rating" :increment="1" :star-size="20" :border-width="2"
                                             :show-rating="false" :rounded-corners="true"
                                             @update:rating="setRating"></star-rating>
                            </td>
                        </tr>
                    </table>
                    <div class="flex justify-end gap-3">
                        <button @click="fnReviewSubmit"
                                class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">작성 완료</button>
                        <button @click="fnReviewClose"
                                class="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500">닫기</button>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git
                    </div>
                </div>
            </div>
<<<<<<< HEAD
        </div>
        
        <jsp:include page="../common/footer.jsp" />
=======
        </main>
    </div>

    <!-- 공통 푸터 -->
    <jsp:include page="../common/footer.jsp" />
</body>
</html>
>>>>>>> branch 'feature/temp' of https://github.com/Taehun92/Project_Kapture.git

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        reviewsList: [],
                        currentPage: "",

                        showReviewModal: false,
                        ReviewTitle: "",
                        ReviewComment: "",
                        rating: 0,
                        tourNo: 0,

                        editFlg: false,
                        reviewNo: 0,
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
                        this.ReviewTitle = title || "";  // 혹시 값이 없으면 빈 문자열
                        this.showReviewModal = true;
                        this.ReviewComment = "";
                        this.rating = 0;
                        this.tourNo = tourNo;
                        this.editFlg = false;
                    },
                    // ▼ 추가된 부분: 작성 완료 버튼 클릭 시 처리
                    fnReviewSubmit() {
                        // 실제 DB에 저장하려면 여기서 AJAX POST 등으로 서버에 전송
                        let self = this;
                        let nparmap = {
                            tourNo: self.tourNo,
                            userNo: self.sessionId,
                            rating: self.rating,
                            comment: self.ReviewComment,
                            reviewNo: self.reviewNo,
                            editFlg: self.editFlg,
                        };
                        $.ajax({
                            url: "/mypage/user-reviewSave.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    self.fnReviews();
                                    self.editFlg ?  alert("리뷰가 수정되었습니다.") : alert("리뷰가 등록되었습니다.");
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
                    },
                    setRating: function (rating) {
                        this.rating = rating;
                        console.log("this.rating : " + this.rating);
                    },
                    fnReviewEdit(reviewNo, title, rating, comment) {
                        this.ReviewTitle = title || "";  // 혹시 값이 없으면 빈 문자열
                        this.showReviewModal = true;
                        this.ReviewComment = comment;
                        this.rating = rating;
                        this.reviewNo = reviewNo;
                        this.editFlg = true;
                    },
                    fnReviewRemove(reviewNo) {
                        let self = this;
                        if(!confirm("정말로 삭제하시겠습니까?")){
                            return;
                        }
                        let nparmap = {
                            reviewNo: reviewNo,
                        };
                        $.ajax({
                            url: "/mypage/user-reviewRemove.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    self.fnReviews();
                                    alert("리뷰가 삭제되었습니다.");
                                } else {
                                    console.error("데이터 로드 실패");
                                }
                            },
                            error: function (error) {
                                console.error("AJAX 에러:", error);
                            }
                        });
                    }

                },
                mounted() {
                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "http://localhost:8080/main.do";
                    }
                    if (this.sessionRole === 'GUIDE') {
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


