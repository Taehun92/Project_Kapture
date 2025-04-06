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

			/* 이미지 스타일 */
			.guide-img {
				width: 60px;
				height: 60px;
				object-fit: cover;
				/* 이미지가 잘리지 않도록 조정 */
				border-radius: 5px;
			}

			/* "No Image" 문구 표시 스타일 */
			.no-image {
				width: 60px;
				height: 60px;
				border: 1px dashed #999999;
				display: flex;
				align-items: center;
				justify-content: center;
				color: #999;
				font-size: 12px;
			}

			/* 체크박스와 관리 버튼 예시 */
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

			/* 전체 선택 체크박스 스타일 (th 안) */
			.check-all {
				cursor: pointer;
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
				/* 테이블보다 위에 표시되도록 */
			}

			/* 모달 내용 컨테이너 */
			.modal-content {
				background-color: #fff;
				width: 800px;
				/* 모달 폭 (필요에 맞게 조절) */
				padding: 20px;
				border-radius: 5px;
				position: relative;
				/* close 버튼 배치용 */
				max-height: 90vh;
				/* 세로 최대크기 제한 */
				overflow-y: auto;
				/* 내용이 길어지면 스크롤 */
				display: flex;
				flex-direction: column;
				align-items: center;
				text-align: center;
			}

			/* 모달 내부 폼 스타일 예시 */
			.modal-form label {
				display: inline-block;
				width: 110px;
				margin-bottom: 5px;
			}

			.modal-form input,
			.modal-form select,
			.modal-form textarea {
				width: 300px;
				margin-bottom: 10px;
			}

			.modal-form input[type=radio] {
				width: 20px;
				margin-right: 30px;
			}

			.modal-form .form-group {
				margin-bottom: 10px;
			}

			.modal-form button {
				margin-right: 10px;
			}

			/* 유효성 검사 메시지 스타일 */
			.modal-validation {
				font-size: 13px;
				line-height: 1.4;
			}

			/* content-area 및 custom 버튼 스타일 (일정 모달 내부) */
			.content-area {
				width: 100%;
			}

			.custom-buttons {
				list-style: none;
				padding: 0;
				margin: 0 0 10px 0;
				display: flex;
				gap: 10px;
				justify-content: center;
			}

			.custom-button {
				display: flex;
				align-items: center;
				font-size: 14px;
			}

			.custom-button .dot {
				margin-right: 4px;
			}

			.fc-event-title {
				white-space: normal !important;
				overflow: hidden;
				text-overflow: ellipsis;
				display: -webkit-box;
				-webkit-box-orient: vertical;
				-webkit-line-clamp: 2;
				/* 최대 2줄로 표시 */
				line-clamp: 2;
			}

			.profile-upload-container {
				display: flex;
				align-items: center;
				gap: 10px;
				/* 요소 사이 간격 */
			}

			/* 라디오 버튼 전용 컨테이너 */
			.radio-container {
				/* 다른 input과 동일한 폭을 맞추고 싶다면 */
				display: inline-block;
				/* 또는 flex */
				width: 300px;
				/* 필요하다면 수평 정렬 방식도 조정 가능 */
				/* justify-content: space-between; (flex 사용 시) */
				text-align: left;
			}

			/* 라디오 버튼 자체는 너무 넓게 잡지 않도록 */
			.radio-container input[type="radio"] {
				width: auto;
				/* 기본으로 두거나 */
				margin-right: 5px;
			}

			/* 라디오 버튼에 붙은 라벨 사이 간격 조정 */
			.radio-container label {
				margin-right: 15px;
				/* 버튼들 간격 */
			}
		</style>
	</head>

	<body>
		<jsp:include page="menu.jsp"></jsp:include>
		<div id="app">
			<!-- 제목 추가 -->
			<div class="page-title">고객 정보 관리</div>

			<hr>
			<div class="content">
				<table>
					<thead>
						<tr>
							<th>
								<input type="checkbox" class="check-all" @change="toggleAll($event)"
									:checked="isAllChecked" />
							</th>
							<th>회원번호</th>
							<th>이메일</th>
							<th>이름</th>
							<th>성별</th>
							<th>연락처</th>
							<th>생년월일</th>
							<th>주소</th>
							<th>역할</th>
							<th>국적</th>	
							<th>소셜타입</th>
							<th>알림 동의</th>
							<th>최근접속</th>
							<th>상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<!-- 가이드 리스트 반복 출력 -->
						<tr v-for="user in usersList">
							<!-- 선택 체크박스 -->
							<td>
								<input type="checkbox" :value="user.userNo" v-model="selectedUsers">
							</td>
							<!-- 회원번호 -->
							<td>{{ user.userNo }}</td>
							<!-- 이메일-->
							<td>{{ user.email }}</td>
							<!-- 이름 -->
							<td>{{ user.userFirstName }}
								<template v-if="user.userLastName != 'N/A'">{{ user.userLastName }}</template>
							</td>
							<!-- 성별 -->
							<td>{{ user.gender }}</td>
							<!-- 연락처 -->
							<td>{{ user.phone }}</td>
							<!-- 생년월일 -->
							<td>{{user.birthday}}</td>
							<!-- 주소 -->
							<td>{{ user.address }}</td>
							<!-- 역할 -->
							<td v-if="user.role === 'TOURIST'">일반회원</td>
							<td v-if="user.role === 'GUIDE'">가이드</td>
							<td v-if="user.role === 'ADMIN'">관리자</td>
							<!-- 국적 -->
							<td v-if="user.isForeigner === 'Y'">외국인</td>
							<td v-else>내국인</td>
							<!-- 소셜타입 -->
							<td>{{ user.socialType }}</td>
							<!-- 알림 동의 -->
							<td>{{user.pushYN}}</td>
							<!-- 최근접속 -->
							<td>{{user.lastLogin}}</td>
							<!-- 상태 -->
							<td v-if="user.unregisterYN === 'N'">회원</td>
							<td v-else>탈퇴</td>
							<!-- 관리 ( 수정, 삭제 ) -->
							<td>
								<button class="btn-manage" @click="fnUserEdit(user)">
									수정
								</button>
								<button class="btn-manage" @click="fnUnregister(user.userNo, user.role)">
									삭제
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div v-if="showEditModal" class="modal-overlay" @click.self="fnUserEditClose()">
				<div class="modal-content">
					<h2>회원 정보 수정</h2>
					<div class="modal-form">
						<!-- 이메일 -->
						<div class="form-group">
							<label>이메일</label>
							<input type="text" v-model="editUser.email" placeholder="이메일" />
						</div>
						<!-- 이름 -->
						<div class="form-group">
							<label>First Name</label>
							<input type="text" v-model="editUser.userFirstName" />
						</div>
						<div class="form-group">
							<label>Last Name</label>
							<input type="text" v-model="editUser.userLastName" placeholder="Last Name" />
						</div>
						<!-- 비밀번호 -->
						<div class="form-group">
							<label>비밀번호</label>
							<input type="password" v-model="password" @input="validateNewPassword" />
							<div v-if="password.length > 0 && !passwordValid" class="modal-validation">
								<div :style="{ color: passwordRules.length ? 'green' : 'red' }">
									{{ passwordRules.length ? '✅ At least 6 characters' : '❌ At least 6 characters'}}
								</div>
								<div :style="{ color: passwordRules.number ? 'green' : 'red' }">
									{{ passwordRules.number ? '✅ At least one number' : '❌ At least one number' }}
								</div>
								<div :style="{ color: passwordRules.upper ? 'green' : 'red' }">
									{{ passwordRules.upper ? '✅ At least one uppercase letter' : '❌ At least one uppercase letter' }}
								</div>
								<div :style="{ color: passwordRules.lower ? 'green' : 'red' }">
									{{ passwordRules.lower ? '✅ At least one lowercase letter' : '❌ At least one lowercase letter' }}
								</div>
								<div :style="{ color: passwordRules.special ? 'green' : 'red' }">
									{{ passwordRules.special ? '✅ At least one special character' : '❌ At least one special character' }}
								</div>
							</div>
						</div>
						<div class="form-group">
							<label>비밀번호 확인</label>
							<input type="password" v-model="confirmPassword" @input="validateNewPassword" />
							<div v-if="confirmPassword.length > 0 && passwordValid" class="modal-validation"
								:style="{ color: passwordsMatch ? 'green' : 'red' }">
								{{ passwordsMatch ? '✅ Passwords match.' : '❌ Passwords do not match.' }}
							</div>
						</div>
						<!-- 성별 -->
						<div class="form-group">
							<label>성별</label>
							<div class="radio-container">
								<label><input type="radio" value="M" v-model="editUser.gender" />남성</label>
								<label><input type="radio" value="F" v-model="editUser.gender" />여성</label>
							</div>
						</div>
						<!-- 연락처 -->
						<div class="form-group">
							<label>연락처</label>
							<input type="text" v-model="editUser.phone" />
						</div>
						<!-- 생년월일 -->
						<div class="form-group">
							<label>생년월일</label>
							<input type="date" v-model="editUser.birthday" />
						</div>
						<!-- 주소 -->
						<div class="form-group">
							<label>주소</label>
							<input type="text" v-model="editUser.address" />
						</div>
						<!-- 역할 -->
						<div class="form-group">
							<label>역할</label>
							<input type="text" v-model="editUser.role" />
						</div>
						<!-- 국적 -->
						<div class="form-group">
							<label>국적</label>
							<input type="text" v-model="editUser.isForeigner" />
						</div>
						<!-- 소셜타입 -->
						<div class="form-group">
							<label>소셜타입</label>
							<input type="text" v-model="editUser.socialType" />
						</div>
						<!-- 알림동의 -->
						<div class="form-group">
							<label>알림동의</label>
							<div class="radio-container">
								<label><input type="radio" value="Y" v-model="editUser.pushYN" />예</label>
								<label><input type="radio" value="N" v-model="editUser.pushYN" />아니요</label>
							</div>
						</div>
						<!-- 상태 -->
						<div class="form-group">
							<label>상태</label>
							<input type="text" v-model="editUser.unregisterYN" />
						</div>
						<!-- 저장 / 취소 -->
						<div>
							<button @click="fnSaveUser(editUser.userNo)">저장하기</button>
							<button @click="fnUserEditClose">취소</button>
						</div>
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
					usersList: [],
					selectedUsers: [], // 체크된 id들의 배열
					showEditModal: false,  // 수정 모달 표시 여부
					editUSer: {},          // 수정할 유저 정보
					password: "",
					confirmPassword: "",
					passwordRules: { length: false, upper: false, lower: false, special: false, number: false },
					passwordValid: false,
					passwordsMatch: false,
					beforeRole: "",
				};
			},
			computed: {
				// 모든 행이 체크되어 있는지 여부
				isAllChecked() {
					// return this.usersList.length > 0 && this.selectedUsers.length === this.sList.length;
				}
			},
			methods: {
				// 예: 전체선택/해제
				toggleAll(event) {
					if (event.target.checked) {
						this.selectedUsers = this.usersList.map(u => u.userNo);
					} else {
						// 모두 해제
						this.selectedUsers = [];
					}
				},

				// 유저 목록 불러오기
				fnGetUsersList() {
					let self = this;
					let nparmap = {

					};
					$.ajax({
						url: "/admin/users-list.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							for (let i = 0; i < data.usersList.length; i++) {
								if (data.usersList[i].birthday && typeof data.usersList[i].birthday === 'string') {
									data.usersList[i].birthday = data.usersList[i].birthday.substring(0, 10);
								} else {
									data.usersList[i].birthday = ""; // 또는 기본값 설정
								}
							}
							self.usersList = data.usersList;
							
						},
						error: function (err) {
							console.error(err);
						}
					});
				},
				// 수정 버튼 클릭 시: userNo로 가이드 상세 불러온 뒤 모달 열기
				fnUserEdit(user) {
					let self = this;
					self.editUser = user;
					self.beforeRole = user.role;
					console.log(user);
					// 모달 열기
					self.showEditModal = true;
				},
				fnUserEditClose() {
					let self = this;
					self.showEditModal = false;
					self.password = "";
					self.confirmPassword = "";
					self.passwordRules = { length: false, upper: false, lower: false, special: false, number: false };
					self.passwordValid = false;
					self.passwordsMatch = false;
				},
				// 모달에서 '저장하기' 클릭 시: 수정 API 호출
				fnSaveUser(userNo) {
					let self = this;
					// 수정된 정보 전송
					let nparmap = {
						userNo: userNo,
						userFirstName: self.editUser.userFirstName,
						userLastName: self.editUser.userLastName,
						password: self.password,
						email: self.editUser.email,
						address: self.editUser.address,
						gender: self.editUser.gender,
						phone: self.editUser.phone,
						birthday: self.editUser.birthday,
						isForeigner: self.editUser.isForeigner,
						socialType: self.editUser.socialType,
						pushYN: self.editUser.pushYN,
						lastLogin: self.editUser.lastLogin,
						unregisterYN: self.editUser.unregisterYN,
						role: self.editUser.role,
						beforeRole: self.beforeRole,
					};
					$.ajax({
						url: "/admin/user-update.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result === "success") {
								alert("수정이 완료되었습니다.");
								// 모달 닫기
								self.showEditModal = false;
								self.password = "";
								self.confirmPassword = "";
								self.passwordRules = { length: false, upper: false, lower: false, special: false, number: false };
								self.passwordValid = false;
								self.passwordsMatch = false;
								// 목록 재조회 (갱신)
								self.fnGetUsersList();
							} else {
								alert("수정에 실패했습니다.");
							}
						},
						error: function (err) {
							console.error(err);
							alert("수정 요청 중 오류가 발생했습니다.");
						}
					});
				},
				// 삭제 버튼 클릭 시
				fnUnregister(userNo, role) {
					if (!confirm("정말 삭제하시겠습니까?")) {
						return;
					}
					let nparmap = {
						userNo: userNo,
						role: role,
					};
					$.ajax({
						url: "/admin/unregister.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							if (data.result === "success") {
								alert("삭제되었습니다.");
								// 목록 새로고침
								location.reload();
							} else {
								alert("삭제 실패");
							}
						},
						error: function (err) {
							console.error(err);
							alert("삭제 요청 중 오류가 발생했습니다.");
						}
					});
				},
				validateNewPassword() {
					const pw = this.password;
					const pw2 = this.confirmPassword;
					this.passwordRules.length = pw.length >= 6;
					this.passwordRules.upper = /[A-Z]/.test(pw);
					this.passwordRules.lower = /[a-z]/.test(pw);
					this.passwordRules.special = /[^A-Za-z0-9]/.test(pw);
					this.passwordRules.number = /[0-9]/.test(pw);
					this.passwordValid = this.passwordRules.length && this.passwordRules.upper &&
						this.passwordRules.lower && this.passwordRules.special && this.passwordRules.number;
					this.passwordsMatch = pw && pw2 && (pw === pw2);
				},
			},
			mounted() {
				let self = this;
				self.fnGetUsersList();
			}
		});
		app.mount('#app');
	</script>