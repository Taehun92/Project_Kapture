<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
	<title>메인 페이지</title>
</head>
<style>
     /* Common Styles */
     body {
        font-family: sans-serif; /* 기본 글꼴 설정 */
        margin: 0; /* 기본 margin 제거 */
        padding: 0; /* 기본 padding 제거 */
    }

    /* Banner Section */
    .swiper-container {
        width: 90%;
        overflow: hidden;
        margin: 20px auto; /* 가운데 정렬 및 상하 margin 추가 */
    }

    .swiper-slide {
        overflow: hidden;
    }

    .banner {
        display: block; /* 이미지 아래 불필요한 여백 제거 */
        width: 100%;
        height: auto; /* 이미지 비율 유지 */
        max-height: 300px; /* 최대 높이 설정 */
        object-fit: cover; /* 이미지가 영역에 맞춰 비율 유지하며 채우도록 설정 */
        padding: 0; /* 내부 padding 제거 */
        margin: 0; /* 내부 margin 제거 */
    }

    /* Recommended Items Section */
    .item-page {
        display: flex;
        flex-wrap: wrap; /* 화면이 좁아지면 다음 줄로 넘어가도록 설정 */
        justify-content: flex-start; /* 아이템들을 왼쪽부터 정렬 */
        gap: 20px; /* 아이템 사이 간격 설정 */
        padding: 20px; /* 전체 padding 추가 */
    }

    .item-page > span { /* .item-page의 직계 자식 span 선택 */
        width: calc(33.33% - 20px * 2 / 3); /* 3개씩 배치, 간격 고려 */
        box-sizing: border-box; /* padding, border가 width에 포함되도록 설정 */
    }

    .box {
        border: 1px solid #ccc; /* 연한 회색 테두리 */
        border-radius: 5px; /* 약간의 모서리 둥글게 */
        padding: 15px;
        margin-bottom: 15px; /* 박스 아래 간격 */
        text-align: center; /* 내부 요소 가운데 정렬 */
    }

    .box img {
        display: block;
        width: 100%;
        height: auto;
        margin-bottom: 10px;
        border-radius: 3px; /* 이미지에도 약간의 모서리 둥글게 */
        object-fit: cover; /* 이미지가 영역에 맞춰 비율 유지하며 채우도록 설정 */
        aspect-ratio: 1/1; /* 이미지 비율을 1:1로 유지 (선택 사항) */
    }

    .box div {
        margin-bottom: 5px;
    }

    .box button {
        background-color: #007bff; /* 파란색 버튼 */
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease; /* hover 시 부드러운 변화 */
    }

    .box button:hover {
        background-color: #0056b3;
    }

    /* 추천 상품 제목 스타일 */
    #app > div:nth-child(2) { /* app 내부의 두 번째 div (추천 상품 제목) */
        text-align: center;
        margin-top: 30px;
        margin-bottom: 20px;
        font-size: 1.5em;
        font-weight: bold;
    }

    #app > div:nth-child(2) hr {
        border: 1px solid #ddd;
        margin-top: 10px;
        margin-bottom: 10px;
    }

    /* Footer Placeholder (기존 dd, aa div들) */
    #app > div:nth-child(n+4) { /* 추천 상품 섹션 이후의 div들 */
        text-align: center;
        padding: 20px;
        color: #777;
        font-size: 0.9em;
    }

    /* 추천 리뷰 섹션 스타일 */
    .review-page {
        padding: 20px;
    }

    .review-box {
        border: 1px solid #eee;
        border-radius: 5px;
        padding: 15px;
        margin-bottom: 15px;
        display: flex; /* 이미지와 텍스트를 가로로 배치하기 위해 flex 사용 */
        flex-direction: column; /* 기본적으로 세로로 배치 */
        align-items: flex-start; /* 왼쪽 정렬 */
    }

    .review-author {
        font-weight: bold;
        margin-bottom: 5px;
        width: 100%; /* 작성자 이름이 이미지 너비에 맞춰짐 */
    }

    .review-image {
        width: 80px; /* 이미지 너비 조절 */
        height: 80px; /* 이미지 높이 조절 */
        border-radius: 50%; /* 동그란 이미지 (선택 사항) */
        object-fit: cover; /* 이미지가 영역에 맞춰 비율 유지하며 채우도록 설정 */
        margin-right: 15px; /* 이미지와 내용 사이 간격 */
        margin-bottom: 10px; /* 이미지 아래 간격 */
    }

    .review-content {
        margin-bottom: 10px;
        line-height: 1.6;
        width: 100%; /* 내용이 이미지 너비에 맞춰짐 */
    }

    .review-rating {
        color: gold;
        font-size: 1.2em;
    }

    /* 추천 리뷰 제목 스타일 */
    #app > div:nth-child(4) {
        text-align: center;
        margin-top: 30px;
        margin-bottom: 20px;
        font-size: 1.5em;
        font-weight: bold;
    }

    #app > div:nth-child(4) hr {
        border: 1px solid #ddd;
        margin-top: 10px;
        margin-bottom: 10px;
    }

    h1 {
        text-align: center;
    }

</style>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <div id="app">
        <div>
            <h1>K-apture 에 오신 것을 환영합니다!!!</h1>
        </div>
        <div class="swiper-container">
            <div class="swiper-wrapper">
               <div class="swiper-slide">
                    <img class="banner" src="../../img/banner.jpg">슬라이드 1
                </div>
                <div class="swiper-slide">
                    <img class="banner" src="../../img/banner2.jpg">슬라이드 2
                </div>
                <div class="swiper-slide">
                    <img class="banner" src="../../img/3.jpg">슬라이드 3
                </div>
                
            </div>
        </div>

        <div>
            <hr>
            추천상품
        </div>
        <div class="item-page">
            <span class="box">
            <img class="" src="../../img/1.jpg">
                <div>상품 제목</div>
                <div>상품 설명</div>
                <button>예약</button>
            </span>

            <span class="box">
                <img class="" src="../../img/2.jpg">
                <div>상품 제목</div>
                <div>상품 설명</div>
                <button>예약</button>
            </span>

            <span class="box">
                <img class="" src="../../img/3.jpg">
                <div>상품 제목</div>
                <div>상품 설명</div>
                <button>예약</button> 
            </span>
        </div>
        <div>
            <hr>
            추천 리뷰
        </div>
        <div class="review-page">
            <div class="review-box">
                <div class="review-author">사용자 A</div>
                <img class="review-image" src="../../img/1.jpg" alt="리뷰 이미지 1">
                <div class="review-content">이 상품 정말 좋아요! 배송도 빠르고 품질도 만족스럽습니다.</div>
                <div class="review-rating">★★★★★</div>
            </div>

            <div class="review-box">
                <div class="review-author">사용자 B</div>
                <img class="review-image" src="../../img/2.jpg" alt="리뷰 이미지 2">
                <div class="review-content">가격 대비 성능이 훌륭합니다. 추천합니다!</div>
                <div class="review-rating">★★★★☆</div>
            </div>

            <div class="review-box">
                <div class="review-author">사용자 C</div>
                <img class="review-image" src="../../img/3.jpg" alt="리뷰 이미지 3">
                <div class="review-content">잘 받았습니다. 다음에 또 구매할게요.</div>
                <div class="review-rating">★★★★</div>
            </div>
        </div>
	</div>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
				swiper : null
            };
        },
        methods: {
            fnGetBoard(){
				let self = this;
				let nparmap = {

                	};
				$.ajax({
					url:"/board/info.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        self.info = data.info;
					}
				});
            },
        },
        mounted() {
            let self = this;
            let swiper = new Swiper('.swiper-container', {
				// 기본 옵션 설정
				loop: true, // 반복
                spaceBetween: 0,
                slidesPerView: 1,
				autoplay: {
					delay: 2500,
				},
				pagination: {
					el: '.swiper-pagination',
					clickable: true,
				},
				navigation: {
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',
				},
			});
        }
    });
    app.mount('#app');
</script>