<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-Change.js"></script>
		<title>첫번째 페이지</title>
	</head>
	<style>
		body {
			font-family: Arial, sans-serif;
		}

		.container {
			width: 80%;
			margin: auto;
		}

		.tour-header {
			text-align: center;
			font-size: 24px;
			font-weight: bold;
			margin-bottom: 20px;
		}

		.tour-buttons {
			display: flex;
			justify-content: center;
			gap: 10px;
			margin-bottom: 20px;
		}

		.tour-buttons button {
			padding: 10px 15px;
			border: 1px solid #ccc;
			background-color: #f8f8f8;
			cursor: pointer;
		}

		.tour-list {
			display: flex;
			flex-wrap: wrap;
			gap: 15px;
			justify-content: center;
		}

		.tour-card {
			width: 220px;
			border: 1px solid #ddd;
			padding: 10px;
			text-align: center;
		}

		.tour-card img {
			width: 100%;
			height: 120px;
			object-fit: cover;
		}

		.tour-card button {
			margin-top: 10px;
			padding: 5px 10px;
			background-color: blue;
			color: white;
			border: none;
			cursor: pointer;
		}
	</style>

	<body>
			<div id="app" class="container">
				<div class="tour-header">주요 관광지</div>
				<div class="tour-buttons">
					<button v-for="region in regions" :key="region">{{ region }}</button>
				</div>

				<h3>Korea tour list</h3>
				<div class="tour-list">
					<div v-for="tour in tours" :key="tour.id" class="tour-card">
						<img :src="tour.image" alt="Tour Image">
						<p>{{ tour.name }}</p>
						<p>{{ tour.description }}</p>
						<button @click="viewDetails(tour.id)">Click me</button>
					</div>
				</div>
			</div>
	</body>

</html>
<script>
		const app = Vue.createApp({
			data() {
				return {
					regions: ["서울", "경기 인천", "부산", "전주", "강원", "그 외"],
					tours: []
				};
			},
			methods: {
				fetchTours() {
					let self = this;
					$.ajax({
						url: "/tours/list.dox",
						dataType: "json",
						type: "POST",
						success: function (data) {
							self.tours = data.tours || [];
						}
					});
				},
				viewDetails(id) {
					alert("관광지 상세 정보 ID: " + id);
				}
			},
			mounted() {
				let self = this;
				self.fetchTours();
			}
		});
		app.mount('#app');
</script>