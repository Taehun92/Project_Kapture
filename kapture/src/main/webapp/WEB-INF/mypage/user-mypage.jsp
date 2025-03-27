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
                width: 100px;
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
                background-color: #ff5555;
                border: none;
                color: #fff;
                font-size: 14px;
                cursor: pointer;
            }

            .btn-save:hover {
                background-color: #ff3333;
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

                <!-- 전체 폼을 하나로 감싸기 -->

                <!-- 비밀번호 섹션 -->
                <!-- <div class="box">
                    <h3 class="title">비밀번호</h3>
                    <div class="form-group">
                        <label for="password" class="required">비밀번호</label>
                        <input type="password" id="password" v-model="password" />
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="required">비밀번호 확인</label>
                        <input type="password" id="confirmPassword" v-model="confirmPassword" />
                    </div>
                </div> -->
                <!-- 비밀번호 확인 -->
                <template v-if="!pwdCheckFlg && userInfo.socialType != 'SOCIAL'">
                    <div class="center-box">
                        <label>비밀 번호 : </label>
                        <input type="password" v-model="userInfo.confirmPassword" placeholder="비밀번호를 입력해주세요."
                            @keyup.enter="fnGetInfo">
                        <button @click="fnGetInfo">확인</button>
                    </div>
                </template>
                <template v-if="pwdCheckFlg">
                    <!-- 회원 정보 섹션 -->
                    <div class="box">
                        <h3 class="title">회원 정보</h3>
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
                        <div class="form-group" v-if="userInfo.userLastName = null && socialType === 'SOCIAL'">
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
                        <!-- 성별 -->
                        <div class="form-group" v-if="userInfo.gender != null">
                            <label>성별</label>
                            <div class="radio-group" style="flex: 1;">
                                <label><input type="radio" value="M" v-model="userInfo.gender" /> 남성</label>
                                <label><input type="radio" value="F" v-model="userInfo.gender" /> 여성</label>
                            </div>
                        </div>
                        <div class="form-group" v-else>
                            <label class="required">성별</label>
                            <div class="radio-group" style="flex: 1;">
                                <label><input type="radio" value="M" v-model="userInfo.gender" /> 남성</label>
                                <label><input type="radio" value="F" v-model="userInfo.gender" /> 여성</label>
                            </div>
                        </div>
                        <!-- 생년월일 -->
                        <div class="form-group">
                            <label for="birthday" class="required">생년월일</label>
                            <!-- placeholder는 예시, 실제로 type="date"로 변경도 가능 -->
                            <input type="text" id="birthday" v-model="userInfo.birthday" disabled />
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
                            email: '',
                            userFirstName: '',
                            userLastName: '',
                            phone: '',
                            password: '',
                            confirmPassword: '',
                            pushYN: '',
                            gender: '',
                            birthday: '',
                            isForeigner: '',
                            socialType: '',
                        },
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        pwdCheckFlg: false,
                        currentPage: "",
                    };
                },
                methods: {
                    // '저장하기' 버튼 클릭 시
                    saveInfo() {
                        // 간단한 유효성 검사 예시
                        let self = this;
                        if (self.phone === null) {
                            alert("연락처를 입력해주세요.");
                            return;
                        }
                        // 서버로 전송할 데이터
                        let nparmap = {
                            name: self.userInfo.name,
                            phone: self.userInfo.phone,
                            password: self.userInfo.password,
                            email: self.userInfo.email,
                            gender: self.userInfo.gender,
                            birthday: self.userInfo.birthday,
                            pushYN: self.userInfo.pushYN,
                            isForeigner: self.userInfo.isForeigner,
                            socialType: self.userInfo.socialType,
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
                            confirmPassword: self.userInfo.confirmPassword
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
                    }
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