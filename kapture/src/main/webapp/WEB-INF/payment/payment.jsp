<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title>Kapture - 결제하기</title>
  <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <script src="../../js/page-Change.js"></script>
</head>

<body class="bg-gray-100">
  <div id="app" class="max-w-3xl mx-auto p-6 bg-white rounded-md shadow-md mt-10">

    <h2 class="text-2xl font-semibold mb-6">🛒 장바구니 내역</h2>

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

      <div class="flex justify-between border-t pt-4 mt-6">
        <span class="text-lg font-medium">총 결제 금액</span>
        <span class="text-green-600 text-xl font-bold">₩ {{ totalAmount.toLocaleString() }}</span>
      </div>
      <div v-if="exchangeRate">
        <p class="text-sm text-gray-500">💵 USD 기준: $ {{ totalAmountUSD }}</p>
      </div>

      <div class="flex justify-end gap-4 mt-6">
        <button @click="openPaypalModal" class="bg-yellow-300 hover:bg-yellow-400 text-black font-bold py-2 px-4 rounded">
          PayPal 결제
        </button>
        <button @click="payWithCard" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
          다른방법으로 결제
        </button>
      </div>
    </div>

    <!-- 모달 영역 -->
    <div v-if="paypalModalVisible" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
      <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md max-h-[90vh] overflow-hidden">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-semibold">PayPal 결제</h3>
          <button @click="paypalModalVisible = false" class="text-gray-500 hover:text-black">✕</button>
        </div>
        
        <!-- ⬇⬇ 여기 스크롤 영역 -->
        <div
          class="portone-ui-container overflow-y-auto"
          style="max-height: 60vh;"
          data-portone-ui-type="paypal-spb"
        ></div>
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
          sessionId: "${sessionId}",
          paypalModalVisible: false
        };
      },
      computed: {
        totalAmount() {
          return this.selectedItems.reduce((sum, item) => sum + (item.price * item.numPeople), 0);
        },
        totalAmountUSDValue() {
          if (!this.exchangeRate || this.totalAmount === 0) return null;
          return Number((this.totalAmount / this.exchangeRate).toFixed(2));
        },
        totalAmountUSD() {
          if (!this.exchangeRate || this.totalAmount === 0) return null;
          return (this.totalAmount / this.exchangeRate).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        },
        dynamicTitle() {
          if (this.selectedItems.length === 0) return "한국 여행 패키지";
          if (this.selectedItems.length === 1) return this.selectedItems[0].title;
          return this.selectedItems[0].title + " 외 " + (this.selectedItems.length - 1) + "건";
        },
        selectedIds() {
          return this.selectedItems.map(item => item.basketNo);
        },
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
              self.selectedItems = [...data.basketList];
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
              self.$nextTick(() => {
                self.loadPaypalButton();
              });
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
          const self = this;
          if (this.selectedItems.length === 0) {
            alert("결제할 상품을 선택해주세요!");
            return;
          }
          const IMP = window.IMP;
          IMP.init("imp08653517");
          IMP.request_pay({
            channelKey: "channel-key-8ebf626d-6066-4986-bebd-8d5b5db76054", // 너의 채널 키로 변경
            pg: "eximbay",
            merchant_uid: "order_" + new Date().getTime(), // ✅ 고유한 주문번호
            name: this.dynamicTitle,
            amount: 100,  //this.totalAmount, 
            currency: "KRW",
            buyer_email: "test@portone.io",
            buyer_name: "구매자이름",
            buyer_tel: "010-1234-5678",
            buyer_addr: "서울특별시 강남구 삼성동",
            popup: true,
          }, function(rsp) {
            if (rsp.success) {
              alert("✅ 결제 성공!");
              self.fnPaymentSave(rsp.paid_amount, rsp.pay_method, rsp.merchant_uid);
            } else {
              alert("❌ 결제 실패: " + rsp.error_msg);
            }
          });
        },

        openPaypalModal() {
          this.paypalModalVisible = true;
          this.$nextTick(() => {
            this.loadPaypalButton(); // 모달 DOM 렌더링 후 실행
          });
        },

        loadPaypalButton() {
          const self = this;
          const IMP = window.IMP;
          IMP.init("imp08653517");
          const amount = this.totalAmountUSDValue;
          if (!amount || amount <= 0) return;
          const requestData = {
            channelKey: "channel-key-45f93c04-3fc8-4d28-ae5a-38adcec081cd",
            pay_method: "paypal",
            amount: amount,
            currency: "USD",
            name: this.dynamicTitle || "한국 여행 패키지",
            popup: true
          };
          const container = document.querySelector(".portone-ui-container");
          if (container) {
            IMP.loadUI("paypal-spb", requestData, (rsp) => {
              if (rsp.success) {
                self.fnPaymentSave(rsp.paid_amount, rsp.pay_method, rsp.merchant_uid);
              } else {
                alert("❌ PayPal 결제 실패: " + rsp.error_msg);
              }
            });
          }
        },

        fnPaymentSave(amount, method, merchant_uid) {
          const self = this;
          let nparam = {
            selectedIds: self.selectedIds,
              userNo: self.sessionId,
              amount: amount,
              method: method,
              merchantId: merchant_uid
          }
          $.ajax({
            url: "/payment/save.dox",
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify(nparam),
            success(res) {
              if (res.result === "success") {
                // ✅ POST 방식으로 결제 완료 페이지 이동
                pageChange("/payment/success.do", { merchantId: merchant_uid });
              } else {
                  alert("결제 정보 저장 실패");
              }
            },
            error() {
              alert("서버와 통신 중 오류 발생");
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
