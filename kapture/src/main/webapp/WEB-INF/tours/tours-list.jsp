<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" sizes="96x96" href="/img/logo/favicon-96x96.png" />
        <link rel="shortcut icon" href="/img/logo/favicon-96x96.png" />
        <title>관광지 목록 | kapture</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://unpkg.com/@vuepic/vue-datepicker@latest"></script>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="../../css/kapture-style.css">
        <link rel="stylesheet" href="https://unpkg.com/@vuepic/vue-datepicker/dist/main.css">
        <link rel="stylesheet" href="../../css/chatbot.css">
        <style>
            .slide-modal-enter-active,
            .slide-modal-leave-active {
                transition: transform 0.4s ease, opacity 0.4s ease;
            }

            .slide-modal-enter-from,
            .slide-modal-leave-to {
                transform: translateY(100%);
                opacity: 0;
            }

            .slide-modal-enter-to,
            .slide-modal-leave-from {
                transform: translateY(0%);
                opacity: 1;
            }
        </style>
    </head>
    <body class="bg-white text-gray-800">
        <jsp:include page="../common/header.jsp" />
        <div id="app" class="max-w-7xl mx-auto py-8 px-4">
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
            
            <!-- 지역별 배너 -->
            <div class="relative h-64 rounded-lg overflow-hidden mb-6 bg-cover bg-center"
                :style="{ backgroundImage: 'url(' + (hoveredRegionImage || defaultHeaderImage) + ')' }">
                <div class="absolute inset-0 bg-black bg-opacity-50 flex flex-col justify-center items-center px-4">
                    <h1 class="text-white text-3xl font-bold mb-4">주요 관광지</h1>
                    <div class="flex flex-wrap gap-2 justify-center">
                        <button v-for="region in regions" :key="region.region"
                            @mouseover="hoveredRegionImage = region.image"
                            @mouseleave="hoveredRegionImage = null" @click="fnRegionalTours(region.siNo)"
                            class="px-4 py-2 bg-blue-700 text-white hover:bg-blue-950 rounded text-sm font-semibold">
                            {{ region.region }}
                        </button>
                    </div>
                </div>
            </div>

            <div class="flex gap-8">
                <!-- 필터 사이드바 -->
                <aside class="w-64 space-y-4">
                    <!-- 날짜 필터 -->
                    <div class="bg-gray-50 border rounded p-4">
                        <button class="font-semibold mb-2" @click="toggleFilter('date')">
                            여행기간 {{ filters.date ? '∧' : '∨' }}
                        </button>
                        <div v-if="filters.date">
                            <div v-if="Array.isArray(selectedDates) && selectedDates.length > 0 && !showDatePicker">
                                <p class="text-sm mb-2">선택한 날짜: {{ formatDateRange(selectedDates) }}</p>
                                <button @click="resetDatePicker" class="text-blue-700 text-sm">📅 다시 선택</button>
                            </div>
                            <div v-else>
                                <vue-date-picker v-model="selectedDates" multi-calendars model-auto range
                                    :min-date="new Date()" locale="ko" @update:model-value="handleDateInput" />
                            </div>
                        </div>
                    </div>

                    <!-- 언어 필터 -->
                    <div class="bg-gray-50 border rounded p-4">
                        <button class="font-semibold mb-2" @click="toggleFilter('language')">가이드 언어 {{ filters.language
                            ?
                            '∧' : '∨' }}</button>
                        <div v-if="filters.language">
                            <div v-for="language in languages" :key="language.eng">
                                <label class="text-sm">
                                    <input type="checkbox" v-model="selectedLanguages" :value="language.eng"
                                        @change="fnToursList" class="mr-1">
                                    {{ language.kor }}
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- 지역 필터 -->
                    <div class="bg-gray-50 border rounded p-4">
                        <button class="font-semibold mb-2" @click="toggleFilter('region')">지역별 {{ filters.region ? '∧' :
                            '∨'
                            }}</button>
                        <div v-if="filters.region">
                            <div v-for="item in regionList" :key="item.siNo">
                                <label class="text-sm">
                                    <input type="checkbox" v-model="selectedRegions" :value="item.siNo"
                                        @change="fnToursList" class="mr-1">
                                    {{ item.siName }}
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- 테마 필터 -->
                    <div class="bg-gray-50 border rounded p-4">
                        <button class="font-semibold mb-2" @click="toggleFilter('theme')">테마별 {{ filters.theme ? '∧' :
                            '∨'
                            }}</button>
                        <div v-if="filters.theme">
                            <div v-for="theme in themeList" :key="theme.themeNo">
                                <label class="text-sm">
                                    <input type="checkbox" v-model="selectedThemes" :value="theme.themeNo"
                                        @change="fnToursList" class="mr-1">
                                    {{ theme.themeName }}
                                </label>
                            </div>
                        </div>
                    </div>


                    <div class="mt-32">
                        <button
                            class="w-full py-2 px-4 bg-blue-950 text-white rounded hover:bg-blue-700 transition-colors font-semibold shadow ">
                            🏨 숙소 찾기
                        </button>
                    </div>


                </aside>

                <!-- 본문 영역 -->
                <main class="flex-1 min-w-0">
                    <div class="flex justify-between items-center mb-4">
                        <!-- 왼쪽: 현재 위치 -->
                        <div class="text-sm text-gray-500">홈 > 상품</div>
                    
                        <!-- 오른쪽: 버튼 -->
                        <button
                            class="text-sm bg-blue-950 text-white px-4 py-2 rounded hover:bg-blue-700 transition-colors shadow-sm" @click="fnFindLocation">
                            🇰🇷 관광지 알아보기
                        </button>
                    </div>
                    <hr class="mb-4">
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div v-for="tour in toursList" :key="tour.tourNo"
                            class="border rounded-lg overflow-hidden shadow hover:shadow-md transition mb-5">
                            <img :src="tour.filePath" alt="썸네일" class="w-full h-48 object-cover">
                            <div class="p-4">
                                <div class="flex justify-between items-center mb-2">
                                    <span class="text-xs text-gray-500 font-bold">{{ formatDate(tour.tourDate) }}</span>
                                    <span class="text-sm text-blue-600"> # {{ tour.themeName }}</span>
                                    <img :src="tour.isFavorite === 'Y' ? '../../svg/taeguk-full.svg' : '../../svg/taeguk-outline.svg'"
                                        alt="찜 아이콘" class="w-8 h-8 cursor-pointer" @click="toggleFavorite(tour)" />
                                </div>
                                <div class="text-lg font-semibold mb-1 truncate">{{ tour.title }}</div>
                                <div class="text-sm text-gray-600 h-12 overflow-hidden">{{ truncateText(tour.description) }}</div>
                                <div class="flex justify-between items-center mt-3">
                                    <span class="text-yellow-500 text-sm">⭐ {{ tour.rating }}</span>
                                    <span class="font-bold text-gray-800"> ₩ {{ tour.price.toLocaleString() }}</span>
                                </div>
                                <button @click="goToTourInfo(tour.tourNo)"
                                    class="mt-3 w-full text-white py-2 rounded shadow text-center transition-colors bg-blue-950 hover:bg-blue-700">
                                    예약하기
                                </button>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

            <!-- 장바구니 트리거 바 -->
            <div class="fixed bottom-0 left-1/2 transform -translate-x-1/2 w-44 text-white text-center py-2 rounded-t-lg cursor-pointer z-50 bg-blue-950 hover:bg-blue-700 transition-colors" @click="showModal = true">
                <div class="text-sm flex items-center justify-center gap-2 w-32 mx-auto font-bold">
                    🛒 장바구니 열기
                </div>
            </div>

            <div class="fixed inset-0 z-50 flex items-end justify-center"
                :class="showModal ? 'bg-black bg-opacity-50 pointer-events-auto' : 'bg-transparent pointer-events-none'"
                @click.self="handleCartClose">

                <!-- ✅ 모달 본체 (슬라이드 업) -->
                <transition name="slide-modal">
                    <div v-if="showModal" class="bg-white w-full max-w-4xl mx-auto rounded-t-2xl" @click.stop>

                        <!-- ✅ 내부 컨텐츠 -->
                        <div class="p-6 max-h-[90vh] overflow-y-auto">

                            <!-- 고정된 상단 -->
                            <div
                                class="sticky top-0 bg-white z-50 flex justify-between items-center mb-4 border-b pb-2 px-4 pt-4">
                                <h2 class="text-lg font-bold">🗓️ 일정 확인</h2>
                                <button class="text-sm text-red-500 hover:underline"
                                    @click="handleCartClose">닫기</button>
                            </div>

                            <div class="overflow-x-auto">
                                <!-- text-center, align-middle 추가 -->
                                <table class="w-full text-center align-middle">
                                    <thead class="bg-blue-950 text-white">
                                        <tr>
                                            <th class="border-2 border-gray-400 w-40 
                                           h-[1rem] box-border px-4 py-2 text-base 
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                날짜
                                            </th>
                                            <th class="border-2 border-gray-400 w-30
                                           h-[1rem] box-border px-4 py-2 text-base
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                시간
                                            </th>
                                            <th class="border-2 border-gray-400
                                           h-[1rem] box-border px-4 py-2 text-base
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                상품 제목
                                            </th>
                                            <th class="border-2 border-gray-400 w-30
                                           h-[1rem] box-border px-4 py-2 text-base
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                인원 수
                                            </th>
                                            <th class="border-2 border-gray-400
                                           h-[1rem] box-border px-4 py-2 text-base
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                금액
                                            </th>
                                            <th class="border-2 border-gray-400 w-20
                                           h-[1rem] box-border px-4 py-2 text-base
                                           overflow-hidden whitespace-nowrap text-ellipsis">
                                                삭제
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <!-- 예시: 7일 반복 -->
                                        <template v-for="n in 7" :key="'day-' + n">
                                            <!-- (1) 종일 예약 -->
                                            <template v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')">
                                                <tr>
                                                    <!-- 날짜 -->
                                                    <td class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle font-bold">
                                                        {{ formatDate(addDays(minDate, n - 1)) }}
                                                    </td>
                                                    <!-- 시간 -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        종일
                                                    </td>
                                                    <!-- 상품 제목 -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                        '종일')?.title ||
                                                        ''
                                                        }}
                                                    </td>
                                                    <!-- 인원 수 -->
                                                    <td
                                                        class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <div v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')"
                                                            class="flex items-center justify-center gap-2">
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), -1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')?.numPeople || 0) <= 1">
                                                                -
                                                            </button>
                                                            <span>
                                                                {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                                '종일')?.numPeople || 0 }}명
                                                            </span>
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'), 1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일')?.numPeople || 0) >= 4">
                                                                +
                                                            </button>
                                                        </div>
                                                    </td>
                                                    <!-- 금액 -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        ₩ {{
                                                        (
                                                        Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                        '종일')?.price ||
                                                        0) *
                                                        Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                        '종일')?.numPeople || 0)
                                                        ).toLocaleString()
                                                        }}
                                                    </td>
                                                    <!-- 삭제 -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <button
                                                            class="border border-gray-300 rounded text-red-500 hover:underline px-2 py-1"
                                                            @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '종일'))">
                                                            🗑️
                                                        </button>
                                                    </td>
                                                </tr>
                                            </template>

                                            <!-- (2) 오전/오후 예약 -->
                                            <template v-else>
                                                <!-- 오전 행 -->
                                                <tr>
                                                    <!-- 날짜 (rowspan=2) -->
                                                    <td class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle font-bold" rowspan="2">
                                                        {{ formatDate(addDays(minDate, n - 1)) }}
                                                    </td>
                                                    <!-- 시간(오전) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        오전
                                                    </td>
                                                    <!-- 상품 제목(오전) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                        '오전')?.title ||
                                                        ''
                                                        }}
                                                    </td>
                                                    <!-- 인원 수(오전) -->
                                                    <td
                                                        class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <div v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')"
                                                            class="flex items-center justify-center gap-2">
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), -1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')?.numPeople || 0) <= 1">
                                                                -
                                                            </button>
                                                            <span>
                                                                {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                                '오전')?.numPeople || 0 }}명
                                                            </span>
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'), 1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')?.numPeople || 0) >= 4">
                                                                +
                                                            </button>
                                                        </div>
                                                    </td>
                                                    <!-- 금액(오전) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <template
                                                            v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')">
                                                            ₩ {{
                                                            (
                                                            Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                            '오전')?.price || 0) *
                                                            Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                            '오전')?.numPeople || 0)
                                                            ).toLocaleString()
                                                            }}
                                                        </template>
                                                    </td>
                                                    <!-- 삭제(오전) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <button
                                                            v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오전')"
                                                            class="border border-gray-300 rounded text-red-500 hover:underline px-2 py-1"
                                                            @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오전'))">
                                                            🗑️
                                                        </button>
                                                    </td>
                                                </tr>
                                                <!-- 오후 행 -->
                                                <tr>
                                                    <!-- 시간(오후) -->
                                                    <td class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        오후
                                                    </td>
                                                    <!-- 상품 제목(오후) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                        '오후')?.title ||
                                                        ''
                                                        }}
                                                    </td>
                                                    <!-- 인원 수(오후) -->
                                                    <td
                                                        class="border border-gray-500 h-[1rem] box-border px-4 py-2 text-base overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <div v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')"
                                                            class="flex items-center justify-center gap-2">
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), -1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')?.numPeople || 0) <= 1">
                                                                -
                                                            </button>
                                                            <span>
                                                                {{ getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                                '오후')?.numPeople || 0 }}명
                                                            </span>
                                                            <button class="px-2 py-1 bg-blue-950 text-white rounded"
                                                                @click="changePeople(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'), 1)"
                                                                :disabled="(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')?.numPeople || 0) >= 4">
                                                                +
                                                            </button>
                                                        </div>
                                                    </td>
                                                    <!-- 금액(오후) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <template
                                                            v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')">
                                                            ₩ {{
                                                            (
                                                            Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                            '오후')?.price || 0) *
                                                            Number(getCartItemByDateAndTime(addDays(minDate, n - 1),
                                                            '오후')?.numPeople || 0)
                                                            ).toLocaleString()
                                                            }}
                                                        </template>
                                                    </td>
                                                    <!-- 삭제(오후) -->
                                                    <td class="border border-gray-500
                                               h-[1rem] box-border px-4 py-2 text-base
                                               overflow-hidden whitespace-nowrap text-ellipsis align-middle">
                                                        <button
                                                            v-if="getCartItemByDateAndTime(addDays(minDate, n - 1), '오후')"
                                                            class="border border-gray-300 rounded text-red-500 hover:underline px-2 py-1"
                                                            @click="deleteFromCart(getCartItemByDateAndTime(addDays(minDate, n - 1), '오후'))">
                                                            🗑️
                                                        </button>
                                                    </td>
                                                </tr>
                                            </template>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mt-3 text-right text-lg font-semibold text-gray-700 h-47">
                                💰 최종 금액: <span class="text-green-600">{{ getTotalPrice().toLocaleString() }}</span> 원
                            </div>
                            <div class="flex justify-end mt-2">
                                <button @click="fnPay"
                                    class="w-48 text-sm text-white px-4 py-2 rounded shadow text-center bg-blue-950 hover:bg-blue-700 transition-colors">
                                    결제하기
                                </button>
                            </div>
                        </div>
                    </div>
                </transition>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </body>

    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {

                    regions: [{
                        region: "서울", siNo: 11, image: "../../img/region/서울.jpg"
                    }, {
                        region: "제주", siNo: 39, image: "../../img/region/제주.jpg"
                    }, {
                        region: "부산", siNo: 21, image: "../../img/region/부산.jpg"
                    }, {
                        region: "전주", siNo: 35, image: "../../img/region/전주.jpg"
                    }, {
                        region: "강원", siNo: 32, image: "../../img/region/속초.jpg"
                    }, {
                        region: "인천", siNo: 23, image: "../../img/region/월미도.jpg"
                    }, {
                        region: "경기", siNo: 31, image: "../../img/region/용인.jpg"
                    }, {
                        region: "그 외", siNo: 999, image: "../../img/region/대천.jpg"
                    }],
                    languages: [{ eng: "Korean", kor: "한국어" }, { eng: "English", kor: "영어" }, { eng: "Chinese", kor: "중국어" }, { eng: "Japanese", kor: "일본어" }],
                    filters: {
                        date: false,
                        language: false,
                        region: false,
                        theme: false
                    },
                    toursList: [],
                    regionList: [],
                    themeList: [],
                    selectedDates: [],
                    selectedRegions: [],
                    selectedLanguages: [],
                    selectedThemes: [],

                    keyword: "${keyword}",

                    sessionId: "${sessionId}",
                    showModal: false,
                    date: new Date(),
                    showCartButton: false,
                    tourDate: null,
                    dateList: [],
                    maxDate: null,

                    cartList: [],
                    modalAnimationClass: '',
                    minDate: new Date(),

                    defaultHeaderImage: "../../img/region/default.jpg",
                    hoveredRegionImage: null,

                    showDatePicker: true,

                    userInput: "",
                    messages: [],
                    showChat: false,

                };
            },
            components: {
                VueDatePicker
            },
            watch: {
                showModal(newVal) {
                    if (newVal) {
                        this.modalAnimationClass = 'modal-slide-up';
                        document.body.classList.add('overflow-hidden');
                    } else {
                        this.modalAnimationClass = 'modal-slide-down';
                        document.body.classList.remove('overflow-hidden');
                    }
                }
            },
            methods: {
                resetDatePicker() {
                    this.selectedDates = [];
                    this.showDatePicker = true;
                },
                handleDateInput(dates) {
                    this.selectedDates = dates;
                    this.showDatePicker = false;
                    this.fnToursList();
                },
                formatDateRange(dates) {
                    if (!dates || dates.length === 0) return '선택 안 됨';
                    if (dates.length === 1) return this.formatDate(dates[0]);
                    return this.formatDate(dates[0]) + ' ~ ' + this.formatDate(dates[1]);
                },

                formatDate(date) {
                    if (!date) return '';

                    // 문자열이면 Date 객체로 변환
                    if (!(date instanceof Date)) {
                        date = new Date(date);
                    }

                    // 변환 실패 시 빈 문자열 반환
                    if (isNaN(date.getTime())) return '';

                    const year = date.getFullYear();
                    const month = (date.getMonth() + 1).toString().padStart(2, '0');
                    const day = date.getDate().toString().padStart(2, '0');
                    return year + '-' + month + '-' + day;
                },

                truncateText(text, maxLength = 30) {
                    if (!text) return '';
                    return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
                },

                addDays(date, days) {
                    const newDate = new Date(date);
                    newDate.setDate(newDate.getDate() + days);
                    return newDate;
                },
                toggleFilter(type) {
                    this.filters[type] = !this.filters[type];
                },
                fnToursList() {
                    const self = this;
                    const nparmap = {
                        selectedDates: JSON.stringify(self.selectedDates),
                        selectedRegions: JSON.stringify(self.selectedRegions),
                        selectedLanguages: JSON.stringify(self.selectedLanguages),
                        selectedThemes: JSON.stringify(self.selectedThemes),
                    };

                    $.ajax({
                        url: "/tours/list.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            self.toursList = data.toursList;
                            self.regionList = data.regionList;
                            self.themeList = data.themeList;
                            console.log(self.toursList);
                        }
                    });
                },
                goToTourInfo(tourNo) {
                    location.href = "/tours/tour-info.do?tourNo=" + tourNo;
                },
                fnRegionalTours(siNo) {
                    location.href = "/tours/regionalTours.do?siNo=" + siNo;

                },
                fnGetMinTourDate() {
                    const self = this;
                    $.post("/basket/getMinTourDate.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.minDate) {
                            const parts = data.minDate.split(' ');
                            const month = parseInt(parts[0].replace('월', '')) - 1;
                            const day = parseInt(parts[1].replace(',', ''));
                            const year = parseInt(parts[2]);
                            self.minDate = new Date(year, month, day);
                        }
                    }, "json");
                },
                fnGetMaxTourDate() {
                    const self = this;
                    $.post("/basket/getMaxTourDate.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.maxDate) {
                            const parts = data.maxDate.split(' ');
                            const month = parseInt(parts[0].replace('월', '')) - 1;
                            const day = parseInt(parts[1].replace(',', ''));
                            const year = parseInt(parts[2]);
                            self.maxDate = new Date(year, month, day);
                        }
                    }, "json");
                },
                fnGetTourDateList() {
                    const self = this;
                    $.post("/basket/getTourDateList.dox", {
                        tourNo: self.tourNo,
                        sessionId: self.sessionId
                    }, function (data) {
                        self.dateList = data.dateList;
                    }, "json");
                },
                fnGetBasket() {
                    const self = this;
                    $.post("/basket/getCount.dox", {
                        sessionId: self.sessionId
                    }, function (data) {
                        if (data.count > 0) {
                            self.showCartButton = true;
                        }
                    }, "json");
                },
                fnGetBasketList() {
                    let self = this;
                    let nparmap = {
                        sessionId: self.sessionId,
                    };

                    $.ajax({
                        url: "/basket/getBasketList.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            self.cartList = data.basketList;

                        }
                    });
                },
                getCartItemByDateAndTime(date, time) {
                    const formattedDate = this.formatDate(date);
                    return this.cartList.find(item =>
                        this.formatDate(new Date(item.tourDate)) === formattedDate &&
                        item.duration === time
                    ) || null;
                },
                changePeople(item, diff) {
                    const self = this;
                    const index = self.cartList.findIndex(i => i.basketNo === item.basketNo);

                    if (index !== -1) {
                        // 반드시 숫자로 변환해서 연산
                        const current = Number(self.cartList[index].numPeople);
                        const newCount = current + diff;
                        self.cartList[index].numPeople = newCount < 1 ? 1 : newCount;
                    }
                },
                getTotalPrice() {
                    return this.cartList.reduce((total, item) => total + Number(item.price) * Number(item.numPeople), 0);
                },
                deleteFromCart(item) {
                    const self = this;
                    if (!item || !item.basketNo) return;
                    if (confirm("이 항목을 장바구니에서 삭제할까요?")) {
                        $.ajax({
                            url: "/payment/removeBasket.dox",
                            type: "POST",
                            data: { basketNo: item.basketNo },
                            dataType: "json",
                            success: function (data) {
                                if (data.result === "success") {
                                    alert("삭제되었습니다.");
                                    localStorage.setItem("basketChanged", Date.now());
                                    self.fnGetBasketList();  // 장바구니 목록 갱신
                                    self.fnGetBasket();      // 아이콘 등 상태 갱신
                                    self.fnGetMinTourDate(); // 날짜 갱신
                                    self.fnGetMaxTourDate();
                                    location.reload();
                                }
                            }
                        });
                    }
                },

                handleCartClose() {
                    let self = this;
                    self.showModal = false;

                    // 모든 장바구니 항목 업데이트
                    let updatedCartList = self.cartList.map(item => ({
                        basketNo: item.basketNo,
                        count: item.numPeople
                    }));
                    $.ajax({
                        url: "/basket/updateList.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ cartList: updatedCartList }),
                        success: function (data) {
                            console.log("장바구니 업데이트 완료", data);
                            localStorage.setItem("basketChanged", Date.now());
                        },
                        error: function (err) {
                            console.error("장바구니 업데이트 실패", err);
                        }
                    });
                },

                fnPay() {
                    this.handleCartClose();
                    location.href = "/payment.do"
                },

                fnGetWishList() {
                    let self = this;

                    if(!self.sessionId){
                        return;
                    }

                    let nparmap = {
                        userNo: parseInt(self.sessionId)
                    };

                    $.ajax({
                        url: "/wishList/getWishList.dox",
                        type: "POST",
                        dataType: "json",
                        data: nparmap,
                        success: function (data) {
                            const wishTourNos = (data.list || []).map(item => +item.tourNo);
                            console.log("찜목록 tourNo 목록: ", wishTourNos);

                            self.toursList = self.toursList.map(function (tour) {
                                const tourNo = Number(tour.tourNo);
                                return {
                                    ...tour,
                                    isFavorite: wishTourNos.includes(tourNo) ? "Y" : "N"
                                };
                            });

                            console.log("최종 toursList: ", self.toursList);
                        }
                    });
                },

                toggleFavorite(tour) {
                    let self = this;
                    tour.isFavorite = tour.isFavorite === "Y" ? "N" : "Y";
                    if (tour.isFavorite === "Y") {
                        $.ajax({
                            url: "/wishList/addWishList.dox",
                            type: "POST",
                            data: {
                                userNo: self.sessionId,
                                guideNo: tour.guideNo,
                                tourNo: tour.tourNo
                            },
                            success: function (res) {
                                console.log("찜 추가됨", res);
                            }
                        });
                    } else {
                        $.ajax({
                            url: "/wishList/removeWishList.dox",
                            type: "POST",
                            data: {
                                userNo: self.sessionId,
                                tourNo: tour.tourNo
                            },
                            success: function (res) {
                                console.log("찜 제거됨", res);
                            }
                        });
                    }
                },

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

            created() {
                const params = new URLSearchParams(window.location.search);
                const keyword = params.get("keyword");

                if (keyword) {
                    this.keyword = keyword; // 검색창에 표시
                    this.fnGetSearchResult(keyword); // 검색 로직 실행
                }
            },

            mounted() {
                let self = this;
                self.fnToursList();
                self.fnGetMinTourDate();
                self.fnGetMaxTourDate();
                self.fnGetTourDateList();
                self.fnGetBasket();
                self.fnGetBasketList();

                setTimeout(() => {
                    if (this.sessionId && !isNaN(this.sessionId)) {
                        this.fnGetWishList();
                    } else {
                        console.log("🔒 로그인하지 않은 상태입니다. 찜 목록 조회 생략.");
                    }
                }, 300);
            }
        });

        app.mount('#app');
    </script>