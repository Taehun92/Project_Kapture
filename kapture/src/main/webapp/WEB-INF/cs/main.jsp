<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <title>고객센터 메인</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Arial', sans-serif;
                background: #f9f9fb;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            #app {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .hero-section {
                text-align: center;
                padding: 60px 20px 30px;
            }

            .hero-section h1 {
                font-size: 36px;
                margin-bottom: 30px;
                font-weight: bold;
            }

            .search-box input {
                width: 600px;
                padding: 20px 25px;
                border-radius: 35px;
                border: 1px solid #ccc;
                font-size: 18px;
            }

            .card-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                gap: 40px;
                max-width: 1400px;
                margin: 40px auto;
                padding: 0 40px;
            }

            .card-button {
                background: white;
                border-radius: 20px;
                padding: 50px 30px;
                text-align: center;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                cursor: pointer;
                transition: 0.3s ease;
            }

            .card-button:hover {
                background-color: #f1f5ff;
                transform: translateY(-8px);
            }

            .card-button img {
                width: 72px;
                margin-bottom: 20px;
            }

            .card-button .title {
                font-size: 22px;
                font-weight: bold;
                color: #222;
            }

            .card-button .subtitle {
                margin-top: 10px;
                font-size: 18px;
                color: #666;
            }

            .latest-faq {
                max-width: 1400px;
                margin: 60px auto 100px;
                padding: 0 40px;
            }

            .latest-faq h2 {
                font-size: 22px;
                font-weight: bold;
                margin-bottom: 25px;
            }

            .faq-preview-item {
                background: white;
                border-radius: 12px;
                padding: 18px 24px;
                margin-bottom: 12px;
                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
                cursor: pointer;
                transition: 0.2s ease;
                font-size: 16px;
            }

            .faq-preview-item:hover {
                background-color: #f1f1f1;
            }

            footer {
                background-color: #003366;
                color: white;
                text-align: center;
                padding: 25px;
                margin-top: auto;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/header.jsp" />
          
        <div id="app">
            <!-- Hero 검색 -->
            <div class="hero-section">
                <h1>무엇을 도와드릴까요?</h1>
                <div class="search-box">
                    <input v-model="searchKeyword" @keyup.enter="search" placeholder="궁금한 내용을 검색해보세요" />
                </div>
            </div>

            <!-- 카드형 버튼 -->
            <div class="card-grid">
                <div class="card-button" @click="goTo('faq')">
                    <img src="../../img/faq.png" alt="FAQ" />
                    <div class="title">FAQ</div>
                    <div class="subtitle">자주 묻는 질문</div>
                </div>
                <div class="card-button" @click="goTo('notice')">
                    <img src="../../img/notice.png" alt="공지사항" />
                    <div class="title">공지사항</div>
                    <div class="subtitle">이벤트 및 안내</div>
                </div>
                <div class="card-button" @click="goToQna">
                    <img src="../../img/qna.png" alt="Q&A" />
                    <div class="title">Q&A</div>
                    <div class="subtitle">문의 답변 확인</div>
                </div>
            </div>

            <!-- 최신 FAQ 3개 미리보기 -->
            <div class="latest-faq" v-if="faqList.length > 0">
                <h2>최신 자주 묻는 질문</h2>
                <div class="faq-preview-item" v-for="item in faqList" :key="item.faq_no" @click="goToFaqDetail(item)">
                    {{ item.question }}
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        searchKeyword: "",
                        faqList: [],
                        sessionId: "${sessionId}"
                    };
                },
                methods: {
                    search() {
                        if (this.searchKeyword.trim() !== "") {
                            const query = encodeURIComponent(this.searchKeyword);
                            window.location.href = `/cs/faq.do?keyword=${query}`;
                        }
                    },
                    goTo(menu) {
                        const base = "/cs/";
                        if (menu === 'faq') window.location.href = base + "faq.do";
                        if (menu === 'notice') window.location.href = base + "notice.do";
                    },
                    goToQna() {
                        let self = this;
                        let nparmap = {
                            sessionId :self.sessionId
                        };

                        if(!self.sessionId) {
                            alert("로그인필요");
                            window.location.href = "/login.do"
                            return;
                        }
                        
                                location.href="/cs/qna.do"
                                

                    },
                   
                    goToFaqDetail(item) {
                        const query = encodeURIComponent(item.question);
                        window.location.href = `/cs/faq.do?keyword=${query}`;
                    }
                },
                mounted() {
                  
                }
            });
            app.mount("#app");
        </script>
    </body>

    </html>