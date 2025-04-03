<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>
    <link rel="stylesheet" href="../../css/request.css">
	<title>요청 등록</title>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
	<div id="app" class="request-container">
        <table class="request-view-table">
            <tr>
                <th>제목</th>
                <td colspan="3">
                    <div class="input-wrapper">
                        <input v-model="title" placeholder="제목 입력" class="input-field" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>지역</th>
                <td >
                    <div class="input-wrapper">
                        <input v-model="region" placeholder="지역 입력" class="input-field" />
                    </div>
                </td>
                <th>예산</th>
                <td colspan="3">
                    <div class="budget-input-group">
                        <input :value="formattedBudget" @input="onBudgetInput" placeholder="금액 입력" class="budget-input" />
                        <select v-model="currency" class="currency-select">
                            <option value="KRW">원 (₩)</option>
                            <option value="USD">달러 ($)</option>
                            <option value="JPY">엔 (¥)</option>
                            <option value="CNY">위안 (元)</option>
                        </select>
                    </div>
                    <div class="exchange-info" v-if="currency !== 'KRW'">
                        원(₩) 기준: {{ convertedBudget.toLocaleString() }}원
                    </div>
                </td>

            </tr>
            <tr>
                <th>내용</th>
                <td colspan="3">
                    <div id="editor" style="width: 100%; height: 400px;"></div>
                </td>
            </tr>
        </table>
        <div class="btn-group">
            <button class="request-write-btn" @click="fnSave">저장</button>
        </div>
	</div>
    <jsp:include page="../common/footer.jsp" />
</body>

<script>
const app = Vue.createApp({
    data() {
        return {
            title: "",
        contents: "",
        region: "",
        budget: "",
        currency: "KRW",
        sessionId: "${sessionId}",
        exchangeRates: {
            USD: 1350,
            JPY: 9.2,
            CNY: 185
        }
        };
    },
    computed: {
        convertedBudget() {
            if (this.currency === "KRW") return this.budget;
            const rate = this.exchangeRates[this.currency];
            return Math.round(this.budget * rate);
        },
        formattedBudget() {
            if (!this.budget) return '';
            return parseInt(this.budget).toLocaleString();
        }
    },
    methods: {
        fnSave() {
            var self = this;
            var nparmap = {
                title: self.title,
                contents: self.contents,
                userNo: self.sessionId,
                region: self.region,
                budget: self.budget,
                currency : self.currency
            };
            $.ajax({
                url: "/request/add.dox",
                type: "POST",
                dataType: "json",
                data: nparmap,
                success: function(data) {
                    console.log(data);
                    if (data.num > 0) {
                        alert("입력되었습니다.");
                        location.href = "/request/list.do";
                    }
                }
            });
        },
        onBudgetInput(event) {
            const raw = event.target.value.replace(/[^0-9]/g, ''); // 숫자만 추출
            this.budget = raw;
        }
    }, 
    mounted() {
        var self = this;
        var quill = new Quill('#editor', {
            theme: 'snow',
            modules: {
                toolbar: [
                    [{ 'header': [1, 2, 3, false] }],
                    ['bold', 'italic', 'underline'],
                    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                    ['link', 'image'],
                    [{ 'color': [] }, { 'background': [] }],
                    [{ 'align': [] }],
                    ['clean']
                ]
            }
        });

        quill.on('text-change', function() {
            self.contents = quill.root.innerHTML;
        });
    }
});

app.mount('#app');
</script>
