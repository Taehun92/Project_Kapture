<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>결제 및 수익 관리</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <style>
            body {
                margin: 0;
                padding: 0;
                display: flex;
                font-family: Arial, sans-serif;
            }

            /* 제목 스타일 */
			.page-title {
				text-align: center;
				font-size: 24px;
				font-weight: bold;
				/* margin-top: 20px; */
				margin-left: 220px;
				/* 사이드바 너비(200px) + 여백(20px) */
				padding: 20px;
				display: flex;
				justify-content: center;
				/* 수평 중앙 정렬 */
				align-items: center;
			}

            .title-hr {
                margin-bottom: 30px;
            }

            #app {
                margin-left: 220px;
                padding: 20px;
                width: calc(100% - 220px);
            }

            .date-header {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
            }

            .card-container {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
            }

            .card {
                flex: 1;
                background: #f8f9fa;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }

            .card-icon {
                font-size: 20px;
                margin-bottom: 10px;
            }

            .card h3 {
                font-size: 18px;
                margin-bottom: 10px;
                color: #555;
            }

            .card .value {
                font-size: 24px;
                font-weight: bold;
                color: #333;
            }

            .card .subtext {
                font-size: 14px;
                color: #999;
                margin-top: 5px;
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

            .search-input{
				width: 300px;
			}

        </style>
    </head>

    <body>
        <jsp:include page="menu.jsp"></jsp:include>
        <div id="app">
            <!-- 제목 추가 -->
			<div class="page-title">결제 및 수익 관리</div>
			<hr class="title-hr">
            <div class="date-header" v-text="today"></div>

            <div class="card-container">
                <div class="card">
                    <div class="card-icon">💳</div>
                    <h3>총 거래 금액</h3>
                    <div class="value">{{ formatCurrency(summary.totalAmount) }}</div>
                    <div class="subtext">어제 거래 금액: {{ formatCurrency(summary.yesterdayAmount) }}</div>
                </div>
                <div class="card">
                    <div class="card-icon">👥</div>
                    <h3>총 이용 인원</h3>
                    <div class="value">{{ summary.totalUsers }}명</div>
                    <div class="subtext">총 이용 및 인원 수</div>
                </div>
                <div class="card">
                    <div class="card-icon">📋</div>
                    <h3>거래 내역</h3>
                    <div class="value">{{ summary.approved + summary.rejected }}건</div>
                    <div class="subtext">승인: {{ summary.approved }}건 / 취소: {{ summary.rejected }}건</div>
                </div>
            </div>

            <select v-model="selectedYear" @change="loadChart">
                <option v-for="year in years" :key="year" :value="year">{{ year }}년</option>
            </select>
            <select v-show="tab === 'themeByRegion'" v-model="selectedRegion" @change="loadChart">
                <option disabled value="">지역 선택</option>
                <option v-for="region in regionList" :key="region" :value="region">{{ region }}</option>
            </select>
            <select v-if="tab === 'day'" v-model="selectedMonth" @change="loadChart">
                <option v-for="m in months" :value="m">{{ m }}월</option>
            </select>
            <div>
                <button class="tab-btn" :class="{ active: tab === 'month' }" @click="switchTab('month')">월별</button>
                <button class="tab-btn" :class="{ active: tab === 'themeByRegion' }"
                    @click="switchTab('themeByRegion')">지역 + 테마별 + 타이틀</button>
                <button class="tab-btn" :class="{ active: tab === 'day' }" @click="switchTab('day')">일별</button>
            </div>

            <div id="chart"
                style="width: 100%; max-width: 1200px; height: 600px; margin-top: 30px; margin-bottom: 10px;"></div>

            <div>
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
                <input type="text" v-model="keyword" class="search-input" @keyup.enter="loadFilteredData" placeholder="회원명/상품 검색">
                <button class="search-button" @click="loadFilteredData">검색</button>

                <table class="transaction-table">
                    <thead>
                        <tr>
                            <th>결제일</th>
                            <th>회원 이름</th>
                            <th>상품 제목</th>
                            <th>결제 금액</th>
                            <th>상태</th>
                            <th>인원</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in transactions" :key="item.PAYMENT_DATE + item.USER_FIRSTNAME + item.TITLE">
                            <td>{{ item.PAYMENT_DATE }}</td>
                            <td>{{ item.USER_FIRSTNAME }}</td>
                            <td>{{ item.TITLE }}</td>
                            <td>{{ formatCurrency(item.AMOUNT) }}</td>
                            <td :style="{ color: item.PAYMENT_STATUS === 'PAID' ? 'green' : 'red' }">
                                {{ item.PAYMENT_STATUS }}
                            </td>
                            <td>{{ item.NUM_PEOPLE }}명</td>
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
                        today: '날짜 로딩 중...',
                        tab: 'month',
                        years: ['2023', '2024', '2025'], selectedYear: '2025',
                        selectedRegion: '', regionList: [],
                        months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'], selectedMonth: '01',
                        chart: null,
                        summary: { totalAmount: 0, yesterdayAmount: 0, totalUsers: 0, approved: 0, rejected: 0 },
                        chartOptions: {
                            series: [],
                            chart: {
                                type: 'line',         // ✅ bar → line
                                height: 600,
                                zoom: {
                                    enabled: false    // ✅ 라인차트에서는 확대 기능이 유용할 수 있어요
                                }
                            },
                            colors: ['#3B82F6'],
                            stroke: {
                                curve: 'straight',      // ✅ 부드러운 곡선
                                width: 3
                            },
                            markers: {
                                size: 5               // ✅ 점 크기 지정
                            },
                            dataLabels: {
                                enabled: false
                            },
                            xaxis: {
                                categories: [],
                                labels: {
                                    rotate: -45
                                }
                            },
                            yaxis: {
                                title: {
                                    text: '₩ (만원)'
                                }
                            },
                            fill: {
                                opacity: 1
                            },
                            tooltip: {
                                y: {
                                    formatter: val => "₩ " + val.toLocaleString() + " 만원"
                                }
                            },
                            grid: {
                                padding: {
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: 10
                                },
                                row: {
                                    colors: ['#f3f3f3', 'transparent'], // ✅ 라인 차트용 줄무늬 배경 (선택)
                                    opacity: 0.5
                                }
                            },
                            noData: {
                                text: '데이터가 없습니다 😥',
                                align: 'center',
                                verticalAlign: 'middle',
                                style: { fontSize: '16px' }
                            }
                        },
                        chartOptionsRegion: { // ✅ 지역 테마 전용 복사본
                            series: [], chart: { type: 'bar', height: 600, stacked: false },
                            plotOptions: { bar: { horizontal: false, columnWidth: '50%', borderRadius: 5 } },
                            dataLabels: { enabled: false }, stroke: { show: true, width: 2, colors: ['transparent'] },
                            xaxis: { categories: [], labels: { rotate: -45 } }, yaxis: { title: { text: '₩ (만원)' } },
                            fill: { opacity: 1 },
                            tooltip: { y: { formatter: val => "₩ " + val.toLocaleString() + " 만원" } },
                            grid: { padding: { left: 10, right: 10, top: 10, bottom: 10 } },
                            noData: { text: '데이터가 없습니다 😥', align: 'center', verticalAlign: 'middle', style: { fontSize: '16px' } }
                        }
                    };
                },
                methods: {
                    loadFilteredData() { this.fnGetTransactions(); },
                    setToday() {
                        const now = new Date();
                        const days = ['일', '월', '화', '수', '목', '금', '토'];
                        const year = now.getFullYear(); const month = String(now.getMonth() + 1).padStart(2, '0');
                        const date = String(now.getDate()).padStart(2, '0'); const day = days[now.getDay()];
                        this.today = year + "/" + month + "/" + date + "(" + day + ")";
                    },
                    loadSummary() {
                        $.ajax({
                            url: '/admin/getSummary.dox', method: 'POST', dataType: 'json',
                            success: res => { 
                                console.log(res);
                                this.summary = res.summary; 
                            },
                            error: err => console.error("요약 정보 로딩 실패", err)
                        });
                    },
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
                            success: data => {
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
                    switchTab(tabName) {
                        this.tab = tabName;
                        this.loadChart();
                        if (tabName === 'themeByRegion' && this.regionList.length === 0) this.loadRegionList();
                    },
                    formatCurrency(val) { return "₩ " + Number(val).toLocaleString(); },
                    loadChart() {
                        let self = this;
                        if (self.tab === 'themeByRegion' && !self.selectedRegion) return;
                        $.ajax({
                            url: '/admin/chart.dox', method: 'POST', dataType: 'json',
                            data: {
                                type: self.tab, year: self.selectedYear,
                                month: self.tab === 'day' ? self.selectedMonth : undefined,
                                region: self.tab === 'themeByRegion' ? self.selectedRegion : undefined
                            },
                            success: function (res) {
                                if (self.chart) self.chart.destroy();
                                const options = JSON.parse(JSON.stringify(
                                    self.tab === 'themeByRegion' ? self.chartOptionsRegion : self.chartOptions
                                ));
                                if (self.tab === 'themeByRegion') {
                                    if (!res.series || !res.categories) return;
                                    options.series = res.series;
                                    options.xaxis.categories = res.categories;
                                } else {
                                    const list = res.list || [];
                                    options.series = [{ name: '매출', data: list.map(item => Number(item.TOTAL) || 0) }];
                                    options.xaxis.categories = list.map(item => item.LABEL);
                                    options.colors = ['#3B82F6'];
                                }
                                self.chart = new ApexCharts(document.querySelector("#chart"), options);
                                self.chart.render();
                            },
                            error: err => console.error("차트 로딩 실패", err)
                        });
                    },
                    loadRegionList() {
                        let self = this;
                        $.ajax({
                            url: '/admin/getRegionList.dox', type: 'POST', dataType: 'json',
                            success: function (res) {
                                self.regionList = res.list;
                            },
                            error: err => console.error("❌ 지역 리스트 불러오기 실패", err)
                        });
                    }
                },
                created() { this.setToday(); },
                mounted() {
                    this.loadSummary();
                    this.loadChart();
                    this.fnGetTransactions();
                    this.loadRegionList();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>