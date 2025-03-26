<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Kapture - Join</title>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
    }
    #app {
      max-width: 420px;
      margin: 80px auto;
      background: #fff;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
      text-align: center;
      margin-bottom: 25px;
      color: #333;
    }
    input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    button {
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
    .terms {
      font-size: 12px;
      margin-top: 20px;
      text-align: center;
      color: #555;
    }
  </style>
</head>
<body>
<div id="app">
  <h2>Join Kapture</h2>

  <!-- Email + 인증 -->
  <input type="text" placeholder="Email" v-model="user.email" :disabled="emailVerified"/>
  <div v-if="emailCheckMessage && !emailVerified" :style="{ color: emailCheckColor, fontSize: '13px', marginTop: '5px' }">
    {{ emailCheckMessage }}
  </div>
  <button @click="sendVerificationCode">Send Code</button>

  <div v-if="emailCodeSent && !emailVerified">
    <input type="text" v-model="userInputCode" placeholder="Enter verification code" />
    <button @click="verifyCode">Verify</button>
  </div>
  <div v-if="emailVerified" style="color: green; font-size: 13px; margin-top: 5px;">✅ Email verified successfully.</div>
  <div v-if="emailError" style="color: red; font-size: 13px;">{{ emailError }}</div>

  <!-- Password -->
  <input type="password" v-model="user.password" placeholder="Password" />
  <div v-if="user.password.length > 0 && !passwordValid" style="font-size: 13px;">
    <div :style="{ color: passwordRules.length ? 'green' : 'orange' }">
      {{ passwordRules.length ? '✅ At least 6 characters' : '❌ At least 6 characters' }}
    </div>
    <div :style="{ color: passwordRules.number ? 'green' : 'orange' }">
      {{ passwordRules.number ? '✅ At least one number' : '❌ At least one number' }}
    </div>
    <div :style="{ color: passwordRules.upper ? 'green' : 'orange' }">
      {{ passwordRules.upper ? '✅ At least one uppercase letter' : '❌ At least one uppercase letter' }}
    </div>
    <div :style="{ color: passwordRules.lower ? 'green' : 'orange' }">
      {{ passwordRules.lower ? '✅ At least one lowercase letter' : '❌ At least one lowercase letter' }}
    </div>
    <div :style="{ color: passwordRules.special ? 'green' : 'orange' }">
      {{ passwordRules.special ? '✅ At least one special character' : '❌ At least one special character' }}
    </div>
  </div>

  <input type="password" v-model="user.password2" placeholder="Re-enter Password" />
  <div
    v-if="user.password2.length > 0 && passwordValid"
    :style="{ color: passwordsMatch ? 'green' : 'red', fontSize: '13px' }"
  >
    {{ passwordsMatch ? '✅ Passwords match.' : '❌ Passwords do not match.' }}
  </div>

  <!-- Personal Info -->
  <input placeholder="First Name" v-model="user.firstName" />
  <input placeholder="Last Name" v-model="user.lastName" />
  <input placeholder="Phone Number" v-model="user.phone" />
  <div style="display: flex; gap: 8px;">
    <input type="text" v-model="birth.mm" maxlength="2" placeholder="MM" style="flex: 1;" />
    <input type="text" v-model="birth.dd" maxlength="2" placeholder="DD" style="flex: 1;" />
    <input type="text" v-model="birth.yyyy" maxlength="4" placeholder="YYYY" style="flex: 2;" />
  </div>
  <div v-if="!isBirthdayValid" style="color: red; font-size: 13px; margin-top: 5px;">
    ❌ 생년월일을 올바르게 입력해주세요.
  </div>

  <div v-if="!emailVerified && userInputCode.length > 0" style="color: red; font-size: 13px;">
    ❗ You must verify your email to proceed with sign up.
  </div>

  <!-- Join Button -->
  <button
    @click="fnJoin"
    :disabled="!canSubmit"
    :style="{
      backgroundColor: canSubmit ? '#2b74e4' : '#ccc',
      cursor: canSubmit ? 'pointer' : 'not-allowed'
    }"
  >
    Continue
  </button>

  <div class="terms">
    By creating an account, you agree to Kapture's <br />
    <a href="#">Conditions</a> of Use and <a href="#">Privacy Notice</a>.
  </div>
</div>

<script>
const app = Vue.createApp({
  data() {
    return {
      user: {
        email: '', 
        password: '', 
        password2: '', 
        firstName: '', 
        lastName: '', 
        phone: '', 
        birthday: ''
      },
      birth: {
        mm: '', 
        dd: '', 
        yyyy: ''
      },
      isBirthdayValid: true,
      userInputCode: '',
      emailCodeSent: false,
      emailVerified: false,
      emailError: '',
      emailCheckMessage: '',
      emailCheckColor: '',
      emailCheckTimer: null,
      emailValid: false,
      emailAvailable: false,
      passwordRules: { length: false, upper: false, lower: false, special: false },
      passwordValid: false,
      passwordsMatch: false
    };
  },
  watch: {
    'user.password'(val) {
      this.validatePassword();
    },
    'user.password2'(val) {
      this.validatePassword();
    },
    'user.email'(val) {
      clearTimeout(this.emailCheckTimer);
      if (!val) {
        this.emailCheckMessage = '';
        return;
      }
      this.emailCheckTimer = setTimeout(() => {
        this.fnIdCheck();
      }, 500);
    },
    'birth.mm': 'validateBirthdayParts',
    'birth.dd': 'validateBirthdayParts',
    'birth.yyyy': 'validateBirthdayParts'
  },
  computed: {
    canSubmit() {
      return (
        this.emailValid &&
        this.emailAvailable &&
        this.emailVerified &&
        this.passwordValid &&
        this.passwordsMatch &&
        this.user.firstName &&
        this.user.lastName &&
        this.user.phone &&
        this.user.birthday
      );
    }
  },
  methods: {
    debouncedCheck() {
      clearTimeout(this.emailCheckTimer);
      this.emailCheckTimer = setTimeout(() => {
        this.fnIdCheck();
      }, 500);
    },

    validatePassword() {
      const pw = this.user.password;
      const pw2 = this.user.password2;

      this.passwordRules.length = pw.length >= 6;
      this.passwordRules.upper = /[A-Z]/.test(pw);
      this.passwordRules.lower = /[a-z]/.test(pw);
      this.passwordRules.special = /[^A-Za-z0-9]/.test(pw);
      this.passwordRules.number = /[0-9]/.test(pw);

      this.passwordValid =
        this.passwordRules.length &&
        this.passwordRules.upper &&
        this.passwordRules.lower &&
        this.passwordRules.special &&
        this.passwordRules.number;

      this.passwordsMatch = pw && pw2 && pw === pw2;
    },

    isValidEmail(email) {
      const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return regex.test(email);
    },

    fnIdCheck() {
      const email = this.user.email;
      if (!email) {
        this.emailCheckMessage = '';
        this.emailValid = false;
        this.emailAvailable = false;
        return;
      }
      if (!this.isValidEmail(email)) {
        this.emailCheckMessage = '⚠️ Invalid email format.';
        this.emailCheckColor = 'orange';
        this.emailValid = false;
        this.emailAvailable = false;
        return;
      }
      this.emailValid = true;
      $.ajax({
        url: '/check.dox',
        type: 'POST',
        dataType: 'json',
        data: { email },
        success: (data) => {
          if (data.count === 0) {
            this.emailCheckMessage = '✅ This email is available.';
            this.emailCheckColor = 'green';
            this.emailAvailable = true;
          } else {
            this.emailCheckMessage = '❌ This email is already in use.';
            this.emailCheckColor = 'red';
            this.emailAvailable = false;
          }
        },
        error: () => {
          this.emailCheckMessage = '⚠️ Failed to check email.';
          this.emailCheckColor = 'red';
          this.emailAvailable = false;
        }
      });
    },

    verifyCode() {
      if (!this.userInputCode) {
        alert("Enter the code you received.");
        return;
      }

      $.ajax({
        url: "/login/email/verify.dox",
        type: "POST",
        data: {
          email: this.user.email,
          code: this.userInputCode
        },
        success: (data) => {
          if (data.result === "success") {
            this.emailVerified = true;
            this.emailError = "";
            alert("Email successfully verified!");
          } else {
            this.emailVerified = false;
            this.emailError = data.message;
          }
        }
      });
    },

    validateBirthdayParts() {
      const { mm, dd, yyyy } = this.birth;
      const mmNum = parseInt(mm), ddNum = parseInt(dd), yyyyNum = parseInt(yyyy);

      const valid =
        yyyy.length === 4 &&
        mm.length === 2 &&
        dd.length === 2 &&
        mmNum >= 1 && mmNum <= 12 &&
        ddNum >= 1 && ddNum <= 31;

      this.isBirthdayValid = valid;

      if (valid) {
        const yy = yyyy.slice(2); // 마지막 두 자리만 사용
        this.user.birthday = `${yy}/${mm}/${dd}`; // 최종 조합
      } else {
        this.user.birthday = ''; // 유효하지 않으면 비워버림
      }
    },

    fnJoin() {
      this.validateBirthdayParts();

      if (!this.canSubmit || !this.isBirthdayValid) {
        alert("Please complete all required fields correctly.");
        return;
      }

      $.ajax({
        url: "join.dox",
        type: "POST",
        dataType: "json",
        data: this.user,
        success: function (data) {
          alert("Congratulations on becoming a member.");
          location.href = "/login.do";
        }
      });
    },

    sendVerificationCode() {
      let self = this;
      let nparmap = {
        email: self.user.email
      };

      $.ajax({
        url: "/login/email/send.dox",
        type: "POST",
        data: nparmap,
        success: function(data) {
          console.log("✅ 응답 확인:", data); // ← 실제 응답 구조 확인용

          if (data.result === "success") {
            alert("✅ " + data.message);
            self.emailCodeSent = true;

          } else {
            alert("❌ 인증 메일 전송 실패: " + (data.message || "알 수 없는 오류"));
          }
        },
        error: function(xhr, status, err) {
          console.error("❌ 서버 오류:", xhr.responseText);
          alert("❌ 서버 통신 오류 발생");
        }
      });
    }
  }
});
app.mount("#app");
</script>
</body>
</html>