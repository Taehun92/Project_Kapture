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

            .search-input,
            .search-select,
            .search-date {
                padding: 10px 14px;
                font-size: 16px;
                height: 40px;
                border: 1px solid #ccc;
                border-radius: 6px;
                margin-right: 10px;
                box-sizing: border-box;
            }

            .search-input {
                width: 300px;
            }

            .search-button {
                padding: 10px 20px;
                font-size: 16px;
                height: 40px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            .search-button:hover {
                background-color: #0056b3;
            }

            .search-container {
                width: 90%;
                margin: 20px auto;
            }

            .tab-btn {
                margin-right: 10px;
                padding: 8px 12px;
                border: 1px solid #ccc;
                background: #f4f4f4;
                cursor: pointer;
                border-radius: 4px;
            }

            .tab-btn.active {
                background-color: #007bff;
                color: white;
            }

            [v-cloak] {
                display: none;
            }
        </style>
        </style>
    </head>

    <body>
        <jsp:include page="menu.jsp"></jsp:include>
        <div id="app" v-cloak>
            <!-- 제목 추가 -->
            <div class="page-title">제휴문의 관리</div>

            <hr>
            <div class="content">
                <!-- 제휴문의 -->
                <div class="search-container">
                    <input type="date" v-model="startDate" class="search-date">
                    ~
                    <input type="date" v-model="endDate" class="search-date">
                    <select v-model="statusFilter" class="search-select">
                        <option value="">전체</option>
                        <option value="partnershipNo">제휴번호</option>
                        <option value="name">이름</option>
                        <option value="email">이메일</option>
                        <option value="title">제목</option>
                        <option value="psStatus">제휴상태</option>
                    </select>
                    <input type="text" v-model="keyword" class="search-input" @keyup.enter="loadFilteredData"
                        placeholder="제휴번호/이름/이메일/제목/제휴상태 검색">
                    <button class="search-button" @click="loadFilteredData">검색</button>
                </div>
                <div v-if="loaded">
                    <table>
                        <thead>
                            <tr>
                                <th>제휴번호</th>
                                <th>이름</th>
                                <th>연락처</th>
                                <th>이메일</th>
                                <th>제목</th>
                                <th>내용</th>
                                <th>제휴상태</th>
                                <th>신청일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="partnershipList.length === 0">
                                <td colspan="10">검색 결과가 없습니다.</td>
                            </tr>
                            <!-- 제휴문의 리스트 반복 출력 -->
                            <template v-for="partnership in partnershipList">
                                <tr v-if="partnership.psStatus === '승인대기'">
                                    <!-- 제휴번호 -->
                                    <td>{{ partnership.partnershipNo }}</td>
                                    <!-- 이름 -->
                                    <td>{{ partnership.name }}</td>
                                    <!-- 연락처-->
                                    <td>{{ partnership.phone }}</td>
                                    <!-- 이메일-->
                                    <td>{{ partnership.email }}</td>
                                    <!-- 제목 -->
                                    <td>{{ partnership.title }}</td>
                                    <!-- 내용 -->
                                    <td>{{ partnership.content }}</td>
                                    <!-- 제휴상태 -->
                                    <td>{{partnership.psStatus}}</td>
                                    <!-- 신청일-->
                                    <td>{{ partnership.psCreatedAt }}</td>
                                    <td>
                                        <select v-model="partnership.psStatus" @change="fnStatusEdit">
                                            <option value="승인대기">승인대기</option>
                                            <option value="승인완료">승인완료</option>
                                            <option value="승인거부">승인거부</option>
                                        </select>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                    <div style="margin-top: 20px; text-align: center;">
                        <button class="tab-btn" @click="goPage(page - 1)" :disabled="page === 1">이전</button>
                        <button v-for="p in totalPages" :key="p" class="tab-btn" :class="{ active: p === page }"
                            @click="goPage(p)">
                            {{ p }}
                        </button>
                        <button class="tab-btn" @click="goPage(page + 1)" :disabled="page === totalPages">다음</button>
                    </div>
                </div>
                <p v-else style="text-align:center;">데이터를 불러오는 중입니다...</p>
                <hr>
                <!-- 제휴 중 -->
                <div class="search-container">
                    <input type="date" v-model="startDate" class="search-date">
                    ~
                    <input type="date" v-model="endDate" class="search-date">
                    <select v-model="statusFilter" class="search-select">
                        <option value="">전체</option>
                        <option value="partnershipNo">제휴번호</option>
                        <option value="name">이름</option>
                        <option value="email">이메일</option>
                        <option value="title">제목</option>
                    </select>
                    <input type="text" v-model="keyword" class="search-input" @keyup.enter="loadFilteredData"
                        placeholder="제휴번호/이름/이메일/제목 검색">
                    <button class="search-button" @click="loadFilteredData">검색</button>
                </div>
                <div v-if="loaded">
                    <table>
                        <thead>
                            <tr>
                                <th>제휴번호</th>
                                <th>이름</th>
                                <th>연락처</th>
                                <th>이메일</th>
                                <th>제목</th>
                                <th>내용</th>
                                <th>신청일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="partnershipList.length === 0">
                                <td colspan="10">검색 결과가 없습니다.</td>
                            </tr>
                            <!-- 제휴문의 리스트 반복 출력 -->
                            <template v-for="partnership in partnershipList">
                                <tr v-if="partnership.psStatus === '승인완료'">
                                    <!-- 제휴번호 -->
                                    <td>{{ partnership.partnershipNo }}</td>
                                    <!-- 이름 -->
                                    <td>{{ partnership.name }}</td>
                                    <!-- 연락처-->
                                    <td>{{ partnership.phone }}</td>
                                    <!-- 이메일-->
                                    <td>{{ partnership.email }}</td>
                                    <!-- 제목 -->
                                    <td>{{ partnership.title }}</td>
                                    <!-- 내용 -->
                                    <td>{{ partnership.content }}</td>
                                    <!-- 신청일-->
                                    <td>{{ partnership.psCreatedAt }}</td>
                                    <td>
                                        <button class="btn-manage" @click="fnPartnershipInfo(partnership)">
                                            보기
                                        </button>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                    <div style="margin-top: 20px; text-align: center;">
                        <button class="tab-btn" @click="goPage(page - 1)" :disabled="page === 1">이전</button>
                        <button v-for="p in totalPages" :key="p" class="tab-btn" :class="{ active: p === page }"
                            @click="goPage(p)">
                            {{ p }}
                        </button>
                        <button class="tab-btn" @click="goPage(page + 1)" :disabled="page === totalPages">다음</button>
                    </div>
                </div>
                <p v-else style="text-align:center;">데이터를 불러오는 중입니다...</p>
            </div>
            <div v-if="showPartnershipModal" class="modal-overlay" @click.self="fnClosePartnershipModal">
                <div class="modal-content">
                    <h2>제휴 문의</h2>
                    <!-- 테이블 시작 -->
                    <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                        <tbody>
                            <!-- 상태 -->
                            <tr>
                                <td style="width: 120px; background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    제휴번호
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <input type="text" v-model="partnershipInfo.partnershipNo" readonly
                                        style="width: 97%; padding: 5px;" />
                                </td>
                                <td style="width: 120px; background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    제휴상태
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <select v-model="editPsStatus">
                                        <option value="승인대기">승인대기</option>
                                        <option value="승인완료">승인완료</option>
                                        <option value="승인거부">승인거부</option>
                                    </select>
                                </td>
                            </tr>
                            <!-- 이름, 연락처 -->
                            <tr>
                                <td style="width: 120px; background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    이름
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <input type="text" v-model="partnershipInfo.name" readonly
                                        style="width: 97%; padding: 5px;" />
                                </td>
                                <td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    연락처
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <input type="text" v-model="partnershipInfo.phone" readonly
                                        style="width: 97%; padding: 5px;" />
                                </td>
                            </tr>
                            <!-- 이메일 -->
                            <tr>
                                <td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    제목
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <input type="text" v-model="partnershipInfo.email" readonly
                                        style="width: 97%; padding: 5px;" />
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #f4f4f4; text-align: center; 
										   border: 1px solid #ccc; padding: 10px;">
                                    제목
                                </td>
                                <td style="border: 1px solid #ccc; padding: 10px;">
                                    <input type="text" v-model="partnershipInfo.title" readonly
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
                                    <textarea v-model="partnershipInfo.content" readonly
                                        style="width: 97%; height: 100px; padding: 5px; resize: none;"></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="margin-top: 20px;">
                        <button class="btn-manage" @click="fnStatusEdit">저장</button>
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
                    partnershipList: [],
                    sessionId: "${sessionId}",
                    sessionRole: "${sessionRole}",
                    showPartnershipModal: false,// 답변 모달 표시 여부
                    partnershipInfo: {},
                    editPsStatus: null, // 현재 선택된 문의 정보
                    startDate: "",
                    endDate: "",
                    keyword: "",
                    page: 1,
                    size: 10,
                    totalCount: 0,
                    totalPages: 1,
                    statusFilter: "",
                    loaded: false
                };
            },
            methods: {
                loadFilteredData() {
                    this.page = 1;
                    this.fnGetPartnershipList();
                },
                // 문의 목록 불러오기
                fnGetPartnershipList() {
                    let self = this;
                    let nparmap = {
                        startDate: self.startDate,
                        endDate: self.endDate,
                        statusFilter: self.statusFilter,
                        keyword: self.keyword,
                        page: self.page,
                        size: self.size,
                    };
                    $.ajax({
                        url: "/admin/partnership.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result === "success") {
                                self.partnershipList = data.partnershipList;
                                self.totalCount = data.totalCount;
                                self.totalPages = Math.ceil(self.totalCount / self.size);
                                self.loaded = true;
                            } else {
                                alert("데이터를 불러오는데 실패했습니다.");
                            }
                        },
                        error: function (err) {
                            console.error(err);
                        }
                    });
                },
                goPage(p) {
                    if (p < 1 || p > this.totalPages) return;
                    this.page = p;
                    this.fnGetPartnershipList();
                },
                fnStatusEdit(partnershipNo) {
                    let self = this;
                    let nparmap = {
                        partnershipNo: partnershipNo,
                        psStatus: self.editPsStatus
                    };

                    $.ajax({
                        url: "/admin/partnership-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: nparmap,
                        success: function (data) {
                            console.log(data);
                            if (data.result === "success") {
                                alert("변경되었습니다.");
                                self.fnClosePartnershipModal();
                                self.fnGetPartnershipList(); // 목록 갱신
                            } else {
                                alert("변경 실패");
                            }
                        },
                        error: function (err) {
                            console.error(err);
                            alert("변경 중 오류가 발생했습니다.");
                        }
                    });
                },
                // '답변' 버튼 클릭 시 모달 열기
                fnPartnershipInfo(partnership) {
                    this.showPartnershipModal = true;
                    this.editPsStatus = partnership.psStatus; // 원본 답변 복사
                },

                // 모달 닫기
                fnClosePartnershipModal() {
                    this.showPartnershipModal = false;
                    this.editPsStatus = "";
                },
            },
            mounted() {
                let self = this;
                if (!self.sessionId || self.sessionRole != 'ADMIN') {
                    alert("관리자만 이용가능합니다.");
                    location.href = "/main.do";
                }
                self.fnGetPartnershipList();
            }
        });
        app.mount('#app');
    </script>