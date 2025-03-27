<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>kapture | 약관 및 정책</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        #app {
            display: flex;
            min-height: 80vh;
        }
        .sidebar {
            width: 250px;
            background-color: #f4f4f4;
            border-right: 1px solid #ddd;
            padding: 20px;
            box-sizing: border-box;
        }
        .sidebar h2 {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 20px;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            padding: 10px;
            cursor: pointer;
            color: #555;
            transition: background-color 0.3s;
        }
        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #e91e63;
            color: white;
            border-radius: 5px;
        }
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        .content h3 {
            color: #e91e63;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div id="app">
        <div class="sidebar">
            <h2>약관 및 정책</h2>
            <ul>
                <li v-for="(menu, index) in menus"
                    :key="index"
                    :class="{ active: selectedIndex === index }"
                    @click="selectedIndex = index">
                    {{ menu.title }}
                </li>
            </ul>
        </div>
        <div class="content">
            <h3>{{ menus[selectedIndex].title }}</h3>
            <div v-html="menus[selectedIndex].content"></div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            selectedIndex: 0,
            menus: [
                {
                    title: '개인정보 처리방침',
                    content: `
                        <p>kapture(이하 \"회사\")는 이용자의 개인정보 보호를 중요시하며, 관련 법령에 따라 아래와 같이 개인정보 처리방침을 운영합니다.</p>
                        <h4>1. 수집하는 개인정보 항목</h4>
                        <ul>
                            <li>회원 가입 시: 이름, 이메일, 비밀번호, 휴대폰 번호, 국적</li>
                            <li>서비스 이용 시: IP주소, 브라우저 정보, 쿠키, 접속 기록, 이용 이력, 위치정보</li>
                            <li>여행 예약 시: 여권번호, 생년월일, 성별, 결제 정보, 탑승자명단</li>
                        </ul>
                        <h4>2. 수집 및 이용 목적</h4>
                        <ul>
                            <li>회원 식별, 본인 인증 및 고객관리</li>
                            <li>예약 확인, 상품 제공, 결제 처리</li>
                            <li>여행지 추천, 사용자 맞춤형 광고 제공</li>
                            <li>법령에 따른 의무 이행, 분쟁 대응 및 기록 보존</li>
                            <li>신규 서비스 및 이벤트 안내</li>
                        </ul>
                        <h4>3. 보유 및 이용 기간</h4>
                        <ul>
                            <li>회원 정보: 회원 탈퇴 후 5일까지 보관 후 즉시 삭제</li>
                            <li>전자상거래 기록: 5년 (계약, 청약철회, 대금결제, 재화 공급 관련)</li>
                            <li>소비자 불만 및 분쟁처리 기록: 3년</li>
                            <li>로그인 기록(IP): 3개월 (정보통신망법 근거)</li>
                        </ul>
                        <h4>4. 개인정보의 제3자 제공 및 처리 위탁</h4>
                        <p>회사는 이용자의 동의 없이 개인정보를 외부에 제공하지 않으며, 서비스 수행을 위한 경우 일부 외부 업체에 위탁할 수 있습니다.</p>
                        <ul>
                            <li>결제 처리(PG사), 문자/이메일 발송, 항공사 및 숙박 업체에 정보 전달</li>
                            <li>위탁 시 계약을 통해 수탁자의 개인정보 보호 의무를 명확히 규정</li>
                        </ul>
                        <h4>5. 이용자의 권리</h4>
                        <ul>
                            <li>본인의 개인정보 열람, 정정, 삭제 요청 가능</li>
                            <li>처리 정지 및 동의 철회 가능 (단, 일부 서비스 제한 가능)</li>
                            <li>권리행사는 이메일 또는 고객센터를 통해 신청 가능</li>
                        </ul>
                    `
                },
                {
                    title: '이용약관',
                    content: `
                        <p>본 약관은 kapture가 제공하는 온라인 여행 관련 서비스 이용에 있어 회사와 이용자의 권리와 의무, 책임사항 등을 명확히 규정하기 위함입니다.</p>
                        <h4>1. 목적</h4>
                        <p>이 약관은 회사가 제공하는 여행 예약, 결제, 커뮤니티 등의 서비스를 공정하게 이용하기 위한 기준을 정하는 것을 목적으로 합니다.</p>
                        <h4>2. 정의</h4>
                        <ul>
                            <li>\"회원\"은 회사에 개인정보를 제공하고 가입한 자</li>
                            <li>\"비회원\"은 가입 없이 서비스를 이용하는 자</li>
                        </ul>
                        <h4>3. 회원 가입 및 자격</h4>
                        <ul>
                            <li>정확한 정보를 제공해야 하며, 타인 정보 도용 시 법적 책임이 발생</li>
                            <li>회사는 가입 신청에 대해 승인 또는 보류할 수 있음</li>
                        </ul>
                        <h4>4. 서비스 내용 및 변경</h4>
                        <p>회사는 여행지 소개, 예약 시스템, 사용자 맞춤 콘텐츠 등을 제공하며, 사전 공지 후 서비스 내용 일부 변경 가능</p>
                        <h4>5. 회원의 의무</h4>
                        <ul>
                            <li>약관 및 관련 법령 준수</li>
                            <li>서비스 운영을 방해하거나 부정한 방법으로 사용 금지</li>
                        </ul>
                        <h4>6. 계약 해지 및 이용 제한</h4>
                        <p>회원이 약관을 위반하거나 부당한 목적의 경우 서비스 이용이 제한되며, 회사는 사전 통지 후 계정 삭제 또는 정지 가능</p>
                        <h4>7. 책임 및 면책</h4>
                        <p>회사는 천재지변, 시스템 장애, 외부 해킹 등 불가항력적 사유에 대해 책임을 지지 않음</p>
                        <h4>8. 관할 법원 및 준거법</h4>
                        <p>분쟁 발생 시 대한민국 법을 따르며, 서울중앙지방법원을 관할 법원으로 지정</p>
                    `
                },
                {
                    title: '취소 및 환불 정책',
                    content: `
                        <p>고객의 권리를 보호하고, 원활한 서비스 제공을 위해 아래와 같은 취소 및 환불 정책을 운영합니다.</p>
                        <h4>1. 일반 원칙</h4>
                        <ul>
                            <li>모든 예약 취소 요청은 영업시간 내 고객센터 또는 홈페이지를 통해 신청</li>
                            <li>환불 금액은 결제 수단에 따라 환급되며, 일부 수수료가 제외될 수 있음</li>
                        </ul>
                        <h4>2. 국내 여행 상품 환불 규정</h4>
                        <ul>
                            <li>출발일 7일 전까지: 100% 환불</li>
                            <li>출발일 3~6일 전: 70% 환불</li>
                            <li>출발일 2일 전~당일: 환불 불가</li>
                        </ul>
                        <h4>3. 해외 여행 상품 환불 규정</h4>
                        <ul>
                            <li>항공, 호텔, 현지 업체와의 계약에 따라 수수료 발생</li>
                            <li>예약 확정 이후 변경/취소 시 항공사 및 호텔의 약관 적용</li>
                        </ul>
                        <h4>4. 예외 사항</h4>
                        <ul>
                            <li>천재지변, 항공기 결항 등 불가항력적 사유 발생 시 수수료 없이 환불 가능</li>
                            <li>공식 증빙서류 제출이 필요한 경우가 있음</li>
                        </ul>
                    `
                },
                {
                    title: '쿠키 정책',
                    content: `
                        <p>kapture는 웹사이트의 이용자 경험 개선을 위해 쿠키를 사용합니다.</p>
                        <h4>1. 쿠키의 정의</h4>
                        <p>쿠키는 웹사이트가 이용자의 브라우저에 저장하는 작은 정보 파일로, 로그인 상태 유지, 선호 정보 저장 등에 활용됩니다.</p>
                        <h4>2. 사용 목적</h4>
                        <ul>
                            <li>이용자의 사이트 이용 내역 파악</li>
                            <li>맞춤형 콘텐츠 및 광고 제공</li>
                            <li>방문자 통계 수집 및 분석</li>
                        </ul>
                        <h4>3. 쿠키 수집 거부 방법</h4>
                        <p>이용자는 브라우저 설정을 통해 쿠키 저장을 거부하거나 삭제할 수 있습니다.</p>
                        <ul>
                            <li>Chrome: 설정 > 개인정보 및 보안 > 쿠키</li>
                            <li>Safari: 환경설정 > 개인정보 보호</li>
                        </ul>
                        <h4>4. 주의사항</h4>
                        <p>쿠키를 차단할 경우 일부 서비스 이용에 제한이 있을 수 있습니다.</p>
                    `
                }
            ]
        };
    }
});
app.mount('#app');
</script>
