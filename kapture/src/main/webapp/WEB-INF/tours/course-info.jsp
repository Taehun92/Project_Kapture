<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>여행지 상세 정보</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/vue@3"></script>
</head>
<body>
  <div id="app" class="max-w-2xl mx-auto mt-10 p-6 border rounded shadow">
    <div>
      <img :src="place.firstimage" alt="썸네일" class="w-full h-60 object-cover rounded mb-4" v-if="place.firstimage" />
      <h1 class="text-2xl font-bold mb-2">{{ place.title }}</h1>
      <p class="text-gray-700 mb-2">{{ place.addr1 }}</p>
      <p class="text-sm text-gray-500 mb-4">카테고리: {{ place.cat2 }}</p>
      <p class="text-gray-800 whitespace-pre-wrap">{{ place.overview }}</p>
    </div>
    
  </div>

  <script>
    const { createApp } = Vue;

    createApp({
      data() {
        return {
            place: {},
            contentId : '<%= request.getParameter("contentId") %>',
            contentType : '<%= request.getParameter("contentTypeId") %>',
        };
      },
      methods: {
        async fetchCourses() {
            let self = this;
            const apiKey = 'O5%2BkPtLkpnsqZVmVJiYW7JDeWEX4mC9Vx3mq4%2FGJs%2Fejvz1ceLY%2B0XySUsy15P%2BhpAdHcZHXHhdn4htsTUuvpA%3D%3D';
            const url = 'http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey='
            + apiKey
            +'&contentTypeId='
            + self.contentType
            +'&contentId='
            + self.contentId
            +'&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y&_type=json'

            console.log('url' , url);
            try {
              const response = await fetch(url);
              const data = await response.json();
              this.place = data.response.body.items.item[0];
              console.log(this.place);
            } catch (error) {
              console.error('API 호출 오류:', error);
            }
          },
      },
      mounted() {
        this.fetchCourses();
      }
    }).mount('#app');
  </script>
</body>
</html>