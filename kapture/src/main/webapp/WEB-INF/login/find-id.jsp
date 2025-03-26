<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <title>Kapture - Find Account</title>
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
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .form-input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    .radio-input {
      margin-right: 8px;
      cursor: pointer;
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

    .tab-switch {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
    }

    .tab-switch a {
      color: #2b74e4;
      cursor: pointer;
      text-decoration: underline;
      margin-left: 5px;
    }

    .verified-message {
      color: green;
      font-size: 13px;
      margin-top: 5px;
      text-align: left;
    }
  </style>
</head>

<body>
  <div id="app">
    <h2 style="text-align:center;">{{ mode === 'findId' ? 'Find Your Email' : 'Reset Your Password' }}</h2>

    <div class="tab-switch">
      <span v-if="mode === 'findId'">
        이미 아이디를 알고 계신가요?
        <a @click="mode = 'findPw'">비밀번호 찾기</a>
      </span>
      <span v-else>
        아이디를 모르시나요?
        <a @click="mode = 'findId'">아이디 찾기</a>
      </span>
    </div>

    <template v-if="mode === 'findId'">
      <input v-model="user.firstName" @input="normalizeName('firstName')" placeholder="First Name" class="form-input" />
      <input v-model="user.lastName" @input="normalizeName('lastName')" placeholder="Last Name" class="form-input" />
      <div style="display: flex; gap: 10px;">
        <input v-model="birthday.MM" maxlength="2" placeholder="MM" class="form-input" />
        <input v-model="birthday.DD" maxlength="2" placeholder="DD" class="form-input" />
        <input v-model="birthday.YYYY" maxlength="4" placeholder="YYYY" class="form-input" />
      </div>
      <input v-model="user.phone" @input="normalizePhone" placeholder="Phone Number" class="form-input" />
      <button class="action-btn" @click="findEmail">Find Email</button>
      <div class="info" v-if="foundEmails.length > 0">
        <p>✅ 등록된 이메일 목록:</p>
        <div v-for="email in foundEmails" :key="email" style="margin-bottom: 8px;">
          <label style="display: flex; align-items: center; cursor: pointer;">
            <input type="radio" name="selectedEmail" :value="email" v-model="selectedEmail" class="radio-input" />
            <span style="font-size: 14px; color: #333;">{{ email }}</span>
          </label>
        </div>
        <button class="action-btn" @click="askPasswordReset">Reset Password?</button>
      </div>
    </template>

    <template v-else>
      <input v-model="selectedEmail" :disabled="verified" placeholder="Your Email" class="form-input" />
      <button v-if="!verified" class="action-btn" @click="askPasswordReset">Send Verification Code</button>
    </template>

    <div v-if="emailForReset && !verified">
      <input v-model="verificationCode" placeholder="Enter verification code" class="form-input" />
      <button class="action-btn" @click="verifyCode">Verify</button>
    </div>

    <div v-if="verified" class="verified-message">✅ 인증이 완료되었습니다.</div>

    <div v-if="verified">
      <input type="password" v-model="newPassword" placeholder="Enter new password" class="form-input" />
      <div v-if="newPassword.length > 0 && !passwordValid" style="font-size: 13px; margin-top: 5px;">
        <div class="mt-4 space-y-1 text-sm">
          <div :class="passwordRules.length ? 'text-green-600' : 'text-red-500'">
            {{ passwordRules.length ? '✅ 6자 이상' : '❌ 6자 이상' }}
          </div>
          <div :class="passwordRules.upper ? 'text-green-600' : 'text-red-500'">
            {{ passwordRules.upper ? '✅ 대문자 포함' : '❌ 대문자 포함' }}
          </div>
          <div :class="passwordRules.lower ? 'text-green-600' : 'text-red-500'">
            {{ passwordRules.lower ? '✅ 소문자 포함' : '❌ 소문자 포함' }}
          </div>
          <div :class="passwordRules.number ? 'text-green-600' : 'text-red-500'">
            {{ passwordRules.number ? '✅ 숫자 포함' : '❌ 숫자 포함' }}
          </div>
          <div :class="passwordRules.special ? 'text-green-600' : 'text-red-500'">
            {{ passwordRules.special ? '✅ 특수문자 포함' : '❌ 특수문자 포함' }}
          </div>
        </div>
      </div>
      <input type="password" v-model="confirmPassword" placeholder="Confirm new password" class="form-input" />
      <div v-if="confirmPassword.length > 0" class="mt-2 text-sm font-medium" :class="passwordsMatch ? 'text-green-600' : 'text-red-500'">
        {{ passwordsMatch ? '✅ 비밀번호가 일치합니다' : '❌ 비밀번호가 일치하지 않습니다' }}
      </div>
      <button class="action-btn" @click="resetPassword">Change Password</button>
    </div>
  </div>

  <script>
    const app = Vue.createApp({
      data() {
        return {
          mode: 'findId',
          user: { firstName: '', lastName: '', phone: '' },
          birthday: { MM: '', DD: '', YYYY: '' },
          foundEmails: [],
          selectedEmail: '',
          emailForReset: '',
          verificationCode: '',
          newPassword: '',
          confirmPassword: '',
          verified: false,
          emailCodeSent: false,
          codeMessage: '',
          passwordRules: { length: false, upper: false, lower: false, number: false, special: false },
          passwordValid: false,
          passwordsMatch: false
        }
      },
      watch: {
        newPassword() { this.validatePassword(); },
        confirmPassword() { this.validatePassword(); }
      },
      methods: {
        normalizeName(field) {
          let value = this.user[field] || "";
          value = value.trim().toLowerCase();
          value = value.charAt(0).toUpperCase() + value.slice(1);
          this.user[field] = value;
        },
        normalizePhone() {
          this.user.phone = this.user.phone.replace(/\s|-/g, '').replace(/[^0-9]/g, '');
        },
        formatBirthday() {
          const { YYYY, MM, DD } = this.birthday;
          if (!YYYY || !MM || !DD) return "";
          return YYYY.slice(-2) + '/' + MM.padStart(2, '0') + '/' + DD.padStart(2, '0');
        },
        findEmail() {
          if (!this.user.firstName || !this.user.lastName || !this.user.phone || !this.birthday.YYYY || !this.birthday.MM || !this.birthday.DD) {
            alert("모든 값을 입력해 주세요."); return;
          }
          const birthdayFormatted = this.formatBirthday();
          $.ajax({
            url: "/find-email.dox",
            type: "POST",
            data: {
              firstName: this.user.firstName,
              lastName: this.user.lastName,
              phone: this.user.phone,
              birthday: birthdayFormatted
            },
            dataType: "json",
            success: data => {
              if (data.result === "success") {
                this.foundEmails = data.emailList;
                if (this.foundEmails.length === 1) this.selectedEmail = this.foundEmails[0];
              } else {
                alert("❌ 일치하는 계정을 찾을 수 없습니다.");
              }
            }
          });
        },
        askPasswordReset() {
          if (!this.selectedEmail) {
            alert("이메일을 입력하거나 선택해주세요.");
            return;
          }
          this.emailForReset = this.selectedEmail;
          this.sendVerificationCode();
        },
        sendVerificationCode() {
          if (!this.emailForReset) return;
          alert("📨 인증 코드가 곧 전송됩니다. 이메일을 확인해주세요!");
          $.ajax({
            url: "/login/email/send.dox",
            type: "POST",
            data: { email: this.emailForReset },
            dataType: "json",
            success: data => {
              if (data.result === "success") this.emailCodeSent = true;
              else alert("❌ 인증 메일 전송 실패: " + (data.message || "알 수 없는 오류"));
            },
            error: xhr => alert("❌ 서버 오류: " + xhr.responseText)
          });
        },
        verifyCode() {
          if (!this.verificationCode) return alert("인증번호를 입력해주세요.");
          $.ajax({
            url: "/login/email/verify.dox",
            type: "POST",
            data: { email: this.emailForReset, code: this.verificationCode },
            dataType: "json",
            success: data => {
              if (data.result === "success") {
                this.verified = true;
                alert("✅ 인증이 완료되었습니다.");
              } else {
                alert("❌ 인증 실패: " + data.message);
                this.verificationCode = "";
              }
            }
          });
        },
        validatePassword() {
          const pw = this.newPassword;
          const pw2 = this.confirmPassword;
          this.passwordRules.length = pw.length >= 6;
          this.passwordRules.upper = /[A-Z]/.test(pw);
          this.passwordRules.lower = /[a-z]/.test(pw);
          this.passwordRules.number = /[0-9]/.test(pw);
          this.passwordRules.special = /[^A-Za-z0-9]/.test(pw);
          this.passwordValid = Object.values(this.passwordRules).every(Boolean);
          this.passwordsMatch = pw && pw2 && pw === pw2;
        },
        resetPassword() {
          if (!this.passwordValid || !this.passwordsMatch) return alert("❌ 비밀번호 조건을 확인해주세요.");
          $.ajax({
            url: "/login/reset-password.dox",
            type: "POST",
            data: { email: this.emailForReset, password: this.newPassword },
            contentType: "application/x-www-form-urlencoded",
            dataType: "json",
            success: data => {
              if (data.result === "success") {
                alert("✅ 비밀번호가 성공적으로 변경되었습니다.");
                location.href = "/login.do";
              } else {
                alert("❌ 변경 실패: " + data.message);
              }
            }
          });
        }
      }
    });
    app.mount('#app');
  </script>
</body>

</html>