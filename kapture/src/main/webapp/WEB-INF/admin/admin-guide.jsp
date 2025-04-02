<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>관리자 페이지</title>
		<style>
			/* 테이블 스타일 */
			table {
				width: 90%;
				margin: 20px auto;
				border-collapse: collapse;
				font-size: 14px;
			}

			th,
			td {
				border: 1px solid #ccc;
				padding: 10px;
				text-align: center;
				vertical-align: middle;
			}

			th {
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
				border: 1px dashed #999;
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

			/* 상단 메뉴 등 추가 영역
			.menu-area {
				background: #f0f0f0;
				padding: 10px;
			} */

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
				width: 600px;
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
		</style>
	</head>

	<body>
		<jsp:include page="menu.jsp"></jsp:include>
		<div id="app">
			<!-- 제목 추가 -->
			<div class="page-title">가이드 정보관리</div>

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
							<th>가이드번호</th>
							<th>이름</th>
							<th>성별</th>
							<th>연락처</th>
							<th>사진</th>
							<th>가입일</th>
							<th>생년월일</th>
							<th>최근접속</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<!-- 가이드 리스트 반복 출력 -->
						<tr v-for="guide in guidesList" :key="guide.id">
							<!-- 선택 체크박스 -->
							<td>
								<input type="checkbox" :value="guide.userNo" v-model="selectedGuides">
							</td>
							<!-- 회원번호 -->
							<td>{{ guide.userNo }}</td>
							<!-- 가이드번호-->
							<td>{{ guide.guideNo }}</td>
							<!-- 닉네임 -->
							<td>{{ guide.userLastName }}{{ guide.userFirstName }}</td>
							<!-- 성별 -->
							<td>{{ guide.gender }}</td>
							<!-- 연락처 -->
							<td>{{ guide.phone }}</td>
							<!-- 사진: 있으면 <img>, 없으면 "No Image" 표시 -->
							<td>
								<div v-if="guide.photo && guide.photo !== ''">
									<img :src="guide.photo" alt="가이드사진" class="guide-img" />
								</div>
								<div v-else class="no-image">NO Image</div>
							</td>
							<!-- 수정일 -->
							<td>{{ guide.uUpdatedAt }}</td>
							<!-- 생년월일 -->
							<td>{{ guide.birthday }}</td>
							<!-- 최근접속 -->
							<td>{{ guide.lastLogin }}</td>

							<!-- 관리 ( 수정, 삭제 ) -->
							<td>
								<button class="btn-manage" @click="fnGuideEdit(guide)">
									수정
								</button>
								<button class="btn-manage" @click="fnUnregister(guide.userNo)">
									삭제
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div v-if="showEditModal" class="modal-overlay" @click.self="fnGuideEditClose()">
				<div class="modal-content">
					<h2>가이드 정보 수정</h2>
					<div class="modal-form">
						<!-- 이름 -->
						<div class="form-group">
							<label>나중에이미지랑파일업로드</label>
							<input type="text" v-model="editGuide.profileImage" />
						</div>
						<!-- 이름 -->
						<div class="form-group">
							<label>이름</label>
							<input type="text" v-model="editGuide.userFirstName" />
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
						<!-- 이메일 -->
						<div class="form-group">
							<label>이메일</label>
							<input type="text" v-model="editGuide.email" placeholder="이메일" />
						</div>
						<!-- 성별 -->
						<div class="form-group">
							<span><label>성별</label></span>
							<span>남성<input type="radio" value="M" v-model="editGuide.gender" /></span>
							<span>여성<input type="radio" value="F" v-model="editGuide.gender" /></span>
						</div>
						<!-- 연락처 -->
						<div class="form-group">
							<label>연락처</label>
							<input type="text" v-model="editGuide.phone" />
						</div>
						<!-- 생년월일 -->
						<div class="form-group">
							<label>생년월일</label>
							<input type="date" v-model="editGuide.birthday" />
						</div>
						<!-- 주소 -->
						<div class="form-group">
							<label>주소</label>
							<input type="text" v-model="editGuide.address">
						</div>
						<!-- 사용가능 언어 -->
						<div class="form-group">
							<label>사용가능 언어</label>
							<input type="text" v-model="editGuide.language">
						</div>
						<!-- 자기소개 등 (예시) -->
						<div class="form-group">
							<label>자기소개 OR 경력</label>
							<textarea v-model="editGuide.experience" rows="4"></textarea>
						</div>

						<!-- 저장 / 취소 -->
						<div>
							<button @click="fnSaveGuide">저장하기</button>
							<button @click="fnGuideEditClose()">취소</button>
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
					guidesList: [],
					selectedGuides: [], // 체크된 id들의 배열
					showEditModal: false,  // 수정 모달 표시 여부
					editGuide: {},          // 수정할 가이드 정보
					password: "",
					confirmPassword: "",
					passwordRules: { length: false, upper: false, lower: false, special: false, number: false },
					passwordValid: false,
					passwordsMatch: false
				};
			},
			computed: {
				// 모든 행이 체크되어 있는지 여부
				isAllChecked() {
					return this.guidesList.length > 0
						&& this.selectedGuides.length === this.guidesList.length;
				}
			},
			methods: {
				// 예: 전체선택/해제
				toggleAll(event) {
					if (event.target.checked) {
						// 모든 id를 selectedGuides에 넣음
						this.selectedGuides = this.guidesList.map(g => g.id);
					} else {
						// 모두 해제
						this.selectedGuides = [];
					}
				},

				// 가이드 목록 불러오기
				fnGetGuidesList() {
					let self = this;
					let nparmap = {

					};
					$.ajax({
						url: "/admin/guides-list.dox",
						dataType: "json",
						type: "POST",
						data: nparmap,
						success: function (data) {
							console.log(data);
							for (let i = 0; i < data.guidesList.length; i++) {
								if (data.guidesList[i].birthday && typeof data.guidesList[i].birthday === 'string') {
									data.guidesList[i].birthday = data.guidesList[i].birthday.substring(0, 10);
								} else {
									data.guidesList[i].birthday = ""; // 또는 기본값 설정
								}
							}
							self.guidesList = data.guidesList;
							console.log(self.guidesList);
						},
						error: function (err) {
							console.error(err);
						}
					});
				},
				// 수정 버튼 클릭 시: userNo로 가이드 상세 불러온 뒤 모달 열기
				fnGuideEdit(guide) {
					let self = this;
					self.editGuide = guide;
					console.log(guide);
					// 모달 열기
					self.showEditModal = true;
				},
				fnGuideEditClose() {
					let self = this;
					self.showEditModal = false;
					self.password = "";
					self.confirmPassword = "";
					self.passwordRules = { length: false, upper: false, lower: false, special: false, number: false };
					self.passwordValid = false;
					self.passwordsMatch = false;
				},
				// 모달에서 '저장하기' 클릭 시: 수정 API 호출
				fnSaveGuide() {
					let self = this;
					// 수정된 정보 전송
					let nparmap = {
						profileImage: self.editGuide.profileImage,
						userFirstName: self.editGuide.userFirstName,
						password: self.password,
						email: self.editGuide.email,
						gender: self.editGuide.gender,
						phone: self.editGuide.phone,
						birthday: self.editGuide.birthday,
						address: self.editGuide.address,
						language: self.editGuide.language,
						experience: self.editGuide.experience,
					};
					$.ajax({
						url: "/admin/guide-update.dox", // 실제 업데이트 API
						dataType: "json",
						type: "POST",
						data: nparmap, // editGuide 객체 전체를 전송 (필요 시 파라미터 조정)
						success: function (data) {
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
								self.fnGetGuidesList();
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
				fnUnregister(userNo) {
					if (!confirm("정말 삭제하시겠습니까?")) {
						return;
					}
					// 삭제 로직 or API
					// 아래는 예시
					$.ajax({
						url: "/admin/guide-delete.dox",
						dataType: "json",
						type: "POST",
						data: { userNo: userNo },
						success: function (res) {
							if (res.result === "success") {
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
				self.fnGetGuidesList();
			}
		});
		app.mount('#app');
	</script>