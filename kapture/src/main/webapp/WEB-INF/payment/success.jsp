<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 완료</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 font-sans">
    <jsp:include page="../common/header.jsp" />

    <div id="app" class="max-w-4xl mx-auto p-6">
        <!-- 타이틀 + 결제번호 -->
        <h2 class="text-3xl font-bold text-green-600 text-center mb-2">🎉 결제가 완료되었습니다!</h2>
        <p v-if="payments && payments.length > 0" class="text-center text-gray-500 mb-8 text-sm">
            결제번호 : {{ payments[0].paymentNo }}
        </p>
        <p v-else class="text-center text-gray-400 text-sm">
        결제 정보를 불러오는 중입니다...
        </p>

        <!-- 결제 상품 목록 -->
        <div v-for="item in payments" :key="item.paymentNo + '-' + item.tourNo" class="bg-white shadow rounded-lg p-6 mb-6">
            <div class="mb-2"><span class="font-semibold">상품명:</span> {{ item.title }}</div>
            <div class="mb-2"><span class="font-semibold">상품 가격:</span> ₩ {{ (item.price * item.numPeople).toLocaleString("ko-KR") }}</div>
            <div class="mb-2"><span class="font-semibold">여행 일정:</span> {{ item.duration }}</div>
            <div class="mb-2"><span class="font-semibold">출발 날짜:</span> {{ item.tourDate }}</div>
            <div class="mb-2"><span class="font-semibold">결제 인원:</span> {{ item.numPeople }}명</div>
        </div>

        <!-- 총 결제 금액 -->
        <div v-if="payments.length > 0" class="text-right text-xl font-bold mt-4 font-mono">
            총 결제 금액: ₩ {{ formattedAmount }}
        </div>

        <!-- 버튼 영역 -->
        <div class="flex justify-center gap-4 mt-10">
            <a href="/main.do" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition">메인으로</a>
            <a href="/mypage.do" class="bg-gray-600 text-white px-6 py-2 rounded hover:bg-gray-700 transition">마이페이지로</a>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            payments: [],
            merchantId : "${map.merchantId}",
            paymentList: []
        };
    },
    computed: {
        totalAmount() {
            return this.payments.reduce((sum, item) => {
                return sum + (item.price * item.numPeople);
            }, 0);
        },
        formattedAmount() {
            return this.totalAmount.toLocaleString("ko-KR");
        }
    },
    methods: {
        fetchPaymentList() {
            let self = this;
            $.ajax({
                url: "/payment/success.dox",
                type: "POST",
                data: { merchantId: self.merchantId },
                dataType: "json",
                success: (res) => {
                    console.log("응답 객체:", res);
                    self.payments = res.paymentList;
                    
                },
                error: (res) => {
                    alert("결제 정보를 불러오는 데 실패했습니다.");
                }
            });
        }
    },
    mounted() {
        this.fetchPaymentList();
    }
});
app.mount("#app");
</script>
