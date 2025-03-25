<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>1:1 문의하기</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 30px;
      background: #f9f9fb;
    }
    .container {
      max-width: 700px;
      margin: 0 auto;
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    }
    h2 { margin-bottom: 10px; }
    p.subtext { color: #555; margin-bottom: 20px; }
    select, input, textarea {
      width: 100%;
      padding: 12px;
      margin-top: 10px;
      margin-bottom: 20px;
      border: 1px solid #ccc;
      border-radius: 5px;
      transition: border 0.2s;
    }
    select:focus, input:focus, textarea:focus {
      border-color: #003366;
      outline: none;
    }
    button {
      padding: 12px 20px;
      border: none;
      border-radius: 5px;
      margin-right: 10px;
      cursor: pointer;
    }
    .btn-submit { background-color: #003366; color: white; }
    .btn-cancel { background-color: #999; color: white; }
    .btn-link {
      float: right;
      color: #003366;
      font-size: 14px;
      text-decoration: none;
      margin-top: -30px;
    }
    .btn-link:hover { text-decoration: underline; }

    .file-label {
      display: block;
      font-size: 14px;
      color: #333;
      margin-bottom: 6px;
    }
    .file-warning {
      color: red;
      font-size: 13px;
      margin-top: -15px;
      margin-bottom: 15px;
    }
  </style>
</head>

<body>
<jsp:include page="../common/header.jsp" />


<div id="app">
  <div class="container">
    <h2 style="text-align: center;">1:1 문의하기</h2>
    <p class="subtext">사이트를 사용하시면서 불편한 사항이나 개선 의견이 있다면 언제든지 문의해주세요.</p>

    <!-- ✅ 문의유형 -->
    <select v-model="category">
      <option value="">문의 유형을 선택해주세요</option>
      <option value="예약/결제">예약/결제</option>
      <option value="패키지">패키지</option>
      <option value="취소/환불">취소/환불</option>
    </select>

    <!-- ✅ 제목 (선택사항) -->
    <input type="text" placeholder="제목을 입력해주세요 (선택사항)" v-model="title" />

    <!-- ✅ 문의 내용 - 크기 3배 증가 -->
    <textarea rows="18" placeholder="문의하실 내용을 입력해주세요" v-model="question"></textarea>

    <!-- ✅ 파일 첨부 -->
    <label class="file-label">파일첨부 (최대 5MB)</label>
    <input type="file" ref="file" @change="handleFile" />
    <div class="file-warning" v-if="fileWarning">{{ fileWarning }}</div>

    <!-- ✅ 버튼 영역 -->
    <button class="btn-cancel" @click="fnCancel">취소</button>
    <button class="btn-submit" @click="fnQna">문의하기</button>
  </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script>
  const app = Vue.createApp({
    data() {
      return {
        category: "",
        title: "",
        question: "",
        userNo: "${sessionId}",
        file: null,
        fileWarning: ""
      };
    },
    methods: {
      fnQna() {
        if (!this.category || !this.question) {
          alert("필수 항목을 모두 입력해주세요.");
          return;
        }
        if (this.file && this.file.size > 5 * 1024 * 1024) {
          alert("5MB 이하 파일만 첨부 가능합니다.");
          return;
        }

        const formData = new FormData();
        formData.append("category", this.category);
        formData.append("title", this.title);
        formData.append("question", this.question);
        formData.append("userNo", this.userNo);
        if (this.file) formData.append("file", this.file);

        $.ajax({
          url: "/cs/add.dox",
          type: "POST",
          data: formData,
          processData: false,
          contentType: false,
          success: function (data) {
            alert("문의가 정상적으로 등록되었습니다.");
            location.href = "/cs/main.do";
          },
          error: function () {
            alert("문의 등록 중 오류가 발생했습니다.");
          }
        });
      },
      fnCancel() {
        location.href = "/cs/main.do";
      },
      handleFile(event) {
        this.file = event.target.files[0];
        if (this.file && this.file.size > 5 * 1024 * 1024) {
          this.fileWarning = "5MB 이하의 파일만 첨부할 수 있습니다.";
        } else {
          this.fileWarning = "";
        }
      }
    }
  });
  app.mount("#app");
</script>
</body>
</html>
