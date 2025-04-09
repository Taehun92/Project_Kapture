<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../../css/kapture-style.css">
    <link rel="stylesheet" href="../../css/chatbot.css">
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
    <link rel="icon" type="image/png" sizes="96x96" href="/img/logo/favicon-96x96.png" />
    <link rel="shortcut icon" href="/img/logo/favicon-96x96.png" />
    <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
    <title>사이드바</title>
</head>
<body class="bg-white text-gray-800 font-sans text-[16px] tracking-wide overflow-x-hidden">
    <div id="sidebar" class="sidebar">

        <div>
            <button class="open-weather-btn" v-if="!showWeather" @click="showWeather = true">날씨</button>
        </div>        
        <div>
            <button class="open-chat-btn" v-if="!showChat" @click="showChat = true">🤖챗봇 열기</button>
        </div>

        <div class="chatbot-overlay" v-if="showChat">
            <div class="chat-container">
                <div class="chat-header" >
                    K-apture 챗봇
                    <button class="close-btn" @click="showChat = false">✕</button>
                </div>
                <div class="chat-box" ref="chatBox">
                    <div v-for="msg in messages" :class="['message', msg.type]">
                        {{ msg.text }}
                    </div>
                </div>
                <div class="chat-input">
                    <textarea v-model="userInput" placeholder="메시지를 입력하세요..."></textarea>
                    <button @click="sendMessage">전송</button>
                </div>
            </div>
        </div>

        <div class="weather-overlay" v-if="showWeather">
            <div class="weather-container">
                <div class="weather-header bg-blue-950 text-white p-2 rounded-t-lg">
                    날씨 정보
                    <button class="close-btn" @click="showWeather = false">✕</button>
                </div>
                <div class="weather-box">
                    <div>
                        <div class="">
                            <div>
                                <label class="block font-semibold mb-1">시</label>
                                <select @change="fnSelectGu()" v-model="si" class="w-full border px-3 py-2 rounded">
                                    <option value="">:: 선택 ::</option>
                                    <template v-for="item in siList">
                                        <option :value="item.si">{{item.si}}</option>
                                    </template>
                                </select>
                            </div>
                            <div>
                                <label class="block font-semibold mb-1">구</label>
                                <select @change="fnSelectDong()" v-model="gu" class="w-full border px-3 py-2 rounded">
                                    <option value="">:: 선택 ::</option>
                                    <template v-for="item in guList">
                                        <option :value="item.gu">{{item.gu}}</option>
                                    </template>
                                </select>
                            </div>
                            <div>
                                <label class="block font-semibold mb-1">동</label>
                                <select @change="fnSetArea()" v-model="dong" class="w-full border px-3 py-2 rounded">
                                    <option value="">:: 선택 ::</option>
                                    <template v-for="item in dongList">
                                        <option :value="item.dong">{{item.dong}}</option>
                                    </template>
                                </select>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>
</body>
</html>

<script>
    const sidebar = Vue.createApp({
        data() {
            return {
                userInput: "",
                messages: [],
                showChat: false,
                showWeather : false,
                temp : "",
                cloud : "",
                si : "",
                siList : [],
                gu : "",
                guList : [],
                dong : "",
                dongList : [],
                nx : "",
                ny : "",

            };
        },

        methods: {
            sendMessage() {
                if (this.userInput.trim() === "") return;

                this.messages.push({ text: this.userInput, type: 'user' });
                const inputText = this.userInput;
                this.userInput = "";
                this.scrollToBottom();

                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: { input: inputText },
                    success: (response) => {
                        this.messages.push({ text: response, type: 'bot' });
                        this.scrollToBottom();
                    },
                    error: (xhr) => {
                        this.messages.push({ text: "오류 발생: " + xhr.responseText, type: 'bot' });
                        this.scrollToBottom();
                    }
                });
            },

            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    chatBox.scrollTop = chatBox.scrollHeight;
                });
            },

            //날씨 정보 가져오기
            fnWeather() {
                let self = this;
                 // 날씨 정보 표시
                let xhr = new XMLHttpRequest();
                let url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'; /*URL*/
                let queryParams = '?' + encodeURIComponent('serviceKey') + '='+'O5%2BkPtLkpnsqZVmVJiYW7JDeWEX4mC9Vx3mq4%2FGJs%2Fejvz1ceLY%2B0XySUsy15P%2BhpAdHcZHXHhdn4htsTUuvpA%3D%3D'; /*Service Key*/
                queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
                queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('1000'); /**/
                queryParams += '&' + encodeURIComponent('dataType') + '=' + encodeURIComponent('JSON'); /**/
                queryParams += '&' + encodeURIComponent('base_date') + '=' + encodeURIComponent('20250409'); /**/
                queryParams += '&' + encodeURIComponent('base_time') + '=' + encodeURIComponent('0500'); /**/
                queryParams += '&' + encodeURIComponent('nx') + '=' + encodeURIComponent(self.nx); /**/
                queryParams += '&' + encodeURIComponent('ny') + '=' + encodeURIComponent(self.ny); /**/
                xhr.open('GET', url + queryParams);
                xhr.onreadystatechange = function () {
                    if (this.readyState == 4) {
                        console.log('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
                    }
                };

                xhr.send('');
                xhr.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        const response = JSON.parse(this.responseText);
                        const items = response.response.body.items.item; // ✅ 여기에 item 리스트 있음
                
                        console.log("날씨 항목 리스트:", items);
                        
                        // 예: 기온(TMP)만 필터링해서 출력
                        const temperatureList = items.filter(i => i.category === 'TMP' || i.category === 'SKY' || i.category === 'PTY');
                        console.log("기온, 구름 정보만:", temperatureList);
                    }
                };
            },

            fnSelectSi() {
                let self = this;
                let nparmap = {

                }
                $.ajax({
                    url: "/common/selectSi.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        self.siList = data.si;
                    },
                });

            },

            fnSelectGu() {
                let self = this;
                let nparmap = {
                    si: self.si
                }
                $.ajax({
                    url: "/common/selectGu.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        self.guList = data.gu;
                    },
                });

            },

            fnSelectDong() {
                let self = this;
                let nparmap = {
                    si: self.si,
                    gu: self.gu
                }
                $.ajax({
                    url: "/common/selectDong.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function (data) {
                        console.log(data);
                        self.dongList = data.dong;
                    },
                });

            },

            fnSetArea() {
                let self = this;
                let nparmap = {
                    si : self.si,
                    dong : self.dong
                }
                $.ajax({
                    url: "/common/selectXY.dox",
                    type: "POST",
                    dataType: "json",
                    data: nparmap,
                    success: function (data) {
                        self.nx = data.xy.nx;
                        self.ny = data.xy.ny;
                        self.fnWeather(); // 날씨 정보 가져오기
                    },
                });
            }
            

        },

        mounted() {
            let self = this;
            self.fnSelectSi(); // 페이지 로드 시 시도 목록 가져오기
        },
    });
    sidebar.mount("#sidebar");
</script>