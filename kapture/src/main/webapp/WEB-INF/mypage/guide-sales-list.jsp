<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html lang="ko">

  <head>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" sizes="96x96" href="/img/logo/favicon-96x96.png" />
    <link rel="shortcut icon" href="/img/logo/favicon-96x96.png" />
    <title>상품목록 | kapture</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../../css/kapture-style.css">
  </head>

  <body class="bg-white text-gray-800 text-[16px] tracking-wide">
    <jsp:include page="../common/header.jsp" />
    <div id="app" class="flex max-w-7xl mx-auto px-6 py-8 gap-8 min-h-[700px]">
      <!-- 사이드바 -->
      <div class="w-56 bg-white shadow-md p-4 rounded">
        <ul class="space-y-2 font-semibold">
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-schedule.do' }"
              href="/mypage/guide-schedule.do" class="block px-3 py-2 rounded hover:bg-blue-100">나의 스케줄</a></li>
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-mypage.do' }" href="/mypage/guide-mypage.do"
              class="block px-3 py-2 rounded hover:bg-blue-100">가이드 정보수정</a></li>
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-add.do' }" href="/mypage/guide-add.do"
              class="block px-3 py-2 rounded hover:bg-blue-100">여행상품 등록</a></li>
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-sales-list.do' }"
              href="/mypage/guide-sales-list.do" class="block px-3 py-2 rounded hover:bg-blue-950">상품 목록</a></li>
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'qna.do' }" href="/cs/qna.do"
              class="block px-3 py-2 rounded hover:bg-blue-100">문의하기</a></li>
          <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-qna.do' }" href="/mypage/guide-qna.do"
              class="block px-3 py-2 rounded hover:bg-blue-100">문의 내역 확인</a></li>
        </ul>
      </div>

      <!-- 메인 콘텐츠 -->
      <div class="flex-1">
        <!-- 필터 영역 -->
        <div class="flex flex-wrap gap-4 items-center mb-6">
          <select v-model="statusFilter" class="border px-3 py-2 rounded-md text-sm">
            <option value="">전체</option>
            <option value="tourNo">상품번호</option>
            <option value="title">제목</option>
            <option value="siName">지역명</option>
            <option value="themeName">테마명</option>
          </select>
          <input type="text" v-model="keyword" placeholder="회원명/상품 검색"
            class="border px-3 py-2 rounded-md text-sm w-60" />
          <button @click="loadFilteredData"
            class="bg-blue-950 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm">검색</button>
        </div>

        <div class="space-y-6">
          <div
            class="grid grid-cols-12 gap-4 p-4 border rounded-lg shadow-sm hover:shadow-md bg-white w-full items-start"
            v-for="tour in transactions" :key="tour.tourNo">
            <!-- 썸네일 -->
            <div class="col-span-2 flex justify-center items-center">
              <img :src="tour.filePath" class="w-24 h-24 rounded-full object-cover border" alt="썸네일" />
            </div>

            <!-- 텍스트 정보 영역 -->
            <div class="col-span-9 flex flex-col justify-center gap-1 text-sm text-gray-800 w-full">
              <!-- 1줄: 제목 + 여행 날짜/기간 + 가격 -->
              <div class="flex justify-between flex-wrap items-center">
                <div class="font-semibold text-xl">
                  제목: {{ tour.title }}
                </div>
                <div class="text-gray-600">
                  날짜: {{ formatDate(tour.tourDate) }} / {{ tour.duration }}
                </div>
                <div class="font-bold text-lg">
                  가격: {{ formatCurrency(tour.price) }}
                </div>
              </div>

              <!-- 2줄: 지역 - 테마 / 차량 -->
              <div class="grid grid-cols-3 gap-4 mt-1 text-gray-700 text-sm">
                <div class="flex gap-1">
                  <span class="font-semibold w-10">지역:</span>
                  <span>{{ tour.siName }}</span>
                </div>
                <div class="flex gap-1">
                  <span class="font-semibold w-10">테마:</span>
                  <span>{{ tour.themeName }}</span>
                </div>
                <div class="flex gap-1">
                  <span class="font-semibold w-10">차량:</span>
                  <span>
                    {{ tour.vehicle === 'PUBLIC' ? '대중교통' : (tour.vehicle === 'GUIDE' ? '가이드 차량' : '회사 차량') }}
                  </span>
                </div>
              </div>

              <!-- 요청사항 + 상태/버튼 라인 -->
              <div class="flex justify-between items-start pt-2 mt-1">
                <!-- 왼쪽: 요청사항 -->
                <div class="text-gray-700 text-base">
                  <strong>요청사항:</strong>
                  <span>{{ tour.etc && tour.etc.trim() !== '' ? tour.etc : '없음' }}</span>
                </div>

                <!-- 오른쪽: 상태 + 재게시 버튼 (세로 배치) -->
                <div class="flex flex-col items-end">
                  <div>
                    <strong>상태:</strong>
                    <span :class="{
                      'text-green-600': tour.deleteYN === 'N' && new Date(tour.tourDate) >= today,
                      'text-red-500': tour.deleteYN === 'N' && new Date(tour.tourDate) < today,
                      'text-blue-600': tour.deleteYN === 'Y' && new Date(tour.tourDate) >= today,
                      'text-gray-500': tour.deleteYN === 'Y' && new Date(tour.tourDate) < today
                    }" class="font-semibold">
                      {{ tour.deleteYN === 'N' && new Date(tour.tourDate) >= today ? '판매중'
                      : tour.deleteYN === 'N' && new Date(tour.tourDate) < today ? '미판매' : tour.deleteYN==='Y' && new
                        Date(tour.tourDate)>= today ? '판매완료' : '거래완료' }}
                    </span>
                  </div>

                  <!-- 버튼: 항상 자리는 차지하지만 필요할 때만 보여줌 -->
                  <button :class="[
                      'mt-1 px-3 py-1 rounded text-sm bg-gray-500 hover:bg-gray-600 text-white',
                      !(tour.deleteYN === 'Y' && new Date(tour.tourDate) >= today) && 'invisible'
                    ]" @click="fnToggleDeleteYn(tour)">
                    재게시
                  </button>
                </div>
              </div>
            </div>
            <div class="col-span-1 flex flex-col gap-2 justify-center items-end">
              <button @click="fnGetTourEdit(tour)"
                class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm">
                수정
              </button>
              <button @click="fnRemoveTour(tour.tourNo)"
                class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-sm">
                삭제
              </button>
            </div>
          </div>
          <!-- 페이징 -->
          <div class="mt-6 flex justify-center gap-2">
            <button @click="goPage(page - 1)" :disabled="page === 1"
              class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">이전</button>
            <button v-for="p in totalPages" :key="p" @click="goPage(p)"
              :class="['px-3 py-1 border rounded', p === page ? 'bg-blue-950 text-white' : 'hover:bg-gray-100']">
              {{ p }}
            </button>
            <button @click="goPage(page + 1)" :disabled="page === totalPages"
              class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">다음</button>
          </div>
        </div>
      </div>
    </div>
    <jsp:include page="../common/footer.jsp" />
  </body>
  <script>
    const app = Vue.createApp({
      data() {
        return {
          keyword: '',
          statusFilter: "",
          transactions: [],
          page: 1,
          size: 10,
          totalPages: 1,
          sessionId: "${sessionId}",
          currentPage: '',
          today: new Date()
        };
      },
      methods: {
        setCurrentPage() {
          const path = window.location.pathname;
          this.currentPage = path.substring(path.lastIndexOf("/") + 1);
        },
        loadFilteredData() {
          this.page = 1;
          this.fnGetTransactions();
        },
        fnGetTransactions() {
          let self = this;
          let nparam = {
            keyword: self.keyword,
            page: self.page,
            size: self.size,
            sessionId: self.sessionId
          };
          $.ajax({
            url: '/mypage/getTransactionList.dox',
            method: 'POST',
            data: nparam,
            dataType: 'json',
            success(res) {
              console.log(res);
              self.transactions = res.list;
              self.totalPages = Math.ceil(res.totalCount / self.size);
            }
          });
        },
        goPage(p) {
          if (p < 1 || p > this.totalPages) return;
          this.page = p;
          this.fnGetTransactions();
        },

        formatCurrency(val) {
          return '₩ ' + Number(val).toLocaleString();
        },

        formatDate(date) {
          if (!date) return '-'; // null, undefined 방지
          var d = new Date(date);
          if (isNaN(d)) return '-'; // 유효하지 않은 날짜일 경우
          var year = d.getFullYear();
          var month = ('0' + (d.getMonth() + 1)).slice(-2);
          var day = ('0' + d.getDate()).slice(-2);
          return year + '-' + month + '-' + day;
        },

        fnEdit(item) {
          location.href = "/mypage/guide-edit.do?tourNo=" + item.tourNo;
        },

        fnDelete(tourNo) {
          if (confirm("정말 삭제하시겠습니까?")) {
            $.ajax({
              url: "/tours/deleteTour.dox",
              method: "POST",
              data: { tourNo: tourNo },
              dataType: "json",
              success: (res) => {
                if (res.num > 0) {
                  alert("삭제되었습니다.");
                  this.fnGetTransactions();
                }
              }
            });
          }
        },

        fnToggleDeleteYn(item) {
          let self = this;
          let toggleTo = item.deleteYn === "Y" ? "N" : "Y";
          $.ajax({
            url: "/tours/toggleTourDeleteYn.dox",
            method: "POST",
            data: { tourNo: item.tourNo, deleteYn: toggleTo },
            dataType: "json",
            success: function (res) {
              if (res.num > 0) {
                alert("상태가 변경되었습니다.");
                self.fnGetTransactions();
              }
            }
          });
        }
      },
      mounted() {
        this.setCurrentPage();
        this.fnGetTransactions();
      }
    });
    app.mount('#app');
  </script>
  </body>

  </html>