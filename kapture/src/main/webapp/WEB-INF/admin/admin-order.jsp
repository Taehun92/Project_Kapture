<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>주문내역 관리</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            body {
                margin: 0;
                padding: 0;
                display: flex;
                font-family: Arial, sans-serif;
            }

            #sidebar {
                width: 220px;
                background-color: #222;
                color: #fff;
                padding: 20px;
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
            }

            #app {
                margin-left: 220px;
                padding: 20px;
                width: calc(100% - 220px);
            }

            .tab-btn {
                margin-right: 10px;
                padding: 8px 12px;
                border: 1px solid #ccc;
                background: #f4f4f4;
                cursor: pointer;
                border-radius: 4px;
            }

            .tab-btn.active {
                background-color: #007bff;
                color: white;
            }

            select {
                margin: 10px 5px 10px 0;
                padding: 5px;
            }

            .transaction-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            .transaction-table th,
            .transaction-table td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: center;
            }

            .transaction-table th {
                background-color: #f1f1f1;
            }

            .search-input,
            .search-select,
            .search-date {
                padding: 10px 14px;
                font-size: 16px;
                height: 40px;
                border: 1px solid #ccc;
                border-radius: 6px;
                margin-right: 10px;
                box-sizing: border-box;
            }

            .search-button {
                padding: 10px 20px;
                font-size: 16px;
                height: 40px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            .search-button:hover {
                background-color: #0056b3;
            }

            .refunded-button {
                margin-top: 5px;
                padding: 2px 5px;
                background-color: #ff0000;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            .refunded-button:hover {
                background-color: #b30000;
            }
        </style>
    </head>

    <body>
        <jsp:include page="menu.jsp"></jsp:include>
        <div id="app">
            <input type="date" v-model="startDate" class="search-date">
            ~
            <input type="date" v-model="endDate" class="search-date">
            <select v-model="statusFilter" class="search-select">
                <option value="">전체</option>
                <option value="결제완료">결제완료</option>
                <option value="거래완료">거래완료</option>
                <option value="환불요청">환불요청</option>
                <option value="환불완료">환불완료</option>
            </select>
            <input type="text" v-model="keyword" class="search-input" placeholder="회원명/상품 검색">
            <button class="search-button" @click="loadFilteredData">검색</button>

            <table class="transaction-table">
                <thead>
                    <tr>
                        <th>상품 번호</th>
                        <th>결제일</th>
                        <th>회원 이름</th>
                        <th>상품 제목</th>
                        <th>여행 날짜</th>
                        <th>여행 기간</th>
                        <th>결제 금액</th>
                        <th>상태</th>
                        <th>인원</th>
                        <th>정보</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in transactions" :key="item.PAYMENT_DATE + item.USER_FIRSTNAME + item.TITLE">
                        <td>{{ item.TOUR_NO }}</td>
                        <td v-html="formatDate(item.PAYMENT_DATE)"></td>
                        <td>
                            {{ item.USER_FIRSTNAME }}
                            <template v-if="USER_LASTNAME != 'N/A'">{{ item.USER_LASTNAME }}</template>
                        </td>
                        <td>{{ item.TITLE }}</td>
                        <td v-html="formatDate(item.TOUR_DATE)"></td>
                        <td>{{ item.DURATION }}</td>
                        <td>{{ formatCurrency(item.AMOUNT) }}</td>
                        <td :style="{ color: (item.PAYMENT_STATUS === '결제완료' || item.PAYMENT_STATUS === '거래완료')  ? 'green' : item.PAYMENT_STATUS === '환불요청' ? 'red' : 'blue' }">
                            {{ item.PAYMENT_STATUS }}
                            <div v-if="item.PAYMENT_STATUS === '환불요청'">
                                <button class="refunded-button" @click="fnRefunded(item.PAYMENT_NO)">환불처리</button>
                            </div>
                        </td>
                        <td>{{ item.NUM_PEOPLE }}명</td>
                        <td><button>보기</button></td>
                    </tr>
                </tbody>
            </table>
            <div style="margin-top: 20px; text-align: center;">
                <button class="tab-btn" @click="goPage(page - 1)" :disabled="page === 1">이전</button>
                <button v-for="p in totalPages" :key="p" class="tab-btn" :class="{ active: p === page }"
                    @click="goPage(p)">
                    {{ p }}
                </button>
                <button class="tab-btn" @click="goPage(page + 1)" :disabled="page === totalPages">다음</button>
            </div>
        </div>
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        startDate: '',
                        endDate: '',
                        statusFilter: '',
                        keyword: '',
                        transactions: [],
                        page: 1,
                        size: 10,
                        totalCount: 0,
                        totalPages: 1,
                    };
                },
                methods: {
                    loadFilteredData() { this.fnGetTransactions(); },
                    fnGetTransactions() {
                        let self = this;
                        let nparmap = {
                            startDate: self.startDate,
                            endDate: self.endDate,
                            status: self.statusFilter,
                            keyword: self.keyword,
                            page: self.page, size: self.size
                        };
                        $.ajax({
                            url: "/admin/getTransactionList.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                console.log(data);
                                self.transactions = data.list;
                                self.totalCount = data.totalCount;
                                self.totalPages = Math.ceil(data.totalCount / self.size);
                            },
                            error: err => console.error("거래 내역 불러오기 실패", err)
                        });
                    },
                    goPage(p) {
                        if (p < 1 || p > this.totalPages) return;
                        this.page = p;
                        this.fnGetTransactions();
                    },
                    formatCurrency(val) { return "₩ " + Number(val).toLocaleString(); },
                    formatDate(dateStr) {
                        // dateStr 예: "Apr 2, 2025, 12:00:00 AM"
                        let d = new Date(dateStr);
                        if (isNaN(d)) return dateStr; // 유효하지 않은 날짜인 경우 원본 반환

                        let year = d.getFullYear();
                        let month = ('0' + (d.getMonth() + 1)).slice(-2);
                        let day = ('0' + d.getDate()).slice(-2);
                        let hours = ('0' + d.getHours()).slice(-2);
                        let minutes = ('0' + d.getMinutes()).slice(-2);
                        let seconds = ('0' + d.getSeconds()).slice(-2);

                        return year + "-" + month + "-" + day + "<div>" + hours + ":"+ minutes + ":" + seconds + "</div>";
                    },
                    fnRefunded(paymentNo){
                        let self = this;
                        if(!confirm("해당 주문건을 환불하시겠습니까?")){
                            return;
                        }
                        let nparmap = {
                            paymentNo: paymentNo
                        };
                        $.ajax({
                            url: "/admin/refunded.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                console.log(data);
                                if(data.result === "success"){
                                    alert("환불되었습니다.");
                                    self.fnGetTransactions();
                                }else{
                                    alert("환불에 실패했습니다.");
                                }
                            },
                            error: function (err){
                                console.error(err);
							    alert("환불처리 중 오류가 발생했습니다.");
                            } 
                        });
                    }
                },
                mounted() {
                    this.fnGetTransactions();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>