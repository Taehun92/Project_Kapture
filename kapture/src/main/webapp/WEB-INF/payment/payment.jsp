<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Kapture - 결제하기</title>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100">
  <div id="app" class="max-w-3xl mx-auto p-6 bg-white rounded-md shadow-md mt-10">

    <h2 class="text-2xl font-semibold mb-6">🛒 장바구니 내역</h2>

    <!-- ✅ 전체 선택 체크박스 -->
    <div class="flex items-center mb-4">
      <input type="checkbox" id="selectAll" v-model="selectAll" @change="toggleAll" />
      <label for="selectAll" class="ml-2 text-gray-700 font-medium">전체 선택</label>
    </div>

    <div v-if="basketList.length === 0" class="text-gray-500">장바구니에 상품이 없습니다.</div>

    <div v-else class="space-y-4">
      <div v-for="item in basketList" :key="item.basketNo" class="p-4 border rounded-md shadow-sm">
        <div class="flex justify-between items-center">
          <div class="flex items-start gap-2">
            <input type="checkbox" :value="item" v-model="selectedItems" @change="updateSelectAll" />
            <div>
              <h3 class="text-lg font-semibold">{{ item.title }}</h3>
              <p class="text-sm text-gray-600">인원: {{ item.numPeople }}명</p>
              <p class="text-sm text-gray-600">일자: {{ item.tourDate }}</p>
            </div>
          </div>
          <div class="text-blue-600 font-bold text-lg">
            ₩{{ (item.price * item.numPeople).toLocaleString() }}
          </div>
        </div>
      </div>

      <!-- ✅ 총 결제 금액 -->
      <div class="flex justify-between border-t pt-4 mt-6">
        <span class="text-lg font-medium">총 결제 금액</span>
        <span class="text-green-600 text-xl font-bold">₩ {{ totalAmount.toLocaleString() }}</span>
      </div>
      <div v-if="exchangeRate">
        <p class="text-sm text-gray-500">💵 USD 기준: $ {{ totalAmountUSD }}</p>
      </div>

      <!-- ✅ 결제 버튼 -->
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
          selectedItems: [],
          selectAll: true,
          exchangeRate: 0,
          sessionId: "${sessionId}"
        };
      },
      computed: {
        totalAmount() {
          return this.selectedItems.reduce((sum, item) => sum + (item.price * item.numPeople), 0);
        },
        totalAmountUSD() {
          if (!this.exchangeRate || this.totalAmount === 0) return null;

          const usd = this.totalAmount / this.exchangeRate;
          return usd.toLocaleString(undefined, {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
          });
        },
        dynamicTitle() {
          if (this.selectedItems.length === 0) return "한국 여행 패키지";
          if (this.selectedItems.length === 1) return this.selectedItems[0].title;
          return this.selectedItems[0].title + " 외 " + (this.selectedItems.length - 1) + "건";
        }
      },
      methods: {
        getBasketInfoList() {
          const self = this;
          $.ajax({
            url: "/payment/getBasketInfoList.dox",
            type: "POST",
            dataType: "json",
            data: { sessionId: self.sessionId },
            success(data) {
              self.basketList = data.basketList;
              console.log(self.basketList);
              self.selectedItems = [...data.basketList]; // ✅ 기본 전체 선택
            },
            error() {
              alert("장바구니 불러오기 실패");
            }
          });
        },

        getExchangeRate() {
          const self = this;
          $.ajax({
            url: "/exchangeRate/USD",
            type: "GET",
            dataType: "json",
            success(data) {
              self.exchangeRate = parseFloat(data.rate);
              console.log("환율 불러옴 (USD): " + self.exchangeRate);
              console.log("총 원화 금액:", self.totalAmount);
              console.log("환율:", self.exchangeRate);
              console.log("USD 금액:", self.totalAmountUSD);
            },
            error() {
              alert("환율 정보를 불러오는 데 실패했습니다.");
            }
          });
        },

        toggleAll() {
          this.selectedItems = this.selectAll ? [...this.basketList] : [];
        },
        updateSelectAll() {
          this.selectAll = this.selectedItems.length === this.basketList.length;
        },
        payWithCard() {
          if (this.selectedItems.length === 0) {
            alert("결제할 상품을 선택해주세요!");
            return;
          }

          const IMP = window.IMP;
          IMP.init("imp08653517");

          IMP.request_pay({
            pg: 'paymentwall',
            pay_method: 'card',
            name: this.dynamicTitle,
            amount: this.totalAmount,
            buyer_email: 'test@example.com',
            buyer_name: '테스트회원',
            buyer_tel: '01012345678',
            buyer_addr: '서울 강남구',
            buyer_postcode: '12345'
          }, (rsp) => {
            if (rsp.success) {
              alert("✅ 결제 성공!");
              const selectedIds = this.selectedItems.map(item => item.basketNo);
              $.ajax({
                url: "/payment/save.dox",
                type: "POST",
                dataType: "json",
                data: {
                  imp_uid: rsp.imp_uid,
                  amount: rsp.paid_amount,
                  selectedBasketList: selectedIds
                },
                success(data) {
                  window.location.href = "/payment/success.do";
                },
                error() {
                  alert("결제 정보 저장 실패");
                }
              });
            } else {
              alert("❌ 결제 실패: " + rsp.error_msg);
            }
          });
        },

        payWithPaypal() {
          if (this.selectedItems.length === 0) {
            alert("결제할 상품을 선택해주세요!");
            return;
          }

          if (!this.totalAmountUSD) {
            alert("USD 환율 정보를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.");
            return;
          }

          const IMP = window.IMP;
          IMP.init("imp08653517");
          IMP.request_pay({
              channelKey: "{channel-key-45f93c04-3fc8-4d28-ae5a-38adcec081cd}",
              pay_method: "card",
              merchant_uid: "order_"+ new Date().getTime(), // 상점에서 관리하는 주문 번호
              name: this.dynamicTitle,
              amount: this.totalAmountUSD,
              currency: "USD",
              buyer_email: "test@portone.io",
              buyer_name: "구매자이름",
              buyer_tel: "010-1234-5678",
              buyer_addr: "서울특별시 강남구 삼성동",
              buyer_postcode: "123-456",
              m_redirect_url: "{결제 완료 후 리디렉션 될 URL}",
            },
            function (rsp) {
            if (rsp.success) {
              alert("✅ PayPal 결제 성공!");
              const selectedIds = this.selectedItems.map(item => item.basketNo);
              $.ajax({
                url: "/payment/save.dox",
                type: "POST",
                dataType: "json",
                data: {
                  imp_uid: rsp.imp_uid,
                  amount: rsp.paid_amount,
                  selectedBasketList: selectedIds
                },
                success(data) {
                  window.location.href = "/payment/success.do";
                },
                error() {
                  alert("결제 정보 저장 실패");
                }
              });
            } else {
              alert("❌ PayPal 결제 실패: " + rsp.error_msg);
            }
          });
        }
      },
      mounted() {
        this.getBasketInfoList();
        this.getExchangeRate();
      }
    });

    app.mount("#app");
  </script>
</body>
</html>
