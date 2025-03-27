<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Kapture - 결제하기</title>
  <script src="https://cdn.jsdelivr.net/npm/vue@3"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script> <!-- ✅ 포트원 SDK -->
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100">
  <div id="app" class="max-w-3xl mx-auto p-6 bg-white rounded-md shadow-md mt-10">

    <h2 class="text-2xl font-semibold mb-6">🛒 장바구니 내역</h2>

    <div v-if="basketList.length === 0" class="text-gray-500">장바구니에 상품이 없습니다.</div>

    <div v-else class="space-y-4">
      <div v-for="item in basketList" :key="item.basketNo" class="p-4 border rounded-md shadow-sm">
        <div class="flex justify-between items-center">
          <div>
            <h3 class="text-lg font-semibold">{{ item.title }}</h3>
            <p class="text-sm text-gray-600">인원: {{ item.numPeople }}명</p>
            <p class="text-sm text-gray-600">일자: {{ item.tourDate }}</p>
          </div>
          <div class="text-blue-600 font-bold text-lg">
            ₩{{ (item.price * item.numPeople).toLocaleString() }}
          </div>
        </div>
      </div>

      <div class="flex justify-between border-t pt-4 mt-6">
        <span class="text-lg font-medium">총 결제 금액</span>
        <span class="text-green-600 text-xl font-bold">₩{{ totalAmount.toLocaleString() }}</span>
      </div>

      <div class="flex justify-end gap-4 mt-6">
        <button @click="payWithPaypal" class="bg-yellow-300 hover:bg-yellow-400 text-black font-bold py-2 px-4 rounded">
          PayPal 결제
        </button>
        <button @click="payWithCard" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
          카드 결제
        </button>
      </div>
    </div>

  </div>

  <script>
    const app = Vue.createApp({
      data() {
        return {
          basketList: [],
          sessionId: "${sessionId}"
        };
      },
      computed: {
        totalAmount() {
          return this.basketList.reduce((sum, item) => sum + (item.price * item.numPeople), 0);
        }
      },
      methods: {
        getBasketList() {
          const self = this;
          $.ajax({
            url: "/basket/getBasketList.dox",
            type: "POST",
            dataType: "json",
            data: { sessionId: self.sessionId },
            success(data) {
              self.basketList = data.basketList;
            },
            error() {
              alert("장바구니 불러오기 실패");
            }
          });
        },
        payWithCard() {
          const IMP = window.IMP;
          IMP.init("imp08653517"); // ✅ 포트원 가맹점 식별코드 (테스트용이면 imp19424728)

          IMP.request_pay({
            pg: 'paymentwall', // 또는 eximbay, toss 등 선택 가능
            pay_method: 'card',
            name: '한국 여행 패키지',
            amount: this.totalAmount,
            buyer_email: 'test@example.com',
            buyer_name: '테스트회원',
            buyer_tel: '01012345678',
            buyer_addr: '서울 강남구',
            buyer_postcode: '12345'
          }, (rsp) => {
            if (rsp.success) {
              alert("✅ 결제 성공!");
              // 👉 백엔드 결제 정보 저장 로직 호출
            } else {
              alert("❌ 결제 실패: " + rsp.error_msg);
            }
          });
        },
        payWithPaypal() {
          const IMP = window.IMP;
          IMP.init("imp08653517");

          IMP.request_pay({
            pg: 'paypal_v2',
            pay_method: 'paypal',
            name: '한국 여행 패키지',
            amount: this.totalAmount,
            buyer_email: 'test@example.com'
          }, (rsp) => {
            if (rsp.success) {
              alert("✅ PayPal 결제 성공!");
              // 👉 백엔드 결제 정보 저장 로직 호출
            } else {
              alert("❌ PayPal 결제 실패: " + rsp.error_msg);
            }
          });
        }
      },
      mounted() {
        this.getBasketList();
      }
    });

    app.mount("#app");
  </script>
</body>
</html>
