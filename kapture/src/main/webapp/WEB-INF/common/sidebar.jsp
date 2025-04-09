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
    <div id="sidebar" class="pb-12">

        <button class="open-chat-btn" v-if="!showChat" @click="showChat = true">챗봇 열기</button>
        
        <div class="modal-overlay" v-if="showChat">
            <div class="chat-container">
                <div class="chat-header">
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
            }
        },

        mounted() {
            
        },
    });
    sidebar.mount("#sidebar");
</script>