// 📁 /static/js/registerFormApp.js

import TermsAgreement from './components/TermsAgreement.js'

const app = Vue.createApp({
    components: { TermsAgreement },
    data() {
        return {
            user: {
                email: '', password: '', password2: '',
                firstName: '', lastName: '', phone: '', birthday: ''
            },
            birth: { mm: '', dd: '', yyyy: '' },
            userInputCode: '',
            emailCodeSent: false,
            emailVerified: false,
            emailError: '',
            emailCheckMessage: '',
            emailCheckColor: '',
            emailValid: false,
            emailAvailable: false,
            passwordRules: {
                length: false, number: false, upper: false, lower: false, special: false
            },
            passwordValid: false,
            passwordsMatch: false,
            isBirthdayValid: true,
            showTermsModal: false,
            modalType: ''
        }
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
    watch: {
        'user.password': 'validatePassword',
        'user.password2': 'validatePassword',
        'user.email': function(val) {
            clearTimeout(this.emailCheckTimer)
            if (!val) return this.emailCheckMessage = ''
            this.emailCheckTimer = setTimeout(() => this.fnIdCheck(), 500)
        },
        'birth.mm': 'validateBirthdayParts',
        'birth.dd': 'validateBirthdayParts',
        'birth.yyyy': 'validateBirthdayParts'
    },
    methods: {
        showModal(type) {
            this.modalType = type
            this.showTermsModal = true
        },
        fnJoin() {
            this.validateBirthdayParts()
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
                    alert("🎉 Congratulations on becoming a member.");
                    location.href = "/login.do";
                }
            });
        },
        validatePassword() {
            const pw = this.user.password
            const pw2 = this.user.password2

            this.passwordRules.length = pw.length >= 6
            this.passwordRules.upper = /[A-Z]/.test(pw)
            this.passwordRules.lower = /[a-z]/.test(pw)
            this.passwordRules.special = /[^A-Za-z0-9]/.test(pw)
            this.passwordRules.number = /[0-9]/.test(pw)

            this.passwordValid = Object.values(this.passwordRules).every(Boolean)
            this.passwordsMatch = pw && pw2 && pw === pw2
        },
        isValidEmail(email) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
        },
        fnIdCheck() {
            const email = this.user.email
            if (!email || !this.isValidEmail(email)) {
                this.emailCheckMessage = '⚠️ Invalid email format.'
                this.emailCheckColor = 'orange'
                this.emailValid = false
                this.emailAvailable = false
                return
            }
            this.emailValid = true
            $.ajax({
                url: '/check.dox',
                type: 'POST',
                dataType: 'json',
                data: { email },
                success: (data) => {
                    if (data.count === 0) {
                        this.emailCheckMessage = '✅ This email is available.'
                        this.emailCheckColor = 'green'
                        this.emailAvailable = true
                    } else {
                        this.emailCheckMessage = '❌ This email is already in use.'
                        this.emailCheckColor = 'red'
                        this.emailAvailable = false
                    }
                },
                error: () => {
                    this.emailCheckMessage = '⚠️ Failed to check email.'
                    this.emailCheckColor = 'red'
                    this.emailAvailable = false
                }
            })
        },
        sendVerificationCode() {
            $.ajax({
                url: "/login/email/send.dox",
                type: "POST",
                data: { email: this.user.email },
                success: (data) => {
                    if (data.result === "success") {
                        alert("✅ " + data.message);
                        this.emailCodeSent = true;
                    } else {
                        alert("❌ 인증 메일 전송 실패: " + (data.message || "알 수 없는 오류"));
                    }
                },
                error: (xhr) => {
                    console.error("❌ 서버 오류:", xhr.responseText);
                    alert("❌ 서버 통신 오류 발생");
                }
            })
        },
        verifyCode() {
            $.ajax({
                url: "/login/email/verify.dox",
                type: "POST",
                data: { email: this.user.email, code: this.userInputCode },
                success: (data) => {
                    if (data.result === "success") {
                        this.emailVerified = true
                        this.emailError = ""
                        alert("Email successfully verified!")
                    } else {
                        this.emailVerified = false
                        this.emailError = data.message
                    }
                }
            })
        },
        validateBirthdayParts() {
            const { mm, dd, yyyy } = this.birth
            const mmNum = parseInt(mm), ddNum = parseInt(dd), yyyyNum = parseInt(yyyy)
            const isValid = (
                yyyy.length === 4 && mm.length >= 1 && dd.length >= 1 &&
                !isNaN(yyyyNum) && !isNaN(mmNum) && !isNaN(ddNum) &&
                mmNum >= 1 && mmNum <= 12 && ddNum >= 1 && ddNum <= 31 &&
                yyyyNum >= 1900 && yyyyNum <= 2100
            )
            this.isBirthdayValid = isValid
            if (isValid) {
                const yy = yyyy.slice(2)
                const pad = (n) => n.toString().padStart(2, '0')
                this.user.birthday = yy + '/' + pad(mm) + '/' + pad(dd)
            } else {
                this.user.birthday = null
            }
        }
    },
    template: `
        <div class="max-w-2xl mx-auto mt-20 bg-white p-8 rounded-xl shadow-md">
            <h2 class="text-2xl font-bold text-center mb-6">Join Kapture</h2>

            <input placeholder="First Name" v-model="user.firstName" class="w-full p-3 border border-gray-300 rounded mb-3" />
            <input placeholder="Last Name" v-model="user.lastName" class="w-full p-3 border border-gray-300 rounded mb-3" />
            <input placeholder="Phone Number" v-model="user.phone" class="w-full p-3 border border-gray-300 rounded mb-3" />
            <div class="flex gap-3 mb-3">
                <input type="text" v-model="birth.mm" maxlength="2" placeholder="MM" class="flex-1 p-3 border border-gray-300 rounded" />
                <input type="text" v-model="birth.dd" maxlength="2" placeholder="DD" class="flex-1 p-3 border border-gray-300 rounded" />
                <input type="text" v-model="birth.yyyy" maxlength="4" placeholder="YYYY" class="flex-1 p-3 border border-gray-300 rounded" />
            </div>
            <div v-if="!isBirthdayValid" class="text-red-600 text-sm mb-3">❌ 생년월일을 올바르게 입력해주세요.</div>

            <terms-agreement @agreed="fnJoin" />

            <terms-agreement
                v-if="showTermsModal"
                :type="modalType"
                @close="showTermsModal = false"
            />
        </div>
    `
})

export default app
