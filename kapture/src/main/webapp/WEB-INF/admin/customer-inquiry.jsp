<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">

		<title>관리자 페이지</title>
		<style>
			/* 테이블 스타일 */
			.content table {
				width: 90%;
				margin: 20px auto;
				border-collapse: collapse;
				font-size: 14px;
			}

			.content th,
			.content td {
				border: 1px solid #ccc;
				padding: 10px;
				text-align: center;
				vertical-align: middle;
			}

			.content th {
				background-color: #f4f4f4;
			}

			/* 버튼 */
			.btn-manage {
				background-color: #007bff;
				color: white;
				border: none;
				padding: 5px 8px;
				margin: 5px;
				border-radius: 3px;
				cursor: pointer;
			}

			.btn-manage:hover {
				background-color: #0056b3;
			}

			/* 제목 스타일 */
			.page-title {
				text-align: center;
				font-size: 24px;
				font-weight: bold;
				margin-top: 20px;
				margin-left: 220px;
				/* 사이드바 너비(200px) + 여백(20px) */
				padding: 20px;
				display: flex;
				justify-content: center;
				/* 수평 중앙 정렬 */
				align-items: center;
			}

			/* 모달 오버레이 (뒷배경) */
			.modal-overlay {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				background-color: rgba(0, 0, 0, 0.4);
				display: flex;
				align-items: center;
				justify-content: center;
				z-index: 9999;
			}

			/* 모달 내용 컨테이너 */
			.modal-content {
				background-color: #fff;
				width: 600px;
				/* 모달 폭 */
				padding: 20px;
				border-radius: 5px;
				max-height: 90vh;
				overflow-y: auto;
				display: flex;
				flex-direction: column;
				align-items: center;
				text-align: center;
			}

			/* 모달 내부에서의 textarea */
			.answer-textarea {
				width: 100%;
				height: 150px;
				resize: none;
				margin-top: 10px;
			}
		</style>
		</style>
	</head>

	<body>
		<jsp:include page="menu.jsp"></jsp:include>
		<div id="app">
			<!-- 제목 추가 -->
			<div class="page-title">고객 문의 관리</div>

			<hr>
			<div class="content">
				<table>
					<thead>
						<tr>
							<th>문의번호</th>
							<th>회원번호</th>
							<th>이름</th>
							<th>이메일</th>
							<th>연락처</th>
							<th>카테고리</th>
							<th>제목</th>
							<th>문의내용</th>
							<th>접수일</th>
							<th>처리상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<!-- 가이드 리스트 반복 출력 -->
						<tr v-for="inquiry in inquiriesList">
							<!-- 문의번호 -->
							<td>{{ inquiry.inquiryNo }}</td>
							<!-- 회원번호-->
							<td>{{ inquiry.userNo }}</td>
							<!-- 회원번호-->
							<td>
								{{ inquiry.userFirstName }}
								<template v-if="inquiry.userLastName != 'N/A'">{{inquiry.userLastName}}</template>
							</td>
							<!-- 이메일-->
							<td>{{ inquiry.email }}</td>
							<!-- 연락처-->
							<td>{{ inquiry.phone }}</td>
							<!-- 카테고리 -->
							<td>{{ inquiry.category }}</td>
							<!-- 제목 -->
							<td>{{ inquiry.qnaTitle }}</td>
							<!-- 문의내용 -->
							<td>{{ inquiry.question }}</td>
							<!-- 접수일-->
							<td>{{ inquiry.inqCreatedAt }}</td>
							<!-- 처리상태 -->
							<td>{{inquiry.qnaStatus}}</td>
							<!-- 관리 ( 수정, 삭제 ) -->
							<td>
								<button class="btn-manage" @click="fnInquiryAnswer(inquiry)">
									답변
								</button>
								<button class="btn-manage" @click="fnInquiryDelete(inquiry.inquiryNo)">
									삭제
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div v-if="showAnswerModal" class="modal-overlay" @click.self="fnCloseAnswerModal">
				<div class="modal-content">
					<h2>1:1 문의 답변</h2>
					 <!-- 테이블 시작 -->
					 <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
						<tbody>
							<!-- 문의유형 -->
							<tr>
								<!-- 왼쪽 셀: 라벨 -->
								<td style="width: 120px; background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
									문의유형
								</td>
								<!-- 오른쪽 셀: 인풋박스 -->
								<td style="border: 1px solid #ccc; padding: 10px;">
									<input type="text" v-model="selectedInquiry.category" 
										   readonly
										   style="width: 97%; padding: 5px;" />
								</td>
							</tr>
							
							<!-- 제목 -->
							<tr>
								<td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
									제목
								</td>
								<td style="border: 1px solid #ccc; padding: 10px;">
									<input type="text" v-model="selectedInquiry.qnaTitle" 
										   readonly
										   style="width: 97%; padding: 5px;" />
								</td>
							</tr>
							
							<!-- 문의내용 -->
							<tr>
								<td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
									문의내용
								</td>
								<td style="border: 1px solid #ccc; padding: 10px;">
									<textarea v-model="selectedInquiry.question"
											  readonly
											  style="width: 97%; height: 100px; padding: 5px; resize: none;"></textarea>
								</td>
							</tr>
							
							<!-- 답변 -->
							<tr>
								<td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
									답변
								</td>
								<td style="border: 1px solid #ccc; padding: 10px;">
									<textarea v-model="answerText"
											  placeholder="답변 내용을 입력해주세요"
											  style="width: 97%; height: 150px; padding: 5px; resize: none;"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<div style="margin-top: 20px;">
						<button class="btn-manage" @click="fnSaveAnswer">저장</button>
					</div>
				</div>
			</div>
			<!-- [모달 끝] -->
		</div>
	</body>

	</html>
	<script>
		const app = Vue.createApp({
			data() {
				return {
					inquiriesList: [],
					showAnswerModal: false,// 답변 모달 표시 여부
					selectedInquiry: null, // 현재 선택된 문의 정보
				};
			},
			methods: {
				// 문의 목록 불러오기
				fnGetInquiryiesList() {
					let self = this;
					let nparmap = {};
					$.ajax({
						url: "/admin/users-inquiries.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							self.inquiriesList = data.inquiriesList;

						},
						error: function (err) {
							console.error(err);
						}
					});
				},


				// '답변' 버튼 클릭 시 모달 열기
				fnInquiryAnswer(inquiry) {
					this.selectedInquiry = inquiry;
					this.answerText = inquiry.answer; // 원본 답변 복사
					this.showAnswerModal = true;
				},

				// 모달 닫기
				fnCloseAnswerModal() {
					this.showAnswerModal = false;
					this.selectedInquiry = null;
					this.answerText = "";
				},

				// '저장' 버튼 클릭 시 답변 저장
				fnSaveAnswer() {
					let self = this;
					if (!this.selectedInquiry) {
						alert("문의 정보를 찾을 수 없습니다.");
						return;
					}
					// 서버 전송 전에 원본 객체에도 answerText 반영 (선택사항)
    				this.selectedInquiry.answer = this.answerText;
					let nparmap = {
						inquiryNo: self.selectedInquiry.inquiryNo,
						answer: this.answerText
					};

					$.ajax({
						url: "/admin/inquiry-answer-save.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result === "success") {
								alert("답변이 저장되었습니다.");
								self.showAnswerModal = false;
								self.selectedInquiry = null;
								self.answerText = "";
								self.fnGetInquiryiesList(); // 목록 갱신
							} else {
								alert("답변 저장 실패");
							}
						},
						error: function (err) {
							console.error(err);
							alert("답변 저장 중 오류가 발생했습니다.");
						}
					});
				},

				// '삭제' 버튼 클릭 시
				fnInquiryDelete(inquiryNo) {
					if (!confirm("정말 삭제하시겠습니까?")) return;

					$.ajax({
						url: "/admin/inquiry-delete.dox",
						dataType: "json",
						type: "POST",
						data: { inquiryNo: inquiryNo },
						success: function (data) {
							console.log(data);
							// 재조회 or 페이지 리로드
							location.reload();
						},
						error: function (err) {
							console.error(err);
							alert("삭제 요청 중 오류가 발생했습니다.");
						}
					});
				},
			},
			mounted() {
				let self = this;
				self.fnGetInquiryiesList();
			}
		});
		app.mount('#app');
	</script>