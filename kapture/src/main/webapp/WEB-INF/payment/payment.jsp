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
        <button @click="payWithPaymentwall" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
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
        
        payWithPaymentwall() {
          if (this.selectedItems.length === 0) {
            alert("결제할 상품을 선택해주세요!");
            return;
          }

          const IMP = window.IMP;
          IMP.init("imp08653517");

          IMP.request_pay({
            projectKey: "store-29de8ccc-5022-4e55-94db-056f7c02a373",
            channelKey: "channel-key-b1fa67aa-a1eb-4a2b-8512-3cde91f933c2", // 너의 채널 키로 변경
            merchant_uid: "order_" + new Date().getTime(), // ✅ 고유한 주문번호
            name: this.dynamicTitle,
            amount: this.totalAmount, 
            buyer_name : "홍 길동",
            buyer_email : "toon92@naver.com",
            currency: "KRW",
            m_redirect_url: "/payment/success.do",
            use_test_method: true,
            bypass: {
              widget_code: "t3_1",
              ps: "test",
              country_code: "AM"
            }
          }, function(rsp) {
            if (rsp.success) {
              alert("✅ Paymentwall 결제 성공!");
              const selectedIds = this.selectedItems.map(item => item.basketNo);
              this.fnPaymentSave(selectedIds, rsp.paid_amount);
            } else {
              alert("❌ Paymentwall 결제 실패: " + rsp.error_msg);
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
                const selectedIds = this.selectedItems.map(item => item.basketNo);
                this.fnPaymentSave(selectedIds, rsp.paid_amount);
              } else {
                alert("❌ PayPal 결제 실패: " + rsp.error_msg);
              }
            });
          }
        },
        fnPaymentSave(selectedIds, amount) {
          $.ajax({
            url: "/payment/save.dox",
            type: "POST",
            dataType: "json",
            data: {
              selectedIds: selectedIds,
              userNo: this.sessionId,
              amount: amount,
              selectedBasketList: selectedIds
            },
            success() {
              window.location.href = "/payment/success.do";
            },
            error() {
              alert("결제 정보 저장 실패");
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
