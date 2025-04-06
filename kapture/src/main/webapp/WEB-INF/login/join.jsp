<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Kapture - Join</title>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
    .form-input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
      font-size: 14px;
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
    .modal-wrapper {
      position: fixed;
      top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: flex; justify-content: center; align-items: center;
    }
    .modal-box {
      background: white;
      padding: 50px;
      border-radius: 2px;
      max-width: 500px;
      max-height: 70vh;
      overflow-y: auto;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }
    .terms-group {
      display: flex;
      flex-direction: column;
      gap: 12px;
      font-size: 14px;
      margin-top: 20px;
    }
    .terms-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      font-size: 14px;
      line-height: 1.5;
    }
    .checkbox {
      width: auto;
      margin: 0;
      transform: scale(1.1);
      cursor: pointer;
    }
    .terms-item span {
      flex: 1;
      word-break: keep-all;
    }
    .terms-item a {
      color: #2b74e4;
      font-size: 13px;
      text-decoration: none;
      white-space: nowrap;
    }
    .terms-item a:hover {
      text-decoration: underline;
    }
    .radio-group {
      display: flex;
      gap: 20px;
      margin-bottom: 15px;
    }
    .radio-group label {
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .name-tag {
      font-size: 14px; 
      margin-top: 10px; 
      font-weight: bold; 
      color: #444;
    }
  </style>
</head>
<body>
  <!-- 뒤로가기 버튼 -->
<div style="position: absolute; top: 20px; left: 20px; ">
  <button onclick="window.history.back()" style="
    background-color: transparent;
    border: none;
    color: black;
    font-size: 18px;
    font-weight: 700;
    cursor: pointer;
  ">
    <i class="fas fa-arrow-left"></i> Back
  </button>
</div>
<div id="app">
  <h2>Join Kapture</h2>
  <!-- 국적 선택 -->
  <div class="radio-group">
    <label><input type="radio" value="N" v-model="user.isForeigner"> <h3>내국인</h3></label>
    <label><input type="radio" value="Y" v-model="user.isForeigner"> <h3>외국인</h3></label>
  </div>
  <div class="name-tag">이메일</div>
  <!-- Email -->
  <input type="text" class="form-input" placeholder="Email" v-model="user.email" :disabled="emailVerified" />
  <div v-if="emailCheckMessage && !emailVerified" :style="{ color: emailCheckColor, fontSize: '13px', marginTop: '5px' }">
    {{ emailCheckMessage }}
  </div>
  <button @click="sendVerificationCode">Send Code</button>

  <div v-if="emailCodeSent && !emailVerified">
    <div class="name-tag">인증번호</div>
    <input type="text" class="form-input" v-model="userInputCode" placeholder="Enter verification code" />
    <button @click="verifyCode">Verify</button>
  </div>
  <div v-if="emailVerified" style="color: green; font-size: 13px; margin-top: 5px;">✅ Email verified successfully.</div>
  <div v-if="emailError" style="color: red; font-size: 13px;">{{ emailError }}</div>
  
  <div class="name-tag">비밀번호</div>
  <input type="password" class="form-input" v-model="user.password" placeholder="Password" />
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

<!-- 비밀번호 확인 입력 필드 -->
<input type="password" class="form-input" v-model="user.password2" placeholder="Re-enter Password" />
<!-- 비밀번호 일치 여부 안내 -->
<div
    v-if="user.password2.length > 0 && passwordValid"
    :style="{ color: passwordsMatch ? 'green' : 'red', fontSize: '13px' }"
  >
    {{ passwordsMatch ? '✅ Passwords match.' : '❌ Passwords do not match.' }}
  </div>

  <hr>
  <div class="name-tag">이름</div>
  <!-- 이름 입력 -->
  <div v-if="user.isForeigner === 'N'">
    <input type="text" class="form-input" placeholder="Name" v-model="user.firstName" />
  </div>
  <div v-else>
    <input type="text" class="form-input" placeholder="First Name" v-model="user.firstName" />
    <input type="text" class="form-input" placeholder="Last Name" v-model="user.lastName" />
  </div>
  <div class="name-tag">연락처</div>
  <!-- Phone & Birthdate -->
  <input type="text" class="form-input" placeholder="Phone Number" v-model="user.phone" />
  <div v-if="user.phone.length > 0 && !isPhoneValid()" style="color: red; font-size: 13px; margin-top: 5px;">
    ❌ Phone number must contain digits only
  </div>

  <div class="name-tag">생년월일</div>
  <div style="display: flex; gap: 8px;">
    <input type="text" class="form-input" v-model="birth.mm" maxlength="2" placeholder="MM" style="flex: 1;" />
    <input type="text" class="form-input" v-model="birth.dd" maxlength="2" placeholder="DD" style="flex: 1;" />
    <input type="text" class="form-input" v-model="birth.yyyy" maxlength="4" placeholder="YYYY" style="flex: 2;" />
  </div>
  <div v-if="!isBirthdayValid" style="color: red; font-size: 13px; margin-top: 5px;">
    ❌ 생년월일을 올바르게 입력해주세요.
  </div>
  <div class="name-tag">성별</div>
  <div class="radio-group" style="margin-top: 15px;">
    <label><input type="radio" value="M" v-model="user.gender" /> 남자</label>
    <label><input type="radio" value="F" v-model="user.gender" /> 여자</label>
  </div>
  <hr>
  <!-- 약관 동의 -->
  <h2>이용 약관 동의</h2>
  <div class="terms-group">
    <label class="terms-item">
      <input type="checkbox" v-model="allAgreed" @change="toggleAllTerms" class="checkbox" />
      <span style="font-weight: bold;">전체 약관에 동의합니다</span>
    </label>
    <label class="terms-item">
      <input type="checkbox" v-model="terms.use" class="checkbox" />
      <span>이용약관 동의 (필수)</span>
      <a href="#" @click.prevent="openTerms('use')">[보기]</a>
    </label>
    <label class="terms-item">
      <input type="checkbox" v-model="terms.privacy" class="checkbox" />
      <span>개인정보 수집 및 이용 동의 (필수)</span>
      <a href="#" @click.prevent="openTerms('privacy')">[보기]</a>
    </label>
    <label class="terms-item">
      <input type="checkbox" v-model="terms.marketing" class="checkbox" />
      <span>마케팅 정보 수신 동의 (선택)</span>
      <a href="#" @click.prevent="openTerms('marketing')">[보기]</a>
    </label>
  </div>

  <!-- 모달 -->
  <div v-if="modalVisible" class="modal-wrapper" @click.self="closeTerms">
    <div class="modal-box">
      <div v-html="termsContent"></div>
      <button @click="closeTerms">닫기</button>
    </div>
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
    회원가입
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
        lastName: null, 
        phone: '', 
        birthday: '',
        gender: 'M',
        isForeigner : 'Y',
        pushYn : 'N'
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
      passwordsMatch: false,
      agreeChecked: false,
      modalVisible: false,
      termsContent: '',
      currentTermsType: '',
      terms: {
        use: false,
        privacy: false,
        marketing: false
      }
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
        this.user.phone &&
        this.user.birthday &&
        this.isPhoneValid() &&
        this.terms.use &&           // 🔒 필수 약관
        this.terms.privacy          // 🔒 필수 약관

      );
    },
    allAgreed() {
      return this.terms.use && this.terms.privacy && this.terms.marketing;
    },

    allRequiredAgreed() {
      return this.terms.use && this.terms.privacy;
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
    isPhoneValid() {
    return /^[0-9]*$/.test(this.user.phone);
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
      const isValid = (
        yyyy.length === 4 &&
        mm.length >= 1 &&
        dd.length >= 1 &&
        !isNaN(yyyyNum) && !isNaN(mmNum) && !isNaN(ddNum) &&
        mmNum >= 1 && mmNum <= 12 &&
        ddNum >= 1 && ddNum <= 31 &&
        yyyyNum >= 1900 && yyyyNum <= 2100
      );
      this.isBirthdayValid = isValid;
      if (isValid) {
        const yy = yyyy.slice(2);
        const pad = (n) => n.toString().padStart(2, '0');
        const paddedMM = pad(mm);
        const paddedDD = pad(dd);
        this.user.birthday = yy +'/'+ paddedMM +'/'+ paddedDD;
      } else {
        this.user.birthday = null; // or ''
      }
    },

    fnJoin() {
      const self = this;
      this.validateBirthdayParts();
    
      if (!this.canSubmit || !this.isBirthdayValid) {
        alert("Please complete all required fields correctly.");
        return;
      }

      console.log("전송 전 birthday:", this.user.birthday);

      if(!self.terms.marketing){
        self.user.pushYn = 'N'
      } else {
        self.user.pushYn = 'Y'
      }


      $.ajax({
        url: "join.dox",
        type: "POST",
        dataType: "json",
        data: {
          email : self.user.email, 
          password : self.user.password,
          firstName : self.user.firstName, 
          lastName : self.user.lastName, 
          phone : self.user.phone, 
          birthday : self.user.birthday,
          gender : self.user.gender,
          isForeigner : self.user.isForeigner,
          pushYn : self.user.pushYn
        },
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
    },

    toggleAllTerms() {
      const newValue = !this.allAgreed;
      this.terms.use = newValue;
      this.terms.privacy = newValue;
      this.terms.marketing = newValue;
    },

    openTerms(type) {
      if (!type) {
        console.warn("❗ 약관 타입(type)이 정의되지 않았습니다.");
        return;
      }
      this.currentTermsType = type;
      this.modalVisible = true;
      this.loadTerms(type);
    },

    loadTerms(type) {
      if (!type) return;
      fetch("/html/terms_" + type + ".html")
        .then(res => res.text())
        .then(html => {
          this.termsContent = html;
        })
        .catch(() => {
          this.termsContent = '<p>⚠️ 약관을 불러오지 못했습니다.</p>';
        });
    },

    closeTerms() {
      this.modalVisible = false;
    }


  }
});
app.mount("#app");
</script>
</body>
</html>