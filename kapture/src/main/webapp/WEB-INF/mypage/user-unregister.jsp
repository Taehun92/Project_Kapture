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
                ;
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
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;

            }

            .side-menu li {
                margin-bottom: 10px;

            }

            .side-menu li a.active {
                display: block;
                background-color: #3e4a97;
                color: white;
                padding: 10px;
                text-decoration: none;
            }

            .side-menu a {
                text-decoration: none;
                color: #333;
                font-weight: 500;
            }

            .side-menu a:hover {
                color: #ff5555;
            }

            /* 메인 콘텐츠 영역 */
            .content-area {
                flex: 1;
            }

            .center-box-column {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                margin-top: 150px;

                /* 필요 시 조정 */
                text-align: center;
                gap: 10px;
            }

            .center-box-row {
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: center;
                margin-top: 150px;

                /* 필요 시 조정 */
                text-align: center;
                gap: 10px;
            }

            .alert-label {
                margin: 0 0 15px;
                font-size: 16px;
                font-weight: bold;
                color: red;
            }

            .btn-unregister {
                margin: 20px;
                padding: 10px 20px;
                background-color: #3e4a97;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                cursor: pointer;
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
                <div class="center-box-column" v-if="!unregisterFlg">
                    <label class="alert-label">정말로 회원을 탈퇴하시겠습니까?</label>
                    <div>
                        <button class="btn-unregister" @click="unregisterY">예</button>
                        <button class="btn-unregister" @click="unregisterN">아니오</button>
                    </div>
                </div>
                <template v-if="unregisterFlg && userInfo.password.length > 20" >
                    <div class="center-box-row">
                        <label>비밀 번호 : </label>
                        <input type="password" v-model="confirmPassword" placeholder="비밀번호를 입력해주세요."
                            @keyup.enter="fnUserUnregister">
                        <button @click="fnUserUnregister">확인</button>
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
                        userInfo:{},
                        confirmPassword: '',
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionRole}",
                        currentPage: '',
                        unregisterFlg: false,
                    };
                },
                methods: {
                    fnUserUnregister() {
                        let self = this;
                        let nparmap = {
                            sessionId: self.sessionId,
                            confirmPassword: self.confirmPassword
                        };

                        $.ajax({
                            url: "/mypage/user-unregister.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log("Data : " + data);
                                    alert("탈퇴되었습니다.");
                                    location.href = "http://localhost:8080/main.do";         
                                } else if(data.result == "pwdCheckFail"){
                                    alert("비밀번호를 확인해주세요.");
                                } else {
                                    alert("회원탈퇴에 실패했습니다. 다시 시도해주세요.");
                                } 
                            },
                            error: function (error) {
                                console.error("AJAX 에러:", error);
                            }
                        });
                    },
                    unregisterY() {
                        this.unregisterFlg = true;
                    },
                    unregisterN() {
                        location.href = "/mypage/user-purchase-history.do";
                    },
                    fnGetInfo() {
                        let self = this;
                        let nparmap = {
                            sessionId: self.sessionId,
                            unregisterFlg: true
                        };
                        console.log(self.sessionId);
                        $.ajax({
                            url: "/mypage/user-info.dox",
                            dataType: "json",
                            type: "POST",
                            data: nparmap,
                            success: function (data) {
                                if (data.result == "success") {
                                    console.log(data);
                                    self.userInfo = data.userInfo;
                                    console.log(self.userInfo);
                                } else {
                                    alert("정보를 가지고 오는데 실패했습니다.");
                                }
                            }
                        });
                    },
                },
                mounted() {

                    if (this.sessionId === null) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "localhost:8080/main.do";
                    }
                    if (this.sessionRole != 'TOURIST') {
                        alert("일반회원만 이용가능합니다.");
                        location.href = "http://localhost:8080/main.do";
                    }

                    this.currentPage = window.location.pathname.split('/').pop();
                    console.log("Current page:", this.currentPage);

                    this.fnGetInfo();
                }

            });
            app.mount('#app');
        </script>
    </body>

    </html>