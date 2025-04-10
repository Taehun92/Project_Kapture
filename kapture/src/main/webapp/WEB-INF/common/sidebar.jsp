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
                    <textarea v-model="userInput" placeholder="메시지를 입력하세요..." @keyUp.enter="sendMessage"></textarea>
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
                            <div v-if="weatherForecastDaily.length">
                                
                                <table class="table-auto border-collapse border border-gray-300 text-center text-xs">
                                    <thead class="bg-gray-100">
                                        <tr>
                                            <th class="border p-1">날짜</th>
                                            <th class="border p-1">기온</th>
                                            <th class="border p-1">하늘</th>
                                            <th class="border p-1">강수</th>
                                            <th class="border p-1">최저</th>
                                            <th class="border p-1">최고</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(day, index) in weatherForecastDaily" :key="index">
                                            <td class="border p-1">{{ day.date.slice(0,4) }}-{{ day.date.slice(4,6) }}-{{ day.date.slice(6,8) }}</td>
                                            <td class="border p-1">{{ day.tmp }}</td>
                                            <td class="border p-1">{{ day.sky }}</td>
                                            <td class="border p-1">{{ day.pty }}</td>
                                            <td class="border p-1">{{ day.tmn }}</td>
                                            <td class="border p-1">{{ day.tmx }}</td>
                                        </tr>
                                    </tbody>
                                </table>
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
                weatherInfo: {
                    tmp: '',
                    sky: '',
                    pty: '',
                    tmn: '',
                    tmx: ''
                },
                weatherForecast: [],
                weatherForecastDaily: []

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
                const today = new Date();
                const year = today.getFullYear();
                const month = String(today.getMonth() + 1).padStart(2, '0');
                const day = String(today.getDate()).padStart(2, '0');
                const baseDate = year + month + day;
                 // 날씨 정보 표시
                let xhr = new XMLHttpRequest();
                let url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'; /*URL*/
                let queryParams = '?' + encodeURIComponent('serviceKey') + '='+'O5%2BkPtLkpnsqZVmVJiYW7JDeWEX4mC9Vx3mq4%2FGJs%2Fejvz1ceLY%2B0XySUsy15P%2BhpAdHcZHXHhdn4htsTUuvpA%3D%3D'; /*Service Key*/
                queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
                queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('1000'); /**/
                queryParams += '&' + encodeURIComponent('dataType') + '=' + encodeURIComponent('JSON'); /**/
                queryParams += '&' + encodeURIComponent('base_date') + '=' + encodeURIComponent(baseDate); /**/
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
                        const hours = String(today.getHours()).padStart(2, '0');
                        const minutes = today.getMinutes();

                        // 30분 이전이면 한 시간 전 값 사용 (예보 데이터는 보통 매시마다 업데이트되니까)
                        const forecastHour = minutes < 30 ? String(today.getHours() - 1).padStart(2, '0') : hours;

                        // 현재 시각에 맞는 예보 시간
                        const currentFcstTime = forecastHour + "00";

                        const filteredItems = items.filter(item => item.fcstTime === currentFcstTime);
                        console.log("현재 시간에 해당하는 항목:", filteredItems);

                        const TMPList = filteredItems.filter(i => i.category === 'TMP');
                        console.log("기온 정보만:", TMPList);

                        const SKYList = filteredItems.filter(i => i.category === 'SKY');
                        console.log("하늘 상태:", SKYList);

                        const PTYList = filteredItems.filter(i => i.category === 'PTY');
                        console.log("강수형태:", PTYList);

                        const tmnList = items.filter(i => i.category === 'TMN');
                        console.log("최저 정보만:", tmnList);

                        const tmxList = items.filter(i => i.category === 'TMX');
                        console.log("최대 정보만:", tmxList);

                        const TMP = filteredItems.find(i => i.category === 'TMP')?.fcstValue || '-';
                        const SKY = filteredItems.find(i => i.category === 'SKY')?.fcstValue || '-';
                        const PTY = filteredItems.find(i => i.category === 'PTY')?.fcstValue || '-';
                        const TMN = items.find(i => i.category === 'TMN')?.fcstValue || '-';
                        const TMX = items.find(i => i.category === 'TMX')?.fcstValue || '-';

                        self.weatherInfo = {
                            tmp: TMP + "°C",
                            sky: self.mapSky(SKY),
                            pty: self.mapPty(PTY),
                            tmn: TMN + "°C",
                            tmx: TMX + "°C"
                        };
                        const forecastList = items.filter(i => i.category === 'TMP' && i.fcstTime === '1100').slice(0, 3);

                        self.weatherForecast = forecastList.map(i => ({
                            fcstDate: i.fcstDate,
                            fcstTime: i.fcstTime,
                            fcstValue: i.fcstValue
                        }));

                        const groupByDate = {};
                        items.forEach(i => {
                            if (!groupByDate[i.fcstDate]) {
                                groupByDate[i.fcstDate] = [];
                            }
                        groupByDate[i.fcstDate].push(i);
                        });

                        // 3일치만 뽑아서 정보 구성
                        const dailyForecast = Object.keys(groupByDate).sort().slice(0, 3).map(date => {
                            const dayItems = groupByDate[date];
                            const TMP = dayItems.find(i => i.category === 'TMP' && i.fcstTime === '1100')?.fcstValue || '-';
                            const SKY = dayItems.find(i => i.category === 'SKY' && i.fcstTime === '1100')?.fcstValue || '-';
                            const PTY = dayItems.find(i => i.category === 'PTY' && i.fcstTime === '1100')?.fcstValue || '-';
                            const TMN = dayItems.find(i => i.category === 'TMN')?.fcstValue || '-';
                            const TMX = dayItems.find(i => i.category === 'TMX')?.fcstValue || '-';

                            return {
                                date: date,
                                tmp: TMP + "°C",
                                sky: self.mapSky(SKY),
                                pty: self.mapPty(PTY),
                                tmn: TMN + "°C",
                                tmx: TMX + "°C"
                            };
                        });

                        self.weatherForecastDaily = dailyForecast;
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
                    gu : self.gu,
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
            },

            mapSky(code) {
                const skyValue = parseInt(code);
                if (skyValue >= 0 && skyValue <= 5) {
                    return '☀️ 맑음';
                } else if (skyValue >= 6 && skyValue <= 8) {
                    return '⛅ 구름 많음';
                } else if (skyValue >= 9 && skyValue <= 10) {
                    return '☁️ 흐림';
                } else {
                    return '알 수 없음';
                }
            },
            mapPty(code) {
                switch(code) {
                    case '0': return '🌈 없음';
                    case '1': return '🌧️ 비';
                    case '2': return '🌨️ 비/눈';
                    case '3': return '❄️ 눈';
                    case '4': return '🌫️ 소나기';
                    default: return '알 수 없음';
                }
            }
            

        },

        mounted() {
            let self = this;
            self.fnSelectSi(); // 페이지 로드 시 시도 목록 가져오기
        },
    });
    sidebar.mount("#sidebar");
</script>