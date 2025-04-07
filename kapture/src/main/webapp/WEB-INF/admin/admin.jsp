<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <title>Admin 대시보드</title>
        <style>
            .dashboard {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                padding: 30px;
                max-width: 1000px;
                /* ✅ 폭 제한 */
                margin: 0 auto;
                /* ✅ 가운데 정렬 */
            }

            .card {
                flex: 0 0 48%;
                /* ✅ 한 줄 2개씩 */
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                padding: 20px;
                margin-bottom: 20px;
                box-sizing: border-box;
                min-height: 250px;
                /* ✅ 높이 균일 */
                transition: transform 0.2s ease;
            }

            .card:hover {
                transform: translateY(-4px);
            }

            .card.wide {
                flex: 0 0 100%;
            }

            .detail-btn {
                background-color: #3498db;
                color: #fff;
                border: none;
                border-radius: 6px;
                padding: 6px 12px;
                font-size: 13px;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .detail-btn:hover {
                background-color: #2980b9;
            }
        </style>
    </head>

    <body>
        <jsp:include page="menu.jsp"></jsp:include>
        <div id="app">
            <div class="dashboard">
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3>매출 현황</h3>
                        <button class="detail-btn" @click="goToDetail('sales')">상세보기</button>
                    </div>
                    <div id="chart1"></div>
                </div>

                <div class="card">
                    <h3>인기 테마 TOP5</h3>
                    <div id="chart2"></div>
                </div>

                <div class="card wide">
                    <h3>총 예약 수</h3>
                    <div id="chart3"></div>
                </div>

                <div class="card wide">
                    <h3>최근 리뷰 5건</h3>
                    <button class="detail-btn" @click="goToDetail('sales')">상세보기</button>
                    <ul style="margin-top: 10px;">
                        <li v-for="r in reviewList" :key="r.TOUR_NO" style="margin-bottom: 12px;">
                            <strong>{{ r.TITLE }}</strong> ({{ r.RATING }}⭐)<br />
                            <span style="color:gray;">"{{ r.COMMENT }}"</span><br />
                            <small style="color: #888;">작성자: {{ r.USERFIRSTNAME }} {{ r.USERLASTNAME }}</small>
                            
                        </li>
                    </ul>
                </div>

                <div class="card wide">
                    <h3>최근 등록 상품</h3>
                    <ul id="latestProducts" style="margin-top: 10px;"></ul>
                </div>
            </div>
        </div>
    </body>

    </html>
    <script>
        // ✅ Vue 바깥 전역에 정의
        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        const app = Vue.createApp({
            data() {
                return {
                    reviewList: []
                };
            },
            methods: {
                fn() {
                    this.loadChart1();  // chart1만 관리
                    this.loadChart2();
                    this.loadChart3();
                    this.loadLatestReviews();
                },

                // ✅ chart1: 매출 차트 불러오기 (분리)
                loadChart1() {
                    $.ajax({
                        url: "/admin/sales/summary.dox",
                        type: "POST",
                        dataType: "json",
                        success: function (res) {
                            const years = res.salesList.map(item => item.YEAR);
                            const totals = res.salesList.map(item => item.TOTALSALES);

                            const options = {
                                series: [{ name: '년도별 매출', data: totals }],
                                chart: { type: 'bar', height: 250 },
                                dataLabels: {
                                    enabled: true,
                                    formatter: function (val) {
                                        return numberWithCommas(val) + '원';
                                    },
                                    style: { fontWeight: 'bold' }
                                },
                                xaxis: { categories: years },
                                tooltip: {
                                    y: {
                                        formatter: function (val) {
                                            return numberWithCommas(val) + '원';
                                        }
                                    }
                                },
                                title: { text: '년도별 매출 비교', align: 'left' },
                                fill: { opacity: 1 }
                            };

                            const chart1 = new ApexCharts(document.querySelector("#chart1"), options);
                            chart1.render();
                        },
                        error: function () {
                            console.error("chart1 매출 데이터 불러오기 실패");
                        }
                    });
                },

                // ✅ chart2
                loadChart2() {
                    $.ajax({
                        url: "/admin/theme/summary.dox",
                        type: "POST",
                        dataType: "json",
                        success: function (res) {
                            if (!res.themeList || res.themeList.length === 0) {
                                $("#chart2").html("<p style='text-align:center;'>데이터가 없습니다</p>");
                                return;
                            }

                            const total = res.totalCount;
                            const top5 = res.themeList.slice(0, 5);
                            const labels = top5.map(item => item.THEME);
                            const counts = top5.map(item => item.COUNT);

                            const options = {
                                series: counts,
                                chart: { type: 'pie', height: 250 },
                                labels: labels,
                                tooltip: {
                                    y: {
                                        formatter: function (val) {

                                            return numberWithCommas(val) + '건'; // ✅ 간단하게 숫자만
                                        }
                                    }
                                },
                                dataLabels: {
                                    enabled: true,
                                    formatter: function (val, opts) {
                                        const label = opts?.w?.config?.labels?.[opts.seriesIndex];
                                        return val.toFixed(1) + "%";
                                    },
                                    style: {
                                        fontSize: '14px',
                                        fontWeight: 'bold'
                                    }
                                },
                                responsive: [{
                                    breakpoint: 480,
                                    options: {
                                        chart: { width: 200 },
                                        legend: { position: 'bottom' }
                                    }
                                }]
                            };

                            const chart2 = new ApexCharts(document.querySelector("#chart2"), options);
                            chart2.render();
                        },
                        error: function () {
                            console.error("chart2 테마 데이터 불러오기 실패");
                        }
                    });
                },

                // ✅ chart3
                loadChart3() {
                    const options = {
                        series: [{
                            name: "Desktops",
                            data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
                        }],
                        chart: {
                            height: 300,
                            type: 'line',
                            zoom: { enabled: false }
                        },
                        dataLabels: { enabled: false },
                        stroke: { curve: 'straight' },
                        title: { text: 'Product Trends by Month', align: 'left' },
                        grid: {
                            row: { colors: ['#f3f3f3', 'transparent'], opacity: 0.5 }
                        },
                        xaxis: {
                            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep']
                        }
                    };

                    const chart3 = new ApexCharts(document.querySelector("#chart3"), options);
                    chart3.render();
                },
                goToDetail(type) {
                    if (type === 'sales') {
                        window.location.href = '/admin/pay.do';
                    }
                },
                numberWithCommas: function (x) {
                    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },
                loadLatestReviews() {
                    $.ajax({
                        url: "/admin/review/latest.dox",
                        type: "POST",
                        dataType: "json",
                        success: (res) => {
                            console.log(res);
                            this.reviewList = res.reviews; // ✅ 바인딩만 하면 끝
                        },
                        error: () => {
                            console.error("리뷰 로딩 실패");
                        }
                    });
                }



            },

            mounted() {
                this.fn();

            }
        });

        app.mount('#app');
    </script>