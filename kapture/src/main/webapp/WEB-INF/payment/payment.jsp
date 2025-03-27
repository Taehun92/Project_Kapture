<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Kapture | 결제</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', 'Noto Sans KR', sans-serif;
            background-color: #f9fafb;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 460px;
            margin: 80px auto;
            padding: 32px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }
        h2 {
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 24px;
            color: #111827;
        }
        .info {
            font-size: 1rem;
            color: #374151;
            margin-bottom: 12px;
        }
        .info span {
            font-weight: 500;
            color: #111827;
        }
        .button-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 28px;
        }
        .btn {
            padding: 14px;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-paypal {
            background-color: #0070ba;
            color: white;
        }
        .btn-paypal:hover {
            background-color: #005c9c;
        }
        .btn-inicis {
            background-color: #f97316;
            color: white;
        }
        .btn-inicis:hover {
            background-color: #ea580c;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>결제하기</h2>
    <div class="info"><span>상품명:</span> 제주도 힐링투어</div>
    <div class="info"><span>결제금액:</span> <span id="amount">30000</span>원</div>

    <div class="button-group">
        <button class="btn btn-paypal" onclick="requestPayment('paypal')">Pay with PayPal</button>
        <button class="btn btn-inicis" onclick="requestPayment('html5_inicis')">Pay with Card</button>
    </div>
</div>

<script>
  function requestPayment(pgType) {
    const IMP = window.IMP;
    IMP.init("imp08653517"); // 포트원 가맹점 식별키 입력

    const amount = parseInt($("#amount").text());

    IMP.request_pay({
      pg: pgType,
      pay_method: "card",
      merchant_uid: "order_" + new Date().getTime(),
      name: "제주도 힐링투어",
      amount: amount,
      buyer_email: "user@example.com",
      buyer_name: "홍길동",
      buyer_tel: "010-1234-5678"
    }, function (rsp) {
      if (rsp.success) {
        $.ajax({
          url: "/payment/complete.dox",
          type: "POST",
          data: {
            impUid: rsp.imp_uid,
            merchantUid: rsp.merchant_uid,
            paidAmount: rsp.paid_amount,
            method: pgType
          },
          success: function(data) {
            alert("✅ 결제가 완료되었습니다!");
            location.href = "/payment/complete.jsp";
          },
          error: function() {
            alert("❌ 서버에 결제 정보 전송 실패");
          }
        });
      } else {
        alert("❌ 결제 실패: " + rsp.error_msg);
      }
    });
  }
</script>

</body>
</html>
