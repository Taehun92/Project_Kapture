<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>

  <title>자주 묻는 질문</title>
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: Arial, sans-serif;
    }

    .main-layout {
      display: flex;
      flex: 1;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }

    .sidebar {
      width: 220px;
      background-color: #fff;
      padding: 20px;
      box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
    }

    .sidebar ul {
      list-style: none;
      padding: 0;
    }

    .sidebar ul li {
      padding: 15px;
      cursor: pointer;
      font-weight: bold;
      border-radius: 5px;
    }

    .sidebar ul li:hover {
      background-color: #3e4a97;
      color: white;
    }

    .sidebar .active {
      color: red;
      font-weight: bold;
    }

    .content {
      flex: 1;
      padding: 20px 30px;
      width: 100%;
    }

    /* 검색 영역 */
    .search-box {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      margin-bottom: 20px;
    }

    .search-box select,
    .search-box input,
    .search-box button {
      padding: 10px;
      margin: 5px;
      border-radius: 5px;
      border: 1px solid #ccc;
    }

    .search-box input {
      width: 400px;
    }

    /* 카테고리 필터 메뉴 */
    .faq-category-menu {
      display: flex;
      gap: 15px;
      margin-bottom: 20px;
      border-bottom: 1px solid #ddd;
      padding-bottom: 10px;
      font-weight: bold;
    }

    .faq-category-menu span {
      cursor: pointer;
      padding: 5px 10px;
      border-radius: 5px;
      color: #333;
    }

    .faq-category-menu .active {
      color: #e60023;
      border-bottom: 2px solid #e60023;
    }

    .category-container {
      cursor: pointer;
      font-weight: bold;
      background-color: white;
      padding: 12px;
      margin-bottom: 10px;
      border-radius: 8px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .plus-btn {
      font-size: 20px;
      transition: color 0.3s ease;
    }

    .category-content {
      background-color: #fff;
      padding: 10px;
      border-radius: 5px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      margin-bottom: 10px;
    }

    .pagination {
      text-align: center;
      margin-top: 20px;
    }

    .pagination a {
      margin: 0 8px;
      cursor: pointer;
      padding: 8px 15px;
      border-radius: 5px;
      text-decoration: none;
    }

    .pagination .bgcolor-gray {
      background-color: #003366;
      color: white;
    }
  </style>
</head>

<body>
  <jsp:include page="../common/header.jsp" />
  <div id="app" class="main-layout">
    <!-- 사이드바 -->
    <div class="sidebar">
      <ul>
        <li :class="{ active: activeMenu === 'notice' }" @click="goTo('notice')">공지사항</li>
        <li :class="{ active: activeMenu === 'faq' }" @click="setActive('faq')">FAQ</li>
        <li :class="{ active: activeMenu === 'inquiry' }" @click="goTo('inquiry')">Q&A</li>
      </ul>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="content">
      <!-- 검색창 -->
      <div class="search-box">
        <select v-model="searchOption">
          <option value="all">:: 전체 ::</option>
          <option value="category">카테고리</option>
          <option value="question">질문</option>
        </select>
        <input v-model="keyword" @keyup.enter="fnMain" placeholder="검색어">
        <button @click="fnMain">검색</button>
      </div>

      <!-- 카테고리 필터 -->
      <div class="faq-category-menu">
        <span 
          v-for="cat in categories" 
          :key="cat.value" 
          :class="{ active: selectedCategory === cat.value }"
          @click="filterByCategory(cat.value)">
          {{ cat.label }}
        </span>
      </div>

      <!-- 질문 리스트 -->
      <div v-for="item in filteredList" :key="item.category + item.question">
        <div class="category-container" @click="toggleAnswer(item)">
          <span>{{ item.category }} - {{ item.question }}</span>
          <span class="plus-btn">{{ item.isOpen ? '-' : '+' }}</span>
        </div>
        <div v-if="item.isOpen" class="category-content">
          <div>답변: {{ item.answer }}</div>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <a v-for="num in index" @click="fnPage(num)">
          <span v-if="page == num" class="bgcolor-gray">{{ num }}</span>
          <span v-else>{{ num }}</span>
        </a>
      </div>
    </div>
  </div>

  <jsp:include page="../common/footer.jsp" />

  <script>
    const app = Vue.createApp({
      data() {
        return {
          list: [],
          filteredList: [],
          searchOption: "all",
          keyword: "",
          pageSize: 10,
          index: 0,
          page: 1,
          activeMenu: 'faq',
          selectedCategory: "all",
          categories: [
            { label: "전체", value: "all" },
            { label: "국내패키지", value: "국내패키지" },
            { label: "예약/결제", value: "예약/결제" },
          ]
        };
      },
      methods: {
        fnMain() {
          let self = this;
          let nparmap = {
            keyword: self.keyword,
            searchOption: self.searchOption,
            pageSize: self.pageSize,
            page: (self.page - 1) * self.pageSize
          };
          $.ajax({
            url: "/cs/faq.dox",
            dataType: "json",
            type: "POST",
            data: nparmap,
            success: function (data) {
              self.list = data.list.map(item => ({
                ...item,
                isOpen: false
              }));
              self.index = Math.ceil(data.count / self.pageSize);
              self.filterByCategory(self.selectedCategory); // 필터 적용
            }
          });
        },
        fnPage(num) {
          this.page = num;
          this.fnMain();
        },
        toggleAnswer(item) {
          item.isOpen = !item.isOpen;
        },
        setActive(menu) {
          this.activeMenu = menu;
        },
        goTo(menu) {
          if (menu === 'notice') {
            window.location.href = '/cs/notice.do';
          } else if (menu === 'inquiry') {
            window.location.href = '/cs/qna.do';
          }
        },
        filterByCategory(category) {
          this.selectedCategory = category;
          if (category === "all") {
            this.filteredList = this.list;
          } else {
            this.filteredList = this.list.filter(item => item.category === category);
          }
        }
      },
      mounted() {
        this.fnMain();
      }
    });

    app.mount('#app');
  </script>
</body>

</html>
