<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title>판매내역</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="../../css/kapture-style.css">
</head>

<body class="bg-white text-gray-800 text-[16px] tracking-wide">
<jsp:include page="../common/header.jsp" />

<div id="app" class="flex max-w-6xl mx-auto px-6 py-8 gap-10">
  <!-- 사이드바 -->
  <div class="w-56 bg-white shadow-md p-4 rounded">
    <ul class="space-y-2 font-semibold">
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-schedule.do' }" href="/mypage/guide-schedule.do" class="block px-3 py-2 rounded hover:bg-blue-100">나의 스케줄</a></li>
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-mypage.do' }" href="/mypage/guide-mypage.do" class="block px-3 py-2 rounded hover:bg-blue-100">가이드 정보수정</a></li>
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-add.do' }" href="/mypage/guide-add.do" class="block px-3 py-2 rounded hover:bg-blue-100">여행상품 등록</a></li>
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'guide-sales-list.do' }" href="/mypage/guide-sales-list.do" class="block px-3 py-2 rounded hover:bg-blue-950">판매내역</a></li>
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'qna.do' }" href="/cs/qna.do" class="block px-3 py-2 rounded hover:bg-blue-100">문의하기</a></li>
      <li><a :class="{ 'bg-blue-950 text-white': currentPage === 'user-unregister.do' }" href="/mypage/user-unregister.do" class="block px-3 py-2 rounded hover:bg-blue-100">회원 탈퇴</a></li>
    </ul>
  </div>

  <!-- 콘텐츠 영역 -->
  <div class="flex-1">
    <div class="mb-6 flex items-center gap-4">
      <input v-model="keyword" placeholder="회원명/상품 검색" class="border rounded px-4 py-2 w-80" />
      <button @click="loadFilteredData" class="bg-blue-950 text-white px-4 py-2 rounded">검색</button>
    </div>

    <div class="overflow-x-auto">
      <table class="min-w-full border border-gray-200 text-sm text-center">
        <thead class="bg-gray-100 text-gray-700">
          <tr>
            <th class="border px-4 py-2">결제일</th>
            <th class="border px-4 py-2">회원 이름</th>
            <th class="border px-4 py-2">상품 제목</th>
            <th class="border px-4 py-2">결제 금액</th>
            <th class="border px-4 py-2">상태</th>
            <th class="border px-4 py-2">인원</th>
            <th class="border px-4 py-2">담당가이드</th>
            <th class="border px-4 py-2">요구사항</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in transactions" :key="item.paymentDate + item.userFirstName + item.title" class="hover:bg-gray-50">
            <td class="border px-4 py-2">{{ item.paymentDate }}</td>
            <td class="border px-4 py-2">{{ item.memberName || '-' }}</td>
            <td class="border px-4 py-2">{{ item.title }}</td>
            <td class="border px-4 py-2">{{ formatCurrency(item.amount) }}</td>
            <td class="border px-4 py-2">
              <span :class="item.paymentStatus === 'PAID' ? 'text-green-600' : 'text-red-500'">
                {{ item.paymentStatus }}
              </span>
            </td>
            <td class="border px-4 py-2">{{ item.numPeople }}명</td>
            <td class="border px-4 py-2">{{ item.guideName }}</td>
            <td class="border px-4 py-2">{{ item.etc }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 페이징 -->
    <div class="mt-6 text-center flex justify-center items-center gap-2">
      <button @click="goPage(page - 1)" :disabled="page === 1" class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">이전</button>
      <button v-for="p in totalPages" :key="p" @click="goPage(p)" :class="['px-3 py-1 border rounded hover:bg-gray-100', { 'bg-blue-950 text-white': p === page }]">
        {{ p }}
      </button>
      <button @click="goPage(page + 1)" :disabled="page === totalPages" class="px-3 py-1 border rounded hover:bg-gray-100 disabled:opacity-50">다음</button>
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
