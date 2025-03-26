<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Kapture - Find ID</title>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
    }
    #app {
      max-width: 420px;
      margin: 80px auto;
      background: #fff;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .action-btn {
      width: 100%;
      background-color: #2b74e4;
      color: white;
      padding: 12px;
      border: none;
      border-radius: 4px;
      font-size: 16px;
      cursor: pointer;
      margin-top: 10px;
    }
    .info {
      font-size: 14px;
      margin-top: 15px;
      color: #333;
    }
  </style>
</head>
<body>
<div id="app">
  <h2 style="text-align:center;">Find Your Email</h2>

  <input v-model="user.firstName" @input="normalizeName('firstName')" placeholder="First Name" />
  <input v-model="user.lastName" @input="normalizeName('lastName')" placeholder="Last Name" />

  <!-- 생년월일: 월/일/년 별도 -->
  <div style="display: flex; gap: 10px;">
    <input v-model="birthday.MM" maxlength="2" placeholder="MM" />
    <input v-model="birthday.DD" maxlength="2" placeholder="DD" />
    <input v-model="birthday.YYYY" maxlength="4" placeholder="YYYY" />
  </div>

  <!-- 전화번호 -->
  <input v-model="user.phone" @input="normalizePhone" placeholder="Phone Number (e.g. 010-1234-5678)" />

  <button class="action-btn" @click="findEmail">Find Email</button>

  <div class="info" v-if="foundEmail">
    ✅ Your registered email is: <strong>{{ foundEmail }}</strong>
    <br><br>
    <button class="action-btn" @click="askPasswordReset">Reset Password?</button>
  </div>

  <!-- 비밀번호 재설정 관련 화면 (추후 확장 예정) -->
  <div v-if="emailForReset">
    <input v-model="verificationCode" placeholder="Enter verification code" />
    <button class="action-btn" @click="verifyCode">Verify</button>
  </div>

  <div v-if="verified">
    <input type="password" v-model="newPassword" placeholder="Enter new password" />
    <input type="password" v-model="confirmPassword" placeholder="Confirm new password" />
    <button class="action-btn" @click="resetPassword">Change Password</button>
  </div>
</div>

<script>
const app = Vue.createApp({
  data() {
    return {
      user: {
        firstName: "",
        lastName: "",
        phone: ""
      },
      birthday: {
        MM: "",
        DD: "",
        YYYY: ""
      },
      foundEmail: "",
      emailForReset: "",
      verificationCode: "",
      newPassword: "",
      confirmPassword: "",
      verified: false
    };
  },
  methods: {
    // 이름 정리: 공백 제거 + 첫 글자 대문자
    normalizeName(field) {
      let value = this.user[field] || "";
      value = value.trim().toLowerCase();
      value = value.charAt(0).toUpperCase() + value.slice(1);
      this.user[field] = value;
    },

    // 전화번호 정리: 공백/하이픈 제거 → 숫자만
    normalizePhone() {
      this.user.phone = this.user.phone.replace(/\s|-/g, '').replace(/[^0-9]/g, '');
    },

    // 생년월일 → YY/MM/DD 형식
    formatBirthday() {
      const { YYYY, MM, DD } = this.birthday;
      if (!YYYY || !MM || !DD) return "";

      const yearShort = YYYY.slice(-2);
      return yearShort + '/' + MM.padStart(2, '0') + '/' + DD.padStart(2, '0');
    },

    // 이메일 찾기
    findEmail() {
      const self = this;

      if (
        !self.user.firstName ||
        !self.user.lastName ||
        !self.user.phone ||
        !self.birthday.YYYY ||
        !self.birthday.MM ||
        !self.birthday.DD
      ) {
        alert("모든 값을 입력해 주세요.");
        return;
      }
      const birthdayFormatted = this.formatBirthday();

      if (!birthdayFormatted) {
        alert("생년월일을 정확히 입력해주세요.");
        return;
      }
      const nparam = {
        firstName: self.user.firstName,
        lastName: self.user.lastName,
        phone: self.user.phone,
        birthday: birthdayFormatted
      };

      console.log("최종 전송 데이터:", nparam);

      $.ajax({
        url: "/find-email.dox",
        type: "POST",
        data: nparam,
        dataType: "json",
        success(data) {
          if (data.result === "success") {
            self.foundEmail = data.email;
          } else {
            alert("❌ 일치하는 계정을 찾을 수 없습니다.");
          }
        }
      });
    },

    askPasswordReset() {
      // 향후: 비밀번호 재설정 절차 시작
      this.emailForReset = this.foundEmail;
      alert("이메일 인증 절차로 이동합니다.");
    },

    verifyCode() {
      // TODO: 인증번호 검증 로직
    },

    resetPassword() {
      // TODO: 새 비밀번호 저장 로직
    }
  }
});
app.mount('#app');
</script>
</body>
</html>
