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
    </style>
</head>
<body>
<jsp:include page="menu.jsp"></jsp:include>
<div id="app">
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
    <select v-if="tab === 'day'" v-model="selectedMonth" @change="loadChart">
        <option v-for="m in months" :value="m">{{ m }}월</option>
    </select>
    <div>
        <button class="tab-btn" :class="{ active: tab === 'month' }" @click="switchTab('month')">월별 매주</button>
        <button class="tab-btn" :class="{ active: tab === 'combo' }" @click="switchTab('combo')">카테고리+시간대 매주</button>
        <button class="tab-btn" :class="{ active: tab === 'day' }" @click="switchTab('day')">일별 매주</button>
    </div>
    <div id="chart" style="width: 100%; max-width: 1200px; height: 800px; margin-top: 30px;"></div>
</div>
<script>
const app = Vue.createApp({
    data() {
        return {
            today: '날짜 로딩 중...',
            tab: 'month',
            years: ['2023', '2024', '2025'],
            selectedYear: '2025',
            months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
            selectedMonth: '01',
            chart: null,
            summary: {
                totalAmount: 0,
                yesterdayAmount: 0,
                totalUsers: 0,
                approved: 0,
                rejected: 0
            },
            chartOptions: {
                series: [],
                chart: { type: 'bar', height: 600 },
                colors: ['#3B82F6'],
                plotOptions: {
                    bar: { horizontal: false, columnWidth: '50%', distributed: false, borderRadius: 5, borderRadiusApplication: 'end' }
                },
                dataLabels: { enabled: false },
                stroke: { show: true, width: 2, colors: ['transparent'] },
                xaxis: { categories: [], labels: { rotate: -45 } },
                yaxis: { title: { text: '₩ (만원)' } },
                fill: { opacity: 1 },
                tooltip: {
                    y: { formatter: val => "₩ " + val.toLocaleString() + " 만원" }
                },
                grid: { padding: { left: 10, right: 10, top: 10, bottom: 10 } },
                noData: {
                    text: '데이터가 없습니다 😥', align: 'center', verticalAlign: 'middle',
                    style: { fontSize: '16px' }
                }
            }
        };
    },
    methods: {
        setToday() {
            const now = new Date();
            const days = ['일', '월', '화', '수', '목', '금', '토'];

            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0');
            const dayIndex = now.getDay();
            const day = days[dayIndex];

            const todayText = `${year}/${month}/${date} (${day})`;
            this.today = todayText;
        },
        loadSummary() {
            $.ajax({
                url: '/admin/getSummary.dox',
                method: 'POST',
                dataType: 'json',
                success: res => {
                    this.summary = res.summary;
                },
                error: err => console.error("요약 정보 로딩 실패", err)
            });
        },
        switchTab(tabName) {
            this.tab = tabName;
            this.loadChart();
        },
        formatCurrency(val) {
            return "₩ " + Number(val).toLocaleString();
        },
        loadChart() {
            let self = this;
            $.ajax({
                url: '/admin/chart.dox',
                method: 'POST',
                data: {
                    type: self.tab,
                    year: self.selectedYear,
                    month: self.tab === 'day' ? self.selectedMonth : undefined
                },
                dataType: 'json',
                success: function (res) {
                    if (self.chart) self.chart.destroy();
                    if (self.tab === 'combo') {
                        self.chartOptions.series = res.series;
                        self.chartOptions.xaxis.categories = res.categories;
                        self.chartOptions.colors = undefined;
                    } else {
                        const list = res.list || [];
                        const labels = list.map(item => item.LABEL);
                        const values = list.map(item => Number(item.TOTAL) || 0);
                        self.chartOptions.series = [{ name: '매주', data: values }];
                        self.chartOptions.xaxis.categories = labels;
                        self.chartOptions.colors = ['#3B82F6'];
                    }
                    self.chart = new ApexCharts(document.querySelector("#chart"), self.chartOptions);
                    self.chart.render();
                },
                error: err => console.error("차트 로딩 실패", err)
            });
        }
    },
    created() {
        this.setToday();
    },
    mounted() {
        this.loadSummary();
        this.loadChart();
    }
});
app.mount('#app');
</script>
</body>
</html>