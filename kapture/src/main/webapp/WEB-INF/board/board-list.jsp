<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 카드</title>
    <style>
        :root {
            --color-bg: #ffffff;
            --color-point: #1E3A8A;
            --font-main: 'Pretendard', 'Noto Sans KR', sans-serif;
        }

        body {
            margin: 0;
            background-color: var(--color-bg);
            font-family: var(--font-main);
            padding: 2rem;
        }

        .card {
            max-width: 380px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            overflow: hidden;
            transition: transform 0.2s ease;
            background: url('../../img/tour4.jpg') center/cover no-repeat;
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card-image {
            position: relative;
            height: 300px;
            margin: 10px;
            border-radius: 10px;
        }

        .card-content {
            padding: 1.2rem;
            border-radius: 10px;
            background-color: #2727279f;
            position: relative;
        }

        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .card-date {
            font-size: 0.9rem;
            color: #eee;
        }

        .favorite {
            width: 36px;
            height: 36px;
            background-image: url("${pageContext.request.contextPath}/svg/taeguk-white-outline.svg");
            background-size: cover;
            background-repeat: no-repeat;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .favorite:hover {
            transform: scale(1.2);
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 0.4rem;
            color: #fff;
        }

        .card-desc {
            font-size: 0.9rem;
            color: #f1f1f1;
            margin-bottom: 0.8rem;
        }

        .card-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .rating {
            font-size: 1rem;
            color: #FFD700;
        }

        .price {
            font-size: 1.1rem;
            font-weight: 700;
            color: #ffffff;
            padding: 2px 6px;
            border-radius: 5px;
        }

        .card-btn {
            width: 100%;
            background: #171d41;
            color: #fff;
            border: none;
            padding: 0.7rem;
            font-size: 0.95rem;
            border-radius: 5px;
            cursor: pointer;
        }

        .card-btn:hover {
            background-color: #162c67;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="card-image"></div>
    <div class="card-content">
        <div class="card-top">
            <div class="card-date">2025-06-21</div>
            <div class="favorite" onclick="toggleFavorite(this)"></div>
        </div>
        <div class="card-title">오션뷰 리조트 & 올레길</div>
        <div class="card-desc">탁 트인 해변과 올레길 산책</div>
        <div class="card-info">
            <div class="rating">⭐ 4.9</div>
            <div class="price">₩139,000</div>
        </div>
        <button class="card-btn">예약하기</button>
    </div>
</div>

<script>
    function toggleFavorite(el) {
        el.classList.toggle("active");
        if(el.classList.contains("active")) {
            el.style.backgroundImage = "url('${pageContext.request.contextPath}/svg/taeguk-full.svg')";
        } else {
            el.style.backgroundImage = "url('${pageContext.request.contextPath}/svg/taeguk-white-outline.svg')";
        }
    }
</script>

</body>
</html>
