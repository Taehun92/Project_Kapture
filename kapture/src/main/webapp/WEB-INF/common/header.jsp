<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-Change.js"></script>
	<link rel="stylesheet" href="../../css/header.css">
    <script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
    <script src="https://unpkg.com/vue@3.2.47/dist/vue.global.prod.js"></script>
	<title>헤더</title>
</script>
</head>
<style>
</style>
<body>
	<div id="header">
        <div id="google_translate_element"></div>
        <header>
            <div>
                <!-- 로고 -->
                <a href="/main.do">
                    <img id="logo" src="#" >
                </a>

                <!-- 검색 바 -->
                <span class="search-bar">
                    <input v-model="keyword" type="text" placeholder="상품을 검색하세요...">
                    <button @click="fnSearch">검색</button>
                </span>

                <!-- 메뉴 -->
                <span>
                    <a href="#">상품검색</a>
                </span>
                <span>
                    <a href="#">요청게시판</a>
                </span>
            </div>

            <div>
                <span>
                    <!-- Google Translate Widget hidden element -->
                    <div id="google_translate_element" style="display:none;"></div>
                    <span id="translate-button"><a href="#">언어설정</a></span>
                    <!-- Language Selection Buttons -->
                    <ul class="translation-links">
                        <li><button @click="changeLanguage('ko')" class="korean" title="Korean"><span class="flag ko"></span> Korean</button></li>
                        <li><button @click="changeLanguage('en')" class="english" title="English"><span class="flag en"></span> English</button></li>
                        <li><button @click="changeLanguage('ja')" class="japanese" title="Japanese"><span class="flag ja"></span> Japanese</button></li>
                        <li><button @click="changeLanguage('zh-CN')" class="chinese" title="Chinese"><span class="flag zh-CN"></span> Chinese</button></li>
                    </ul>
                </span>
                <span>
                    <a href="#">FAQ</a>
                </span>
                <span>
                    <a href="#">고객센터</a>
                </span>
                <!-- 로그인 버튼 -->
                <span class="login-btn">
                    <template v-if="sessionId == ''">
                        <a href="login.do"> 
                            <button>Login</button> 
                        </a>
                    </template>
                    <template v-else>
                        <a href="#">
                            <button @click="fnLogout">Logout</button>
                        </a>
                    </template>
                </span>
            </div>
        </header>
    </div>
</body>
</html>
<script>
    const header = Vue.createApp({
        data() {
            return {
                keyword : "",
                sessionId : "${sessionId}",
                languages: [
                        { code: "ko", class: "ko", title: "Korean" },
                        { code: "en", class: "en", title: "English" },
                        { code: "ja", class: "ja", title: "日本語" },
                        { code: "zh-CN", class: "zh-CN", title: "中文(简体)" }
                    ]

            };
        },
        methods: {
            fnLogout(){
				var self = this;
				var nparmap = {
                };
				$.ajax({
					url:"logout.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						console.log(data);
                        if(data.result == "success"){
                            alert("로그아웃 되었습니다.");
                            location.href="/main.do";
                        }
					}
				});
            },
			
			fnSearch (){
                let self = this;
                app._component.methods.fnToursList(self.keyword);
            },

            initializeGoogleTranslate() {
                let self = this;
                new google.translate.TranslateElement(
                {
                    pageLanguage: "ko",
                    autoDisplay: true,
                },
                "google_translate_element"
                );
                // Wait for Google Translate to initialize and hide the dropdown
                setTimeout(() => {
                    self.hideGoogleTranslateDropdown();
                }, 10); // Wait a bit to ensure the element is loaded
            },

            // Change Language function for buttons
            changeLanguage(lang) {
                const gtcombo = document.querySelector('.goog-te-combo');
                if (gtcombo) {
                gtcombo.value = lang;
                gtcombo.dispatchEvent(new Event('change')); // Dispatch change event to trigger translation
                } else {
                console.error("Could not find Google Translate combolist.");
                }
            },

            // Function to hide the Google Translate dropdown (goog-te-combo)
            hideGoogleTranslateDropdown() {
                const gtCombo = document.querySelector('.goog-te-combo');
                if (gtCombo) {
                gtCombo.style.display = 'none'; // Hide the dropdown directly
                }
            },

            googleTranslateElementInit() {
            new google.translate.TranslateElement({ pageLanguage: "ko", autoDisplay: true }, "google_translate_element");
            new google.translate.TranslateElement({pageLanguage: 'ko' , includedLanguages : 'ko,en,jp,zh-CN'}, 'google_translate_element');
            }

        }, // method
        mounted() {
            var self = this;
            self.googleTranslateElementInit();
            // Initialize Google Translate only if not already initialized
            if (typeof google !== "undefined" && google.translate) {
                self.initializeGoogleTranslate();
            } else {
                window.googleTranslateElementInit = self.initializeGoogleTranslate;
            }
            
        }
    });
    header.mount('#header');
</script>