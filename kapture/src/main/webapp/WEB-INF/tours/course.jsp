<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>여행 코스 리스트</title>
    <!-- Tailwind CDN (선택) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Vue 3 CDN -->
    <script src="https://unpkg.com/vue@3"></script>
</head>
<body>

<div id="app" class="p-6">
    <!-- 카테고리 필터 -->
    <div class="mb-4 flex space-x-2">
        <button
            v-for="cat in categories"
            :key="cat.code"
            :class="['px-4 py-2 rounded', selectedCat2 === cat.code ? 'bg-emerald-500 text-white' : 'bg-gray-200']"
            @click="filterByCategory(cat.code)"
        >
            {{ cat.label }}
        </button>
    </div>

    <!-- 언어 선택 -->
    <div class="mb-4 flex space-x-2">
        <select v-model="lang" @change="fnSelectLang" class="border border-gray-300 px-3 py-2 rounded">
            <option v-for="langItem in langList" :key="langItem.code" :value="langItem.code">
                {{ langItem.label }}
            </option>
        </select>
    </div>

    <div>
    <!-- 지역 선택 버튼 -->
    <select id="regionFilter" v-model="selectedRegion" @change="filterByRegion">
        <option value="">전체</option>
        <option value="1">서울</option>
        <option value="6">부산</option>
        <option value="4">대구</option>
        <option value="2">인천</option>
        <option value="5">광주</option>
        <option value="3">대전</option>
        <option value="7">울산</option>
        <option value="8">세종</option>
        <option value="31">경기</option>
        <option value="32">강원</option>
        <option value="33">충북</option>
        <option value="34">충남</option>
        <option value="35">경북</option>
        <option value="36">경남</option>
        <option value="37">전북</option>
        <option value="38">전남</option>
        <option value="39">제주</option>
    </select>
    </div>
    
    <!-- 검색창 -->
    <div class="mb-4 flex space-x-2">
        <input
            v-model="searchKeyword"
            type="text"
            placeholder="검색어를 입력하세요"
            class="border border-gray-300 px-3 py-2 rounded w-full"
        />
        <button @click="searchCourses" class="bg-blue-500 text-white px-4 py-2 rounded">
            검색
        </button>
    </div>

    <!-- 결과 리스트 -->
    <ul class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <li v-for="course in paginatedCourses" :key="course.contentid" class="border rounded shadow p-3">
            <a :href="'course-info.do?contentId=' + course.contentid + '&contentTypeId=' + course.contenttypeid" class="block">
                <img :src="course.firstimage || 'default.jpg'" alt="썸네일" class="w-full h-48 object-cover rounded" />
                <div class="mt-2">
                    <span class="text-sm text-gray-500"># {{ course.cat2 }}</span>
                    <p class="text-lg font-semibold">{{ course.title }}</p>
                </div>
            </a>
        </li>
    </ul>

    <!-- 페이지네이션 -->
    <div class="mt-6 flex justify-center space-x-2">
        <button
            v-for="page in totalPages"
            :key="page"
            :class="['px-3 py-1 border rounded', currentPage === page ? 'bg-emerald-500 text-white' : 'bg-white']"
            @click="changePage(page)"
        >
            {{ page }}
        </button>
    </div>
</div>

<!-- Vue 앱 스크립트 -->
<script>
const { createApp } = Vue;

createApp({
  data() {
    return {
        categories: [
            { code: 'A0207', label: '레포츠' },
            { code: 'A0208', label: '쇼핑' },
            { code: 'A0206', label: '투어' },
        ],
        selectedCat2: 'A0207',
        searchKeyword: '',
        courses: [],
        filteredCourses: [],
        currentPage: 1,
        itemsPerPage: 10,
        lang : 'Kor',
        langList : [
            { code: 'Kor', label: '한국어' },
            { code: 'Eng', label: '영어' },
            { code: 'Jpn', label: '일본어' },
            { code: 'Chs', label: '중국어' },
        ],
        selectedRegion: '',



    };
  },
  computed: {
    paginatedCourses() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      return this.filteredCourses.slice(start, start + this.itemsPerPage);
    },
    totalPages() {
      return Math.ceil(this.filteredCourses.length / this.itemsPerPage);
    },
  },
  methods: {
    async fetchCourses() {
      const apiKey = 'O5%2BkPtLkpnsqZVmVJiYW7JDeWEX4mC9Vx3mq4%2FGJs%2Fejvz1ceLY%2B0XySUsy15P%2BhpAdHcZHXHhdn4htsTUuvpA%3D%3D';
      const url = 'https://apis.data.go.kr/B551011/'
        +this.lang
        +'Service1/areaBasedList1?serviceKey='
        +apiKey
        +'&areaCode='
        +this.selectedRegion
        +'&MobileApp=AppTest&MobileOS=ETC&cat2='
        +this.selectedCat2
        +'&_type=json&numOfRows=100';

      try {
        const response = await fetch(url);
        const data = await response.json();
        this.courses = data.response.body.items.item || [];
        this.filteredCourses = this.courses;
        this.currentPage = 1;
        console.log(this.courses);
      } catch (error) {
        console.error('API 호출 오류:', error);
      }
    },

    filterByCategory(cat2) {
      this.selectedCat2 = cat2;
      this.fetchCourses();
    },

    fnSelectLang() {
        this.fetchCourses();
        
    },

    filterByRegion() {
        this.fetchCourses();
    },

    searchCourses() {
      const keyword = this.searchKeyword.toLowerCase();
      this.filteredCourses = this.courses.filter((item) =>
        item.title.toLowerCase().includes(keyword)
      );
      this.currentPage = 1;
    },

    changePage(page) {
      this.currentPage = page;
    },

  },
  mounted() {
    this.fetchCourses();
  },
}).mount('#app');
</script>

</body>
</html>