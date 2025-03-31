<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>마이페이지</title>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <!-- Vue.js -->
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            /* 전체 레이아웃 설정 */
            body {
                margin: 0;
                padding: 0;
                font-family: 'Noto Sans KR', sans-serif;
                background-color: #fff;
                color: #333;
            }

            .container {
                /* 사이드 메뉴와 콘텐츠를 가로로 배치하기 위해 flex 사용 */
                display: flex;
                max-width: 1200px;
                min-height: calc(100vh - 300px);
                margin: 0 auto;
                padding: 20px;
                box-sizing: border-box;
            }

            /* 사이드 메뉴 */
            .side-menu {
                width: 200px;
                height: 100%;
                border: 1px solid #ddd;
                position: sticky;
                top: 0;
                background: white;
                transition: top 0.3s;
            }

            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .side-menu li {
                margin-bottom: 10px;
            }

            .side-menu a {
                text-decoration: none;
                color: #333;
                font-weight: 500;
            }

            .side-menu li a.active {
                display: block;
                background-color: #3e4a97;
                color: white;
                padding: 10px;
                text-decoration: none;
            }

            .side-menu a:hover {
                color: #ff5555;
            }

            /* 메인 콘텐츠 영역 */
            .content-area {
                flex: 1;
            }

            /* 공통 박스 스타일 */
            .box {
                border: 1px solid #ccc;
                padding: 20px;
                margin-bottom: 20px;
            }

            .box .title {
                margin: 0 0 15px;
                font-size: 16px;
                font-weight: bold;
            }

            /* 폼 그룹 공통 스타일 */
            .form-group {
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .form-group label {
                width: 115px;
                font-weight: 600;
                margin-right: 10px;
            }

            .form-group input[type="text"],
            .form-group input[type="password"] {
                flex: 1;
                padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
            }

            /* 필수 항목 표시 */
            .required::after {
                content: "*";
                margin-left: 4px;
                color: red;
            }

            /* 라디오 버튼 그룹 */
            .radio-group {
                display: flex;
                align-items: center;
            }

            .radio-group label {
                margin-right: 15px;
                font-weight: normal;
                cursor: pointer;
            }

            /* 저장하기 버튼 */
            .btn-save {
                margin-top: 20px;
                padding: 10px 20px;
                background-color: #3e4a97;
                border: none;
                color: #fff;
                font-size: 14px;
                cursor: pointer;
                border-radius: 5px;
            }

            .btn-save:hover {
                background-color: #2e3d9c;
            }

            .center-box {
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: center;
                margin-top: 150px;

                /* 필요 시 조정 */
                text-align: center;
                gap: 10px;
            }

            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            /* 팝업(모달) 콘텐츠 스타일 */
            .modal-content {
                background-color: #fff;
                padding: 20px;
                border-radius: 5px;
                width: 450px;
                margin-bottom: 15px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .modal-group {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                width: 100%;
                margin-bottom: 15px;
            }

            /* 모달 인풋 스타일 */
            .modal-input {
                width: 100%;
                padding: 8px;
                border: 1px solid #ccc;
                margin-bottom: 8px;
                box-sizing: border-box;
            }

            /* 유효성 검사 메시지 스타일 */
            .modal-validation {
                font-size: 13px;
                line-height: 1.4;
            }
        </style>
    </head>

    <body>
        <!-- 공통 헤더 -->
        <jsp:include page="../common/header.jsp" />

        <div id="app" class="container">
            <!-- 좌측 사이드 메뉴 -->
            <div class="side-menu">
                <ul>
                    <li>
                        <a :class="{ active: currentPage === 'user-mypage.do' }"
                            href="http://localhost:8080/mypage/user-mypage.do">
                            회원 정보수정
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-purchase-history.do' }"
                            href="http://localhost:8080/mypage/user-purchase-history.do">
                            구매한 상품
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-reviews.do' }"
                            href="http://localhost:8080/mypage/user-reviews.do">
                            이용후기 관리
                        </a>
                    </li>
                    <li>
                        <a href="http://localhost:8080/cs/qna.do">
                            문의하기
                        </a>
                    </li>
                    <li>
                        <a :class="{ active: currentPage === 'user-unregister.do' }"
                            href="http://localhost:8080/mypage/user-unregister.do">
                            회원 탈퇴
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 우측 메인 콘텐츠 -->
            <div class="content-area">
                <!-- 비밀번호 확인 -->
                <template v-if="!pwdCheckFlg && userInfo.socialType != 'SOCIAL'">
                    <div class="center-box">
                        <label>비밀 번호 : </label>
                        <input type="password" v-model="confirmPassword" placeholder="비밀번호를 입력해주세요."
                            @keyup.enter="fnGetInfo">
                        <button @click="fnGetInfo">확인</button>
                    </div>
                </template>
                <template v-if="pwdCheckFlg">
                    <!-- 회원 정보 섹션 -->
                    <div class="box">
                        <h3 class="title">회원 정보</h3>
                        <!-- 비밀번호 변경 -->
                        <div class="form-group">
                            <button class="btn-save" @click="fnNewPassword">비밀번호 변경</button>
                        </div>
                        <!-- 퍼스트 네임 -->
                        <div class="form-group">
                            <label for="firstName" class="required">FirstName</label>
                            <input type="text" id="firstName" v-model="userInfo.userFirstName" disabled />
                        </div>
                        <!-- 라스트 네임 -->
                        <div class="form-group" v-if="userInfo.userLastName != null">
                            <label for="lastName">LastName</label>
                            <input type="text" id="lastName" v-model="userInfo.userLastName" disabled />
                        </div>
                        <div class="form-group"
                            v-if="userInfo.userLastName == null && userInfo.socialType === 'SOCIAL'">
                            <label for="lastName">LastName</label>
                            <input type="text" id="lastName" v-model="userInfo.userLastName" />
                        </div>
                        <!-- 연락처 -->
                        <div class="form-group">
                            <label for="phone" class="required">연락처</label>
                            <input type="text" id="phone" v-model="userInfo.phone" />
                        </div>
                        <!-- 이메일 -->
                        <div class="form-group">
                            <label for="email" class="required">이메일</label>
                            <input type="text" id="email" v-model="userInfo.email" disabled />
                        </div>
                        <!-- 주소 -->
                        <div class="form-group">
                            <label for="address">주소</label>
                            <input type="text" id="address" v-model="userInfo.address" />
                        </div>
                        <!-- 성별 -->
                        <div class="form-group">
                            <label for="gender" class="required">성별</label>
                            <div class="radio-group" style="flex: 1;">
                                <label><input type="radio" value="M" v-model="userInfo.gender" /> 남성</label>
                                <label><input type="radio" value="F" v-model="userInfo.gender" /> 여성</label>
                            </div>
                        </div>
                        <!-- 생년월일 -->
                        <div class="form-group" v-if="!userInfo.birthday">
                            <label for="birthday" class="required">생년월일</label>
                            <input type="text" id="birthday" v-model="userInfo.birthday" disabled />
                        </div>
                        <div class="form-group" v-else>
                            <label for="birthday" class="required">생년월일</label>
                            <input type="date" id="birthday" v-model="userInfo.birthday" />
                        </div>
                    </div>
                    <!-- 푸쉬알림 동의여부 -->
                    <div class="box">
                        <h3 class="title">푸쉬알림 동의여부</h3>
                        <div class="form-group">
                            <label style="width:auto;">수신 동의</label>
                            <div class="radio-group">
                                <label><input type="radio" value="Y" v-model="userInfo.pushYN" /> 예</label>
                                <label><input type="radio" value="N" v-model="userInfo.pushYN" /> 아니요</label>
                            </div>
                        </div>
                    </div>

                    <!-- 저장하기 버튼 -->
                    <button class="btn-save" @click="saveInfo">저장하기</button>
                </template>
                <template v-if="showPasswordModal">
                    <div class="modal-overlay" @click.self="closeModal">
                        <div class="modal-content">
                            <!-- 비밀번호 -->
                            <div class="modal-group">
                                <label for="newPassword1" class="required">비밀번호</label>
                                <input type="password" id="newPassword1" v-model="newPassword1"
                                       @input="validateNewPassword" class="modal-input" />
                                <div v-if="newPassword1.length > 0 && !passwordValid" class="modal-validation">
                                  <div :style="{ color: passwordRules.length ? 'green' : 'red' }">
                                    {{ passwordRules.length ? '✅ At least 6 characters' : '❌ At least 6 characters' }}
                                  </div>
                                  <div :style="{ color: passwordRules.number ? 'green' : 'red' }">
                                    {{ passwordRules.number ? '✅ At least one number' : '❌ At least one number' }}
                                  </div>
                                  <div :style="{ color: passwordRules.upper ? 'green' : 'red' }">
                                    {{ passwordRules.upper ? '✅ At least one uppercase letter' : '❌ At least one uppercase letter' }}
                                  </div>
                                  <div :style="{ color: passwordRules.lower ? 'green' : 'red' }">
                                    {{ passwordRules.lower ? '✅ At least one lowercase letter' : '❌ At least one lowercase letter' }}
                                  </div>
                                  <div :style="{ color: passwordRules.special ? 'green' : 'red' }">
                                    {{ passwordRules.special ? '✅ At least one special character' : '❌ At least one special character' }}
                                  </div>
                                </div>
                            </div>
                            <div class="modal-group">
                                <label for="newPassword2" class="required">비밀번호 확인</label>
                                <input type="password" id="newPassword2" v-model="newPassword2"
                                    @input="validateNewPassword"   
                                    @keyup.enter="fnChangePassword" class="modal-input" />
                                <div v-if="newPassword2.length > 0 && passwordValid"
                                     class="modal-validation"
                                     :style="{ color: passwordsMatch ? 'green' : 'red' }">
                                  {{ passwordsMatch ? '✅ Passwords match.' : '❌ Passwords do not match.' }}
                                </div>
                            </div>
                            <button class="btn-save" @click="fnChangePassword">변경</button>
                        </div>
                </template>
            </div>
        </div>

        <!-- 공통 푸터 -->
        <jsp:include page="../common/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 예: 이미 인증된 이메일 정보(샘플)
                        userInfo: {
                            phone: "",
                            birthday: "",
                            gender: "",
                            address: "",
                            userLastName: "",
                        },
                        confirmPassword: "",
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        pwdCheckFlg: false,
                        currentPage: "",
                        showPasswordModal: false,
                        newPassword1: "",
                        newPassword2: "",
                        passwordRules: { length: false, upper: false, lower: false, special: false, number: false },
                        passwordValid: false,
                        passwordsMatch: false
                    };
                },
                methods: {
                    // '저장하기' 버튼 클릭 시
                    saveInfo() {
                        // 간단한 유효성 검사 예시
                        let self = this;
                        if (self.userInfo.phone === null) {
                            alert("연락처를 입력해주세요.");
                            return;
                        }
                        if (self.userInfo.birthday === null) {
                            alert("생년월일을 입력해주세요.");
                            return;
                        }
                        if (self.userInfo.gender === null) {
                            alert("성별을 입력해주세요.");
                            return;
                        }
                        if (self.userInfo.socialType === "SOCIAL" && self.userInfo.password === "Test1234!") {
                            alert("비밀번호를 변경해주세요.");
                            return;
                        }

                        // 서버로 전송할 데이터
                        let nparmap = {
                            userLastName: self.userInfo.userLastName,
                            phone: self.userInfo.phone,
                            address: self.userInfo.address,
                            gender: self.userInfo.gender,
                            birthday: self.userInfo.birthday,
                            pushYN: self.userInfo.pushYN,
                            sessionId: self.sessionId,
                        };

                        // Ajax 요청
                        $.ajax({
                            url: "/mypage/info-edit.dox", // 실제 처리할 URL로 수정
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                console.log("서버 응답:", data);
                                alert("회원정보가 저장되었습니다.");
                            },
                            error: function (err) {
                                console.log(err);
                                alert("오류가 발생했습니다.");
                            }
                        });
                    },
                    fnGetInfo() {
                        let self = this;
                        let nparmap = {
                            sessionId: self.sessionId,
                            confirmPassword: self.confirmPassword
                        };
                        console.log(self.sessionId);
                        $.ajax({
                            url: "/mypage/user-info.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("userData: " + data);
                                    self.userInfo = data.userInfo;
                                    console.log(self.userInfo);
                                    self.pwdCheckFlg = true;
                                } else if (data.result == "fail") {
                                    alert("비밀번호를 확인해주세요");
                                } else {
                                    alert("정보를 가지고 오는데 실패했습니다.");
                                }
                            }
                        });
                    },
                    fnNewPassword() {
                        // 비밀번호 변경 버튼 클릭 시 팝업을 띄웁니다.
                        this.showPasswordModal = true;
                    },
                    validateNewPassword() {
                        const pw = this.newPassword1;
                        const pw2 = this.newPassword2;
                        this.passwordRules.length = pw.length >= 6;
                        this.passwordRules.upper = /[A-Z]/.test(pw);
                        this.passwordRules.lower = /[a-z]/.test(pw);
                        this.passwordRules.special = /[^A-Za-z0-9]/.test(pw);
                        this.passwordRules.number = /[0-9]/.test(pw);
                        this.passwordValid = this.passwordRules.length && this.passwordRules.upper &&
                            this.passwordRules.lower && this.passwordRules.special && this.passwordRules.number;
                        this.passwordsMatch = pw && pw2 && (pw === pw2);
                    },
                    fnChangePassword() {
                        // 실제 비밀번호 변경 AJAX 요청 추가 가능
                        let self = this;
                        let nparmap = {
                            newPassword1: self.newPassword1,
                            sessionId: self.sessionId,
                        };
                        console.log(self.sessionId);
                        $.ajax({
                            url: "/mypage/changePassword.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log(data);
                                    self.showPasswordModal = false;
                                    self.newPassword1 = "";
                                    self.newPassword2 = "";
                                    self.passwordRules = { length: false, upper: false, lower: false, special: false, number: false };
                                    self.passwordValid = false;
                                    self.passwordsMatch = false;
                                    alert("비밀번호가 변경되었습니다.");
                                } else {
                                    alert("비밀번호 변경에 실패했습니다.");
                                }
                            }
                        });
                    },
                    closeModal() {
                        this.showPasswordModal = false;
                        this.newPassword1 = "";
                        this.newPassword2 = "";
                        this.passwordRules = { length: false, upper: false, lower: false, special: false, number: false };
                        this.passwordValid = false;
                        this.passwordsMatch = false;
                    },
                },
                mounted() {
                    // 페이지 로드시 필요한 초기화 로직
                    // 세션롤이 가이드가 아니거나 세션아이디가 널이면 알림창
                    console.log(this.sessionId);
                    if (this.sessionId == '') {
                        alert("로그인 후 이용해주세요.");
                        location.href = "http://localhost:8080/main.do";
                    }
                    if (this.sessionRole != 'TOURIST') {
                        alert("일반회원만 이용가능합니다.");
                        location.href = "http://localhost:8080/main.do";
                    }
                    this.currentPage = window.location.pathname.split('/').pop();
                    console.log("Current page:", this.currentPage);
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>