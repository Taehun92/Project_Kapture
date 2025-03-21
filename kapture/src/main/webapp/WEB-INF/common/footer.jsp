<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="../../css/footer.css">
	<title>푸터</title>
</head>
<style>
</style>
<body>
	<div id="footer">
		<div>
            <a>
                공지사항
            </a>
            <a>
                이용약관
            </a>
            <a>
                개인정보처리 보호방침
            </a>
            <!--뒤쪽으로  결제 정보 아이콘등이 붙으면 좋을거같은데 어케 해야함?-->
        </div>
        <div>
            상호 : (주) 캡쳐여행사
            대표 : 이태훈
            주소 :  인천광역시 부평구 경원대로 1366 7층 더조은컴퓨터아카데미 인천캠퍼스
        </div>
        <div>
            대표번호 : 9000-9000
            이메일 : taehun92@gmail.com
            사업자등록번호: 999-99-00001
            통신판매업신고번호: 제 2025-90000 호
        </div>
        <div>
            관광사업자 등록번호: 제2025-000000호
            개인정보보호 책임자: 홍길동
        </div>
        <div>
            영업보증보험: 서울보증보험 6천5백만원가입
        </div>
        <div>
            Powered by K-apture Corp.
        </div>
	</div>
</body>
</html>
<script>
    const footer = Vue.createApp({
        data() {
            return {
                
            };
        },
        methods: {
            fnLogin(){
				var self = this;
				var nparmap = {	};
				$.ajax({
					url:"login.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
					}
				});
            }
        },
        mounted() {
            var self = this;
        }
    });
    footer.mount('#footer');
</script>