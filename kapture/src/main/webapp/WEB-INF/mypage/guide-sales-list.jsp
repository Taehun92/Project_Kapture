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

    <div id="app" class="flex max-w-6xl mx-auto px-6 py-8 gap-10 min-h-[700px]">
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

      <!-- 콘텐츠 영역 -->
      <div class="flex-1">
        <div class="mb-6 flex items-center gap-4">
          <input v-model="keyword" placeholder="회원명/상품 검색" class="border rounded px-4 py-2 w-80" />
          <button @click="loadFilteredData" class="bg-blue-950 text-white px-4 py-2 rounded">검색</button>
          <a href="/mypage/guide-add.do" class="ml-auto bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
            + 상품 등록
          </a>
        </div>

        <div class="overflow-x-auto">
          <!-- 카드 컨테이너 -->
          <div v-for="item in transactions" :key="item.paymentDate + item.title"
            class="border rounded-lg p-5 shadow bg-white hover:shadow-md transition-shadow flex justify-between items-start">
            <!-- 카드 전체 -->
            <!-- 왼쪽: 정보 -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-2 text-sm text-gray-800 flex-1 leading-tight">
              <!-- 날짜 (글씨색 연하고 기본 크기) -->
              <div class="text-gray-600"><strong>결제일 : </strong> {{ item.paymentDate }}</div>

              <!-- 회원 이름 -->
              <div><strong>회원 이름 : </strong> {{ item.memberName || '-' }}</div>

              <!-- 상품 제목 (굵고 크게) -->
              <div class="text-base font-semibold"><strong>상품 제목:</strong> {{ item.title }}</div>

              <!-- 결제 금액 -->
              <div><strong>결제 금액 : </strong> ₩ {{ Number(item.amount).toLocaleString() }}</div>

              <!-- 상태 -->
              <div>
                <strong>상태 : </strong>
                <span :class="item.paymentStatus === 'PAID' ? 'text-green-600 font-bold' : 'text-red-600'">
                  {{ item.paymentStatus }}
                </span>
              </div>

              <!-- 인원 (굵고 크게) -->
              <div class="text-base font-semibold"><strong>인원 : </strong> {{ item.numPeople }}명</div>

              <!-- 요구사항 (굵고 크게) -->
              <div class="text-base font-semibold"><strong>요구사항 : </strong> {{ item.etc || '-' }}</div>
            </div>

            <!-- 오른쪽: 세로 버튼 -->
            <div class="flex flex-col items-end gap-2 ml-6 mt-1">
              <button @click="fnToggleDeleteYn(item)" :class="item.deleteYn === 'Y' ? 'bg-gray-500' : 'bg-green-600'"
                class="text-white px-4 py-1 rounded text-sm">
                {{ item.deleteYn === 'Y' ? '재게시' : '게시중지' }}
              </button>
              <button @click="fnEdit(item)"
                class="bg-blue-500 text-white px-4 py-1 rounded text-sm hover:bg-blue-600">수정</button>
              <button @click="fnDelete(item.tourNo)"
                class="bg-red-500 text-white px-4 py-1 rounded text-sm hover:bg-red-600">삭제</button>
            </div>
          </div>
        </div>

        <!-- 페이징 -->
        <div class="mt-6 text-center flex justify-center items-center gap-2">
          <button @click="goPage(page - 1)" :disabled="page === 1"
            class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">이전</button>
          <button v-for="p in totalPages" :key="p" @click="goPage(p)"
            :class="['px-3 py-1 border rounded hover:bg-gray-100', { 'bg-blue-950 text-white': p === page }]">
            {{ p }}
          </button>
          <button @click="goPage(page + 1)" :disabled="page === totalPages"
            class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">다음</button>
        </div>
      </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    <script>
      const app = Vue.createApp({
        data() {
          return {
            keyword: '',
            transactions: [],
            page: 1,
            size: 10,
            totalPages: 1,
            sessionId: "${sessionId}",
            currentPage: ''
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

          fnEdit(item) {
            location.href = "/mypage/guide-edit.do?tourNo=" + item.tourNo;
          },

          fnDelete(tourNo) {
            if (confirm("정말 삭제하시겠습니까?")) {
              $.ajax({
                url: "/tours/deleteTour.dox",
                method: "POST",
                data: { tourNo : tourNo },
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